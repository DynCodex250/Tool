
key   <- function(x) toupper(x)
extra <- copy$Duties[!key(copy$Duties$DUTYIDENTIFIER) %in% key(aot$Duties$DUTYIDENTIFIER), ]
extra[, c("DUTYIDENTIFIER", "DUTYNAME", "ASSIGNMENT", "SUBROLES", "NEED")]

# Building blocks assigned directly that differ (duties, privileges, sub-roles)
block <- function(r) paste(r$Blocks$BLOCK_TYPE, key(r$Blocks$BLOCK_ID))
setdiff(block(copy), block(aot))
setdiff(block(aot), block(copy))

copy$RoleNeed
copy$Role$SOURCE
