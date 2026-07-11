## 1

# Check that reading .html and .mhtml versions of the same file are equivalent
# Also check that selecting a sheet a prior and a posteriori are equivalent

# Create a temporary directory into which to out input thml files and write
# output Excel files
tdir <- tempdir()

# Examples from html2excel()
html <- system.file("extdata", "tables.html", package = "html2excel")
worked1 <- file.copy(from = html, to = tdir)
temp_html <- file.path(tdir, basename(html))

t1_5 <- html2excel(temp_html, sheets = 5, write = TRUE)
res1 <- t1_5[[1]]$sheet1

mhtml <- system.file("extdata", "tables.mhtml", package = "html2excel")
worked2 <- file.copy(from = mhtml, to = tdir)
temp_mhtml <- file.path(tdir, basename(mhtml))

t2 <- suppressWarnings(
  html2excel(temp_mhtml, read_args = list(encoding = "UTF-8"), write = TRUE,
             dir = "new")
)
res2 <- t2[[1]][5]$sheet5

test_that("html2excel(): html vs mhtml", {
  expect_equal(res1, res2)
})

## 2

# Check, using summary, that the correct tables and dimensions have been found

t1 <- html2excel(temp_html, sheets = c(3, 5), write = TRUE)
s <- print(summary(t1))
res <- list(sheet1 = c(3, 3), sheet2 = c(5, 3))

test_that("html2excel(): summary.html2excel", {
  expect_equal(res, s[[1]])
})

## 3

# Check that we get the same output from an input file regardless of
# whether it is passed directly or via the directory in which it sits

directory <- system.file("extdata", package = "html2excel")
# Change the ext argument to include the .mhtml file
# Extract tables 3 and 5 from .html and table 5 from .mhtml
x <- suppressWarnings(
  html2excel(directory, ext = "*.*html", sheets = list(c(3, 5), 5),
             read_args = list(encoding = "UTF-8"), write = FALSE)
)

test_that("html2excel(): 1 file vs directory of 2 files", {
  expect_equal(t1[[1]], x[[1]])
})

## 4

# Test html2excel() for an HTML file with the incorrect .xlsx extension

# Examples from html2excel()
wrong <- system.file("extdata", "wrong_extension.xlsx", package = "html2excel")
worked3 <- file.copy(from = wrong, to = tdir)
temp_wrong <- file.path(tdir, basename(wrong))
wrong_5 <- html2excel(temp_wrong, sheets = 5, write = TRUE)
res4 <- wrong_5[[1]]$sheet1

test_that("html2excel(): wrong .xlsx extension", {
  expect_equal(res1, res4)
})

## 5

### A URL
url <- "https://afd.calpoly.edu/web/sample-tables"
x <- html2excel(url, write = FALSE)
