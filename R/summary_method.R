#' Summarising `html2excel` objects
#'
#' `summary` method for class `html2excel`.
#'
#' @param object An object inheriting from class `"html2excel"` returned from
#'   [`html2excel`].
#' @param ... Further arguments to be passed to [`print.default`].
#' @details The default `print` method for a list of tibbles prints the
#'   dimensions of the tibbles and up to 10 rows and 6 columns of each tibble.
#'   `summary.html2excel` prints a shorter summary that contains only the
#'   dimensions of the tibbles. These `print` and/or `summary` methods may be
#'   helpful in deciding which sheets are required for which excel file, that
#'   is, how to set the argument `sheets` to [`html2excel`].
#' @return A list containing the dimensions (number of rows and number of
#'   columns) of each tibble.
#' @section Examples: See [`html2excel`].
#' @seealso [`html2excel`].
#' @name summary.html2excel
NULL
## NULL

#' @rdname summary.html2excel
#' @export
summary.html2excel <- function(object, ...) {
  dim_fn <- function(i) {
    return(X = lapply(object[[i]], FUN = dim))
  }
  table_dimensions <- lapply(X = 1:length(object), FUN = dim_fn)
  names(table_dimensions) <- names(x)
  class(table_dimensions) <- "summary.evmissing"
  return(table_dimensions)
}

#' @rdname summary.html2excel
#' @export
print.summary.html2excel <- function(x, ...) {
  print.default(x, ...)
  return(invisible(x))
}
