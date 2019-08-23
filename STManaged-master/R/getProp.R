# summary for each row (get proportion for each row of the landscape)
getProp <- function(x, nRow) {
 B <- sum(x == 1)/nRow
 T <- sum(x == 2)/nRow
 M <- sum(x == 3)/nRow
 R <- 1 - sum(B, T, M)
 return(setNames(c(B, T, M, R), c('B', 'T', 'M', 'R')))
}
