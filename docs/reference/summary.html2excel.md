# Summarising `html2excel` objects

`summary` method for class `html2excel`.

## Usage

``` r
# S3 method for class 'html2excel'
summary(object, ...)

# S3 method for class 'summary.html2excel'
print(x, ...)
```

## Arguments

- object:

  An object inheriting from class `"html2excel"` returned from
  [`html2excel`](https://github.com/paulnorthrop/html2excel/reference/html2excel.md).

- ...:

  Further arguments to be passed to
  [`print.default`](https://rdrr.io/r/base/print.default.html).

- x:

  An object returned by `summary.html2excel`.

## Value

A list containing the dimensions (number of rows and number of columns)
of each tibble.

## Details

The default `print` method for a list of tibbles prints the dimensions
of the tibbles and up to 10 rows and 6 columns of each tibble.
`summary.html2excel` prints a shorter summary that contains only the
dimensions of the tibbles. These `print` and/or `summary` methods may be
helpful in deciding which sheets are required for which excel file, that
is, how to set the argument `sheets` to
[`html2excel`](https://github.com/paulnorthrop/html2excel/reference/html2excel.md).

## Examples

See
[`html2excel`](https://github.com/paulnorthrop/html2excel/reference/html2excel.md).

## See also

[`html2excel`](https://github.com/paulnorthrop/html2excel/reference/html2excel.md).
