rm(list = intersect(c("key", "block", "toupper"), ls()))

extra <- copy$Duties[!base::toupper(copy$Duties$DUTYIDENTIFIER) %in% base::toupper(aot$Duties$DUTYIDENTIFIER), ]
extra[, c("DUTYIDENTIFIER", "DUTYNAME", "ASSIGNMENT", "SUBROLES", "NEED")]

blocks_aot  <- paste(aot$Blocks$BLOCK_TYPE,  base::toupper(aot$Blocks$BLOCK_ID))
blocks_copy <- paste(copy$Blocks$BLOCK_TYPE, base::toupper(copy$Blocks$BLOCK_ID))
setdiff(blocks_copy, blocks_aot)   # assigned directly only in the UI copy
setdiff(blocks_aot, blocks_copy)   # assigned directly only in the tested role
