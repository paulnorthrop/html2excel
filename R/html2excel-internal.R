#' Internal html2excel functions
#'
#' Internal html2excel functions
#' @details
#' These functions are not intended to be called by the user.
#' @name html2excel-internal
#' @keywords internal
NULL

#' @keywords internal
#' @rdname html2excel-internal
is_url <-function(x) {
  return(grepl("www.|http:|https:", x))
}

#' @keywords internal
#' @rdname html2excel-internal
is_directory <- function(x) {
  isdir <- file.info(unlist(x))$isdir
  isdir[is.na(isdir)] <- FALSE
  return(isdir)
}

#' @keywords internal
#' @rdname html2excel-internal
urls_files_or_directory <- function(x) {
  are_directories <- is_directory(x)
  if (length(x) > 1 && all(are_directories)) {
    stop("''x'' may contain only one directory")
  }
  if (all(are_directories)) {
    return("directory")
  }
  are_urls <- is_url(x)
  if (all(are_urls)) {
    return("urls")
  }
  if (!any(are_urls) && !any(are_directories)) {
    return("files")
  }
  return("mixed")
}

#' @keywords internal
#' @rdname html2excel-internal
distinguish_repeated_filenames <- function(vec) {

  # Track counts of each name
  counts <- integer(length(vec))
  names(counts) <- vec
  # Output vector
  res <- character(length(vec))
  # Letters to append (repeats after 'z' with 'aa', 'ab', etc.)
  letter_seq <- function(n) {
    # Generate sequence like a, b, ..., z, aa, ab, ...
    rep_len <- function(x, n) x[seq_len(n)]
    letters_all <- c(letters, outer(letters, letters, paste0))
    rep_len(letters_all, n)
  }
  # Add extra letter(s) where necessary
  for (i in seq_along(vec)) {
    name <- vec[i]
    if (name %in% vec[1:(i - 1)]) {
      counts[name] <- counts[name] + 1
      suffix <- letter_seq(counts[name])[counts[name]]
      res[i] <- paste(name, suffix, sep = "_")
    } else {
      counts[name] <- 0
      res[i] <- name
    }
  }

  return(res)
}

#' @keywords internal
#' @rdname html2excel-internal
change_xlsx_directory <- function(filename, dir = "output") {
  is_xlsx <- tools::file_ext(filename) == "xlsx"
  if (any(is_xlsx)) {
    filename[is_xlsx] <- paste0(dirname(filename[is_xlsx]),
                                "/", dir, "/", basename(filename))
    dir_path <- dirname(filename[is_xlsx])
    lapply(dir_path[!dir.exists(dir_path)], dir.create)
  }
  return(filename)
}
