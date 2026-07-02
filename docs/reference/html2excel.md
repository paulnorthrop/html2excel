# Convert HTML Tables to Excel Files

Reads tables from HTML documents using
[`rvest::read_html`](http://xml2.r-lib.org/reference/read_xml.md) and
[`rvest::html_table`](https://rvest.tidyverse.org/reference/html_table.html).
The tables are returned as tibbles and may be written to Excel `.xlsx`
files using
[`openxlsx::write.xlsx`](https://rdrr.io/pkg/openxlsx/man/write.xlsx.html).

## Usage

``` r
html2excel(
  html,
  ext = "*.html",
  write = TRUE,
  sheets,
  dir,
  read_args = list(),
  html_args = list(),
  write_args = list()
)
```

## Arguments

- html:

  A character vector containing one of the following:

  - paths to HTML files,

  - a path to a directory that contains HTML files,

  - URLs, that is, strings beginning with `www.`, `http:` or `https:`.

- ext:

  A character scalar. If `html` is a path to a directory, then `ext`
  determines the extensions of files that should be read from `dir`. The
  default is only to read files with an `.html` extension.
  `utils::glob2rx(ext)` is used to create the `pattern` argument to
  [`list.files`](https://rdrr.io/r/base/list.files.html). For example,
  if `ext = "*.htm*"` then all files with extensions that start with
  `htm` are read.

- write:

  A logical scalar. Should the tibbles be written to Excel `.xlsx` files
  using
  [`openxlsx::write.xlsx`](https://rdrr.io/pkg/openxlsx/man/write.xlsx.html)?

- sheets:

  A numeric vector or list of numeric vectors. Component `i` of the
  vector or list gives the number(s) of the tables to be included as
  sheets in the `i`th output Excel file. This argument is recycled to
  the number of output Excel files. If `sheets` is not supplied then all
  sheets are included.

- dir:

  A path to a directory. If `html` contains URLs then the resulting
  Excel files are written to directory `dir`. If `dir` does not exist
  then it is created.

- read_args:

  A list of arguments for
  [`rvest::read_html`](http://xml2.r-lib.org/reference/read_xml.md).

- html_args:

  A list of arguments for
  [`rvest::html_table`](https://rvest.tidyverse.org/reference/html_table.html).

- write_args:

  A list of arguments for
  [`openxlsx::write.xlsx`](https://rdrr.io/pkg/openxlsx/man/write.xlsx.html),
  but not `file`, as this is determined from the input HTML filenames
  and, for URLs, `dir`.

## Value

An object of class `c("html2excel", "list")`. A list of (lists of)
tibbles created from objects returned from
[`rvest::html_table`](https://rvest.tidyverse.org/reference/html_table.html).
The names of the list are the input HTML filenames. Each list component
is named `sheet1`, `sheet2` etc. with each sheet containing a separate
table found in the input HTML file. The numbering of these sheets is the
same as the output `.xlsx` files, not the order of the tables in the
input HTML files. If `write = TRUE` then a character vector containing
the file paths to the `.xlsx` files created is added as an attributed
named `files`.

## Details

HTML files are

- read using
  [`rvest::read_html`](http://xml2.r-lib.org/reference/read_xml.md),

- converted to tables (tibbles) using
  [`rvest::html_table`](https://rvest.tidyverse.org/reference/html_table.html),

- written to Excel documents using
  [`openxlsx::write.xlsx`](https://rdrr.io/pkg/openxlsx/man/write.xlsx.html).

The output filename for an input HTML file `file.html` is usually
`file.xlsx`. Exceptions are when a combination of `html` and `ext` means
that duplicate filenames would be produced, for example, if files
`file.html` and `file.mhtml` are read. Then the output filenames are
distinguished by `file_a.xlsx` and `file_b.xlsx`, and similarly if there
are more than two identical filenames.

## Examples

``` r
### HTML files

## .html and .mhtml versions of the URL example below
html <- system.file("extdata", "tables.html", package = "html2excel")
mhtml <- system.file("extdata", "tables.mhtml", package = "html2excel")

## .html
# Table 5 only
t1 <- html2excel(html, sheets = 5)
# The table
t1[[1]]
# The dimensions of the table
summary(t1)

## .mhtml
# Pass UTF-8 encoding to avoid error "Unsupported encoding: 3DUTF-8"
t2 <- html2excel(mhtml, read_args = list(encoding = "UTF-8"))
# The same table as above
t2[[1]][5]
# The dimensions of all tables
summary(t2)

### A directory

## Contains the .html and .mhtml files above
dir <- system.file("extdata", package = "html2excel")
# Change the ext argument to include the .mhtml file
# Extract tables 3 and 5 from .html and table 5 from .mhtml
x <- html2excel(dir, ext = "*.*html", sheets = list(c(3, 5), 5),
                read_args = list(encoding = "UTF-8"))

# \dontrun{
### A URL
url <- "https://afd.calpoly.edu/web/sample-tables"
x <- html2excel(url, dir = ".")
# }
```
