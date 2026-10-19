
The tested role is a subset of the UI copy. The copy has all 150 duties of the tested role plus 5 more; nothing is only in the tested role.

What that means

For the 32 users who have both roles, the tested role adds nothing; all their rights also come from the UI copy. Removing the UI copy would take those 5 duties away from them.
My earlier guess that the UI role is the old version does not hold. It is the more complete one, and the price-block-list duties look like later additions made only in the user interface.
For licenses: whatever you change in the tested role alone has no effect for these 32 users. A change, such as dropping the Commerce duty for users who don't need it, has to be made in the role that stays, and the other one has to go.
The 5 duties only in the UI copy

Next: what are the 5 duties, and do they need a base license? Run this in the same session and send me the output:

key   <- function(x) toupper(x)
extra <- copy$Duties[!key(copy$Duties$DUTYIDENTIFIER) %in% key(aot$Duties$DUTYIDENTIFIER), ]
extra[, c("DUTYIDENTIFIER", "DUTYNAME", "ASSIGNMENT", "SUBROLES", "NEED")]

Building blocks assigned directly that differ (duties, privileges, sub-roles)

block <- function(r) paste(r$Blocks$BLOCK_TYPE, key(r$Blocks$BLOCK_ID))
setdiff(block(copy), block(aot))
setdiff(block(aot), block(copy))

copy$RoleNeed
copy$Role$SOURCE
