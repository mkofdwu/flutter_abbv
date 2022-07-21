# Supported widgets

## Container

format: `container {width and height} {color} {shape: rect|circle} {padding} {border} {radius} {shadow} {child}`

If only one number is given it will be used for both width and height. To set only the width set the height as 0 and it will be ignored, likewise for height: `container 100 0` -> `Container(width: 100)`.

### border

| abbrevation | dart code |
| --- | --- |
| b2 | Border.all(width: 2) |
| b#red,2 | Border.all(color: Colors.red, width: 2) |

### shadow

| abbrevation | dart code |
| --- | --- |
| sh#black*0.4,10 | BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10) |
| sh#red,12,10,24 | BoxShadow(color: Colors.red, offset: Offset(12, 10), blurRadius: 24) |
| sh#red,12,10,24,4 | BoxShadow(color: Colors.red, offset: Offset(12, 10), blurRadius: 24, spreadRadius: 4) |

The shadow property requires a color and 1, 3, or 4 numbers

### example

`container #green b2 sh#black*0.2,0,14,30 r10 p12 'Hello world'`

```
```

## row

format: `row {crossAxisAlignment} {mainAxisAlignment} {mainAxisSize: min|max} {children}`

| abbrevation | dart code |
| --- | --- |
| cs | CrossAxisAlignment.start |
| cc | .center |
| ce | .end |
| cS | .stretch |
| ms | MainAxisAlignment.start (likewise for .center and .end) |
| msb | MainAxisAlignment.spaceBetween |
| msa | MainAxisAlignment.spaceAround |
| mse | MainAxisAlignment.spaceEvenly |

### example

`row cs min (container; 36; container)`

```
```

## column

## scroll

## icon

## scaffold

## center

## align

## expanded

## spacer

## pad

## text (wrap text in quotes)

## sizedbox (number, only allowed in row or column)
