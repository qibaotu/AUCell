# Help files will be automatically generated from the coments starting with #'
# (https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html)

#' @importFrom graphics plot.new
#' @importFrom graphics par
#' @importFrom graphics boxplot
#' @importFrom graphics mtext
#' @importFrom stats quantile
#'
#' @import data.table
#' @title plotGeneCount
#' @description Plots a histogram and boxplot for the number of genes
#' detected in each cell.
#' @param exprMat Expression matrix (genes as rows, cells as columns)
#' @param verbose Should the function show progress messages? (TRUE / FALSE)
#' @return Quantiles with the number of genes detected by cell (invisible).
#' his result is also printed if verbose=TRUE.
#' @details
#' It is important to check that most cells have at least the number of
#' expressed/detected genes that are going to be used to calculate the AUC
#' (`aucMaxRank` in `calcAUC()`). The histogram provided by
#' `AUCell_buildRankings()` allows to quickly check this distribution.
#' `plotGeneCount(exprMatrix)` allows to obtain only the plot before
#' building the rankings.
#' @seealso See the package vignette for more details: \code{vignette("AUCell")}
#' @examples
#' ### (Fake expression matrix)
#' exprMatrix <- matrix(sample(c(rep(0, 500), sample(1:3, 500, replace=TRUE))),
#'  nrow=20)
#' rownames(exprMatrix) <- paste("Gene", 1:20, sep="")
#' colnames(exprMatrix) <- paste("Sample", 1:50, sep="")
#' ###
#'
#' plotGeneCount(exprMatrix)
#' title(sub="Fake expression matrix")
#'
#' @export

# Used by buildRankings
# Input: matrix or data.table
# If data.table, do not include the "rn" column (rownames)

plotGeneCount <- function(exprMat, verbose=TRUE)
{
  if((data.table::is.data.table(exprMat)) && (colnames(exprMat)[1] == "rn"))
    stop('The data.table contains a column with rownames (to skip, i.e. dt[,-"rn", with=FALSE]')
  countByCell <- colSums(exprMat>0)
  sampleType <- "cell"
  plot.new()
  par(fig=c(0,1,0.55,1), new=TRUE)
  na <- boxplot(countByCell, ylim=c(0,max(countByCell)), range=0,
                col="skyblue", cex.axis=.75, horizontal=TRUE, axes=FALSE)
  par(fig=c(0,1,0,.8), new=TRUE)
  na <- hist(countByCell, main="", col="skyblue", xlab="# of genes",
             ylab="# of cells", cex.axis=.75, xlim=c(0,max(countByCell)))
  mtext("# of genes detected by cell", side=3, outer=TRUE, line=-3, cex=2)

  ret <- c(min=min(countByCell),quantile(countByCell, c(.01,.05, .10, .50, 1)))
  if(verbose){
    message("Quantiles for the number of genes detected by cell: \n",
          "(Non-detected genes are shuffled at the end of the ranking.",
          "Keep in mind when choosing the threshold for calculating the AUC).")
    print(ret)
  }
  invisible(ret)
}
