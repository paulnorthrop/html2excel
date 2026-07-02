# html2excel [![html2excel logo](reference/figures/html2excel_logo.png)](https://paulnorthrop.github.io/html2excel/)

[![R-CMD-check](https://github.com/paulnorthrop/html2excel/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/paulnorthrop/html2excel/actions/workflows/R-CMD-check.yaml)
[![Coverage
Status](https://codecov.io/github/paulnorthrop/html2excel/coverage.svg?branch=master)](https://app.codecov.io/github/paulnorthrop/html2excel?branch=master)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/html2excel)](https://cran.r-project.org/package=html2excel)
[![Downloads
(monthly)](https://cranlogs.r-pkg.org/badges/html2excel?color=brightgreen)](https://cran.r-project.org/package=html2excel)
[![Downloads
(total)](https://cranlogs.r-pkg.org/badges/grand-total/html2excel?color=brightgreen)](https://cran.r-project.org/package=html2excel)

## Convert HTML Tables to an Excel File

Reads tables from HTML documents. The tables are returned as a list of
tibbles and may be written to Excel files. The main function is
[`html2excel()`](https://github.com/paulnorthrop/html2excel/reference/html2excel.md).
If you are visiting multiple web pages, please use the
[polite](https://cran.r-project.org/package=polite) package to ensure
that you do this in an appropriate way.

## An example

An example HTML file, `tables.html`, is included as an `html2excel`
package system file.

``` r
library(html2excel)
html <- system.file("extdata", "tables.html", package = "html2excel")
# Extract all tables in this HTML file
tibbles <- html2excel(html)

# tibbles is a list of length one containing a list of 5 tibbles
# Print the 5th tibble
tibbles[[1]][5]
#> $sheet5
#> # A tibble: 5 × 3
#>   Day       Time      Location                             
#>   <chr>     <chr>     <chr>                                
#> 1 Wednesday 3-6 pm    Cal Poly Campus (follow U-Pick Signs)
#> 2 Thursday  2:30-5pm  Morro Bay Farmer's Market            
#> 3 Thursday  6:10-9pm  Downtown SLO Farmer's Market         
#> 4 Saturday  8-10:30am Farmer's Market new Embassy Suites   
#> 5 Saturday  11am-2pm  Cal Poly Campus (follow U-Pick signs)

# We can use the sheets argument to extract only the 5th table
tibbles2 <- html2excel(html, sheets = 5)
tibbles2[[1]]
#> $sheet1
#> # A tibble: 5 × 3
#>   Day       Time      Location                             
#>   <chr>     <chr>     <chr>                                
#> 1 Wednesday 3-6 pm    Cal Poly Campus (follow U-Pick Signs)
#> 2 Thursday  2:30-5pm  Morro Bay Farmer's Market            
#> 3 Thursday  6:10-9pm  Downtown SLO Farmer's Market         
#> 4 Saturday  8-10:30am Farmer's Market new Embassy Suites   
#> 5 Saturday  11am-2pm  Cal Poly Campus (follow U-Pick signs)
```

The example HTML file was sourced from a webpage of Accessible Data
Tables provided by California Polytechnic State University, USA. The URL
is given in the following example, which shows that we can extract
tables by supplying a URL to
[`html2excel()`](https://github.com/paulnorthrop/html2excel/reference/html2excel.md).

``` r
url <- "https://afd.calpoly.edu/web/sample-tables"
tibbles3 <- html2excel(url)
tibbles3[[1]][5]
```

``` R
#> $sheet5
#> # A tibble: 5 × 3
#>   Day       Time      Location                             
#>   <chr>     <chr>     <chr>                                
#> 1 Wednesday 3-6 pm    Cal Poly Campus (follow U-Pick Signs)
#> 2 Thursday  2:30-5pm  Morro Bay Farmer's Market            
#> 3 Thursday  6:10-9pm  Downtown SLO Farmer's Market         
#> 4 Saturday  8-10:30am Farmer's Market new Embassy Suites   
#> 5 Saturday  11am-2pm  Cal Poly Campus (follow U-Pick signs)
```

## Installation

To install the current released version from CRAN:

``` r
install.packages("html2excel")
```
