# Create a gridifyObject

Function for creating a new instance of the gridifyObject class.

## Usage

``` r
gridifyObject(row, col, height = 1, width = 1)
```

## Arguments

- row:

  A numeric value, span or sequence specifying the row position of the
  object.

- col:

  A numeric value, span or sequence specifying the row position of the
  object.

- height:

  A numeric value specifying the height of the object. Default is 1.

- width:

  A numeric value specifying the width of the object. Default is 1.

## Value

An instance of the gridifyObject class.

## See also

[`gridifyLayout()`](https://pharmaverse.github.io/gridify/reference/gridifyLayout.md)

## Examples

``` r
object <- gridifyObject(row = 1, col = 1, height = 1, width = 1)
```
