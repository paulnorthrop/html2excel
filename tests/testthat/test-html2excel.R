# Tiago/Portico: .xlsx are really .html.
# Detect this and change the output file names to address this?
# If ext = "*.xlsx" or rather if the extensions on html are .xlsx then
# add "out" or "output" to the filename.

# Replace rvest::read_html() with xml::read_html()

# XML files?
# Unlike HTML, XML does not dictate how data is displayed; it only describes the data itself

# Create example data in inst, like accessr
# Have one example for a URL, but don't run it?
# Create tests for each type of html (files, directory, URLs)
# Create a test for summary.html2excel()
# Package help file: ?html2excel (minimal)
#   I could note that Portico produces Excel files that are in fact XML/HTML files
# README.Rmd
# Check on Github
# CRAN comments

## 1

# Check that reading .html and .mhtml versions of the same file are equivalent
# Also check that selecting a sheet a prior and a posteriori are equivalent

# Examples from html2excel()
html <- system.file("extdata", "tables.html", package = "html2excel")
t1_5 <- html2excel(html, sheets = 5)
res1 <- t1_5[[1]]$sheet1

mhtml <- system.file("extdata", "tables.mhtml", package = "html2excel")
t2 <- suppressWarnings(
  html2excel(mhtml, read_args = list(encoding = "UTF-8"))
)
res2 <- t2[[1]][5]$sheet5

test_that("html2excel(): html vs mhtml", {
  expect_equal(res1, res2)
})

## 2

# Check, using summary, that the correct tables and dimensions have been found

t1 <- html2excel(html, sheets = c(3, 5))
s <- summary(t1)
res <- list(sheet1 = c(3, 3), sheet2 = c(5, 3))

test_that("html2excel(): summary.html2excel", {
  expect_equal(res, s[[1]])
})

## 3

# Check that we get the same output from an input file regardless of
# whether it is pass directly or via the directory in which it sits

dir <- system.file("extdata", package = "html2excel")
# Change the ext argument to include the .mhtml file
# Extract tables 3 and 5 from .html and table 5 from .mhtml
x <- suppressWarnings(
  html2excel(dir, ext = "*.*html", sheets = list(c(3, 5), 5),
             read_args = list(encoding = "UTF-8"))
)

test_that("html2excel(): 1 file vs directory of 2 files", {
  expect_equal(t1[[1]], x[[1]])
})

