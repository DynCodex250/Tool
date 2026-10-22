# =============================================================================
# check_duty_against_role()
#
# Which objects of one or more duties or privileges does another role already
# grant, and which of the privileges could be added to that role without
# needing more than one license? Built for the question: does the SCM version of
# a role still hold the objects of a Commerce duty that SCM covers as well?
#
# Reads both roles from the license graph of D365, the table
# LicensingSecurityObjectExplodedGraph. Needs the code files of the playbook
# (chunk "appendix-files") and a connection (chunk "connection").
#
# Objects are compared by name, as in the role license report, with their
# access level: a role that only reads an object the duty writes has a gap.
#
# Give duties, privileges or both. Everything given is checked together: each
# object counts once, and the column DUTIES names the duties it comes from;
# "(no duty)" stands for a privilege assigned to a role directly.
#
# Examples:
#
#   source("check_duty_against_role.R")
#
#   result <- check_duty_against_role(
#     con         = cnn,
#     source_role = "_WIBU_VERKAUF_INNENDIENST_MITARBEITER",
#     duty        = c("RetailDiscountOfferMaintain", "RetailDiscountOfferView"),
#     target_role = "5CDA51EB-9559-4B27-88C4-14601045B1F0",
#     license     = "Supply Chain Management",
#     export_path = file.path(export_folder, "Duty_check.xlsx")
#   )
#
#   result <- check_duty_against_role(
#     con         = cnn,
#     source_role = "_WIBU_VERKAUF_INNENDIENST_MITARBEITER",
#     privilege   = c("GUPPriceSimulatorProcess", "GUPPriceReportMaintain"),
#     target_role = "5CDA51EB-9559-4B27-88C4-14601045B1F0"
#   )
#
#   result$Summary       objects of what was checked, by group and state
#   result$Gaps          objects the license covers that the role lacks
#   result$Privileges    the privileges checked; CAN_BE_ADDED = TRUE closes gaps
#   result$NotClosable   gaps no privilege covered by the license can close
# =============================================================================

check_duty_against_role <- function(
  con,
  source_role,
  duty        = NULL,
  privilege   = NULL,
  target_role,
  license     = "Supply Chain Management",
  export_path = NULL
) {

  .check_names_to_check(duty, privilege)

  skus <- .load_license_skus(con)
  if (!license %in% skus$SKUNAME) {
    stop("Unknown license '", license, "'. LicensingAllSkus lists: ", paste(skus$SKUNAME, collapse = ", "))
  }

  source_graph <- .load_role_license_graph(con, source_role)
  .check_names_in_graph(source_graph, duty, privilege, source_role)
  duty_rows <- .duty_rows_with_coverage(source_graph, duty, privilege, skus, license)

  target <- .load_role_license_graph(con, target_role)
  if (nrow(target) == 0L) {
    stop("The license graph holds no rows for role '", target_role, "'.")
  }

  objects    <- .duty_objects_in_target(duty_rows, target, license)
  privileges <- .duty_privileges_for_target(duty_rows, objects, target)
  gaps       <- .duty_gaps(duty_rows, objects, privileges)

  result <- list(
    Summary     = .duty_check_summary(objects),
    Gaps        = gaps,
    Privileges  = privileges,
    NotClosable = gaps[is.na(gaps$CLOSED_BY), ]
  )

  message(
    paste(c(duty, privilege), collapse = ", "), ": ", nrow(objects), " objects, ", nrow(gaps), " gaps in role ", target_role,
    ". ", sum(privileges$CAN_BE_ADDED), " privileges covered by ", license, " can be added; they close ",
    sum(!is.na(gaps$CLOSED_BY)), " of the ", nrow(gaps), " gaps."
  )

  if (!is.null(export_path)) {
    openxlsx::write.xlsx(result, export_path, overwrite = TRUE)
  }

  result
}

# duty and privilege: each NULL or names; at least one of them given.
.check_names_to_check <- function(duty, privilege) {

  is_names <- function(x) is.null(x) || (is.character(x) && length(x) > 0L && !anyNA(x) && all(nzchar(x)))

  if (!is_names(duty) || !is_names(privilege) || (is.null(duty) && is.null(privilege))) {
    stop(
      "Name one or more duties or privileges, for example ",
      "duty = c(\"RetailDiscountOfferMaintain\", \"RetailDiscountOfferView\") or ",
      "privilege = c(\"GUPPriceSimulatorProcess\", \"GUPPriceReportMaintain\")."
    )
  }

  invisible(TRUE)
}

# A misspelt name would otherwise drop out of the check without a word.
.check_names_in_graph <- function(graph, duty, privilege, role) {

  unknown <- c(
    duty[!.identifier_key(duty) %in% .identifier_key(graph$DUTYIDENTIFIER)],
    privilege[!.identifier_key(privilege) %in% .identifier_key(graph$PRIVILEGEIDENTIFIER)]
  )

  if (length(unknown) > 0L) {
    stop("The license graph holds no objects of ", paste0("'", unknown, "'", collapse = ", "), " in role '", role, "'.")
  }

  invisible(TRUE)
}

# Where a privilege sits: its duty, or "(no duty)" when it is assigned to a role directly.
.duty_label <- function(duty) {
  dplyr::if_else(is.na(duty) | !nzchar(duty), "(no duty)", duty)
}

# The rows of the duties and privileges with the licenses that cover each row.
.duty_rows_with_coverage <- function(graph, duty, privilege, skus, license) {

  wanted <- .identifier_key(graph$DUTYIDENTIFIER) %in% .identifier_key(duty) |
    .identifier_key(graph$PRIVILEGEIDENTIFIER) %in% .identifier_key(privilege)
  rows <- graph[wanted, ]
  if (nrow(rows) == 0L) {
    return(rows)
  }

  texts    <- unique(rows$LICENSE)
  covering <- lapply(texts, .graph_covering_skus, skus = skus, base_group_pattern = "^Base")
  cover    <- covering[match(rows$LICENSE, texts)]

  dplyr::mutate(
    rows,
    KEY             = .identifier_key(SECURABLENAME),
    ACCESS          = as.numeric(ACCESSLEVEL),
    LICENSE_COVERS  = vapply(cover, function(x) license %in% x, logical(1)),
    ACTIVITY_COVERS = vapply(cover, function(x) .ACTIVITY_SKU %in% x, logical(1))
  )
}

.duty_check_groups <- function(license) {
  c(
    paste("1 not covered by", license),
    paste0("2 base license, ", license, " covers"),
    "3 Activity or lower"
  )
}

# One row per object of the duty: what it needs, and what the target role grants.
.duty_objects_in_target <- function(duty_rows, target, license) {

  granted <- target |>
    dplyr::mutate(KEY = .identifier_key(SECURABLENAME)) |>
    dplyr::group_by(KEY) |>
    dplyr::summarise(TARGET_ACCESS = max(as.numeric(ACCESSLEVEL)), .groups = "drop")
  groups <- .duty_check_groups(license)

  duty_rows |>
    dplyr::group_by(KEY) |>
    dplyr::summarise(
      OBJECT     = dplyr::first(SECURABLENAME),
      ACCESS     = max(ACCESS),
      LICENSE    = paste(sort(unique(LICENSE)), collapse = " / "),
      COVERED    = all(LICENSE_COVERS),
      BELOW_BASE = all(ACTIVITY_COVERS),
      DUTIES     = paste(sort(unique(.duty_label(DUTYIDENTIFIER))), collapse = ", "),
      PRIVILEGES = paste(sort(unique(PRIVILEGEIDENTIFIER)), collapse = ", "),
      .groups    = "drop"
    ) |>
    dplyr::left_join(granted, by = "KEY") |>
    dplyr::mutate(
      GROUP = dplyr::case_when(!COVERED ~ groups[[1]], !BELOW_BASE ~ groups[[2]], TRUE ~ groups[[3]]),
      STATE = dplyr::case_when(
        is.na(TARGET_ACCESS)   ~ "missing",
        TARGET_ACCESS < ACCESS ~ "only read",
        TRUE                   ~ "in the role"
      )
    )
}

# An object the license covers that the target role lacks or only reads.
.is_duty_gap <- function(objects) {
  !startsWith(objects$GROUP, "1 ") & objects$STATE != "in the role"
}

.duty_privileges_for_target <- function(duty_rows, objects, target) {

  gaps      <- objects$KEY[.is_duty_gap(objects)]
  in_target <- unique(.identifier_key(target$PRIVILEGEIDENTIFIER))

  duty_rows |>
    dplyr::group_by(PRIVILEGE = PRIVILEGEIDENTIFIER) |>
    dplyr::summarise(
      NAME        = dplyr::first(PRIVILEGENAME),
      DUTIES      = paste(sort(unique(.duty_label(DUTYIDENTIFIER))), collapse = ", "),
      OBJECTS     = dplyr::n_distinct(KEY),
      NOT_COVERED = dplyr::n_distinct(KEY[!LICENSE_COVERS]),
      GAPS        = dplyr::n_distinct(KEY[KEY %in% gaps]),
      .groups     = "drop"
    ) |>
    dplyr::mutate(
      IN_ROLE_ALREADY = .identifier_key(PRIVILEGE) %in% in_target,
      CAN_BE_ADDED    = NOT_COVERED == 0L & !IN_ROLE_ALREADY & GAPS > 0L
    ) |>
    dplyr::arrange(dplyr::desc(CAN_BE_ADDED), dplyr::desc(GAPS), PRIVILEGE)
}

# The gaps, each with the privileges that close it at the access it needs.
.duty_gaps <- function(duty_rows, objects, privileges) {

  addable <- privileges$PRIVILEGE[privileges$CAN_BE_ADDED]
  closing <- duty_rows[duty_rows$PRIVILEGEIDENTIFIER %in% addable, c("KEY", "PRIVILEGEIDENTIFIER", "ACCESS")] |>
    dplyr::inner_join(dplyr::select(objects, KEY, NEEDED = ACCESS), by = "KEY") |>
    dplyr::filter(ACCESS >= NEEDED) |>
    dplyr::group_by(KEY) |>
    dplyr::summarise(CLOSED_BY = paste(sort(unique(PRIVILEGEIDENTIFIER)), collapse = ", "), .groups = "drop")

  objects[.is_duty_gap(objects), ] |>
    dplyr::left_join(closing, by = "KEY") |>
    dplyr::arrange(GROUP, OBJECT) |>
    dplyr::select(GROUP, STATE, OBJECT, ACCESS, TARGET_ACCESS, LICENSE, DUTIES, PRIVILEGES, CLOSED_BY)
}

.duty_check_summary <- function(objects) {
  dplyr::count(objects, GROUP, STATE) |>
    tidyr::pivot_wider(names_from = STATE, values_from = n, values_fill = 0L)
}
