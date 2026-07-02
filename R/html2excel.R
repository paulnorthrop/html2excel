#' Convert HTML Tables to Excel Files
#'
#' Reads tables from HTML documents using [`rvest::read_html`] and
#' [`rvest::html_table`]. The tables are returned as tibbles and may be written
#' to Excel `.xlsx` files using [`openxlsx::write.xlsx`].
#'
#' @param html A character vector containing one of the following:
#'
#' * paths to HTML files,
#' * a path to a directory that contains HTML files,
#' * URLs, that is, strings beginning with `www.`, `http:` or `https:`.
#'
#' @param ext A character scalar. If `html` is a path to a directory, then
#'  `ext` determines the extensions of files that should be read from `dir`.
#'  The default is only to read files with an `.html` extension.
#'  `utils::glob2rx(ext)` is used to create the `pattern` argument to
#'  [`list.files`]. For example, if `ext = "*.htm*"` then all files with
#'  extensions that start with `htm` are read.
#' @param write A logical scalar. Should the tibbles be written to Excel
#'   `.xlsx` files using [`openxlsx::write.xlsx`]?
#' @param sheets A numeric vector or list of numeric vectors. Component `i`
#'   of the vector or list gives the number(s) of the tables to be included as
#'   sheets in the `i`th output Excel file. This argument is recycled to the
#'   number of output Excel files. If `sheets` is not supplied then all sheets
#'   are included.
#' @param dir A path to a directory. If `html` contains URLs then the resulting
#'   Excel files are written to directory `dir`. If `dir` does not exist then
#'   it is created.
#' @param read_args A list of arguments for [`rvest::read_html`].
#' @param html_args A list of arguments for [`rvest::html_table`].
#' @param write_args A list of arguments for [`openxlsx::write.xlsx`], but not
#'   `file`, as this is determined from the input HTML filenames and, for URLs,
#'   `dir`.
#'
#' @details HTML files are
#'
#' * read using [`rvest::read_html`],
#' * converted to tables (tibbles) using [`rvest::html_table`],
#' * written to Excel documents using [`openxlsx::write.xlsx`].
#'
#' The output filename for an input HTML file `file.html` is usually
#' `file.xlsx`. Exceptions are when a combination of `html` and `ext` means
#' that duplicate filenames would be produced, for example, if files
#' `file.html` and `file.mhtml` are read. Then the output filenames are
#' distinguished by `file_a.xlsx` and `file_b.xlsx`, and similarly if there are
#' more than two identical filenames.
#'
#' @return An object of class `c("html2excel", "list")`. A list of (lists of)
#'   tibbles created from objects returned from [`rvest::html_table`].
#'   The names of the list are the input HTML filenames. Each list component
#'   is named `sheet1`, `sheet2` etc. with each sheet containing a separate
#'   table found in the input HTML file. The numbering of these sheets is the
#'   same as the output `.xlsx` files, not the order of the tables in the
#'   input HTML files.
#'   If `write = TRUE` then a character vector containing the file paths to the
#'   `.xlsx` files created is added as an attributed named `files`.
#' @examples
#' ### HTML files
#'
#' ## .html and .mhtml versions of the URL example below
#' html <- system.file("extdata", "tables.html", package = "html2excel")
#' mhtml <- system.file("extdata", "tables.mhtml", package = "html2excel")
#'
#' ## .html
#' # Table 5 only
#' t1 <- html2excel(html, sheets = 5)
#' # The table
#' t1[[1]]
#' # The dimensions of the table
#' summary(t1)
#'
#' ## .mhtml
#' # Pass UTF-8 encoding to avoid error "Unsupported encoding: 3DUTF-8"
#' t2 <- html2excel(mhtml, read_args = list(encoding = "UTF-8"))
#' # The same table as above
#' t2[[1]][5]
#' # The dimensions of all tables
#' summary(t2)
#'
#' ### A directory
#'
#' ## Contains the .html and .mhtml files above
#' dir <- system.file("extdata", package = "html2excel")
#' # Change the ext argument to include the .mhtml file
#' # Extract tables 3 and 5 from .html and table 5 from .mhtml
#' x <- html2excel(dir, ext = "*.*html", sheets = list(c(3, 5), 5),
#'                 read_args = list(encoding = "UTF-8"))
#'
#' ### A URL
#' url <- "https://afd.calpoly.edu/web/sample-tables"
#' \dontrun{
#' x <- html2excel(url, dir = ".")}
#' @export
html2excel <- function(html, ext = "*.html", write = TRUE, sheets, dir,
                       read_args = list(), html_args = list(),
                       write_args = list()) {

  # Does html contain URLs, files or directories?
  html_type <- urls_files_or_directory(x = html)
  if (html_type == "mixed") {
    stop("''html'' must contain only URLs, only HTML files or a directory")
  }

  # For a directory, create a vector paths to HTML files in this directory
  if (html_type == "directory") {
    files <- list.files(path = html, pattern = utils::glob2rx(ext))
    html <- file.path(html, files)
  }
  # Check for duplicate filenames and distinguish them if necessary
  html_no_extensions <- tools::file_path_sans_ext(html)
  if (any(duplicated(html_no_extensions))) {
    html_output <- distinguish_repeated_filenames(html_no_extensions)
  } else {
    html_output <- html
  }

  # Read each HTML file to produce an XML document
  read_args <- c(list(X = html, FUN = rvest::read_html), read_args)
  xml_documents <- do.call(lapply, read_args)
  # For each XML document extract all tables (a list of tibbles)
  html_args <- c(list(X = xml_documents, FUN = rvest::html_table), html_args)
  tibbles <- do.call(lapply, html_args)

  # If sheets has been supplied then recycle it to the appropriate length
  # to select only the required sheets
  if (!missing(sheets)) {
    if (length(html) == 1) {
      tibbles <- list(tibbles[[1]][sheets])
    } else {
      sheets <- rep_len(sheets, length(html))
      select_tibble_sheets <- function(i) {
        return(tibbles[[i]][sheets[[i]]])
      }
      tibbles <- lapply(X = 1:length(sheets), FUN = select_tibble_sheets)
    }
  }

  # Create output filenames
  if (html_type == "urls") {
    if (!dir.exists(dir)) {
      dir.create(dir)
    }
    output_xlsx <- file.path(dir, paste0(basename(html_output), ".xlsx"))
  } else {
    output_xlsx <- paste0(tools::file_path_sans_ext(html_output), ".xlsx")
  }

  # If write = TRUE then write the tables to Excel .xlsx files
  if (write) {
    write_xlsx_files <- function(i, ...) {
      openxlsx::write.xlsx(x = tibbles[[i]], file = output_xlsx[i], ...)
    }
    write_args <- c(list(X = 1:length(html), FUN = write_xlsx_files),
                    write_args)
    do.call(lapply, write_args)
    attr(tibbles, "files") <- output_xlsx
  }

  # Give tibbles meaningful names
  names(tibbles) <- html
  for (i in 1:length(tibbles)) {
    names(tibbles[[i]]) <- paste0("sheet", 1:length(tibbles[[i]]))
  }

  # Include "html2excel" in the class of the returned object
  class(tibbles) <- c("html2excel", class(tibbles))
  return(tibbles)
}
