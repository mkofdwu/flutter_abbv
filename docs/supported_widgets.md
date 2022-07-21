# Supported widgets

Here's the complete list of widgets with built-in support. You can also define abbreviations for your own widgets with [custom widgets](custom_widgets.md)

* [Container](#container)
* [Row](#row)
* [Column](#column)
* [SingleChildScrollView](#singlechildscrollview)
* [Icon](#icon)
* [Scaffold](#scaffold)
* [Center](#center)
* [Align](#align)
* [Expanded](#expanded)
* [Spacer](#spacer)
* [Padding](#padding)
* [Text](#text)
* [SizedBox](#sizedbox)
* [Placeholder](#placeholder)

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

```dart
Container(
  padding: EdgeInsets.all(2),
  decoration: BoxDecoration(
    color: Colors.green,
    border: Border.all(width: 2),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 14), blurRadius: 30,),],
  ),
  child: Text(
    'Hello world',
  ),
),
```

## Row

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

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
    ),
    SizedBox(width: 36),
    Container(
    ),
  ],
),
```

## Column

Exactly the same properties as [row](#row), just it a different direction

## SingleChildScrollView

format: `scroll {padding} {reverse?} {direction: vertical|horizontal}`

To set reverse: true add `rev`

### example

`scroll p30,40 rev vertical column (container; container; container)`

```dart
SingleChildScrollView(
  reverse: true,
  scrollDirection: Axis.vertical,
  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
  child: Column(
    children: [
      Container(
      ),
      Container(
      ),
      Container(
      ),
    ],
  ),
),
```

## Icon

format: `icon {name (required)} {size} {color}`

### example

`icon add 28 #blue`

```dart
Icon(
  Icons.add,
  size: 28,
  color: Colors.blue,
),
```

## Scaffold

format: `scaffold {backgroundColor} {appbar title: text?} {body}`

Accepts 1 or 2 children, corresponding to the title (as a text widget) and body.

### example

`scaffold #black ('Home page' 20; container)`

```dart
Scaffold(
  backgroundColor: Colors.black,
  appBar: AppBar(
    title: Text(
      'Home page',
      style: TextStyle(
        fontSize: 20,
      ),
    ),
  ),
  body: Container(
  ),
),
```

## Center

format: `center {child}`

Center accepts exactly one child

### example

`container 100 100 #green center 'Hello!' #white`

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.green,
  child: Center(
    child: Text(
      'Hello!',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
),
```

## Align

format: `align {alignment} {child}`

alignment property:

| abbrevation | dart code |
| --- | --- |
| tl | Alignment.topLeft |
| tc | Alignment.topCenter |
| tr | Alignment.topRight |
| c | Alignment.center |
| cl | Alignment.centerLeft |
| cr | Alignment.centerRight |
| bl | Alignment.bottomLeft |
| bc | Alignment.bottomCenter |
| br | Alignment.bottomRight |

## Expanded

format: `expanded {flex} {child}`

Wraps a child in an Expanded widget.

## Spacer

format: `spacer {flex}`

Spacer widget with the given flex value.

## Padding

format: `pad {padding} {child}`

Wraps a child in a Padding widget with the specified [padding property](common_properties.md#padding).

## Text

format `'{desired string}' {font size} {font weight} {color} {font style} {textAlign} {letterSpacing} {maxLines} {overflow} {shadows} {case}`

Font weight can be one of `normal`, `bold`, `w100`, `w200`, `w300`, `w400`, `w500`, `w600`, `w700`, `w800`, `w900`.

Font style can only be `i`, which makes the text italic.

Text align can be one of `left`, `cent` (cant be `center` because its a widget name), `right`, `justify`,

Letter spacing is a number prefixed by `sp`, for example, `sp1.4`

Max lines is a number prefixed by `max`, for example, `max2`

Text overflow

| abbrevation | dart code |
| --- | --- |
| oc | TextOverflow.clip |
| oe | TextOverflow.ellipsis |
| of | TextOverflow.fade |

You can specify uppercase by adding `up` for the case property

Shadows follow the same format as [shadows in Container](#shadow)

### example

`'The quick brown fox jumps over the lazy dog' 16 w700 #grey i cent sp1.4 max2 oe sh#black*0.1,10 up`

```dart
Text(
  'The quick brown fox jumps over the lazy dog'.toUpperCase(),
  textAlign: TextAlign.center,
  letterSpacing: 1.4,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  shadows: [Shadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),],
  style: TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  ),
),
```

## SizedBox

Sizedbox can only be used in a row or column to add padding in between widgets. Simply specify the height or width as a number.

### example

`row (container; 10; container)`

```dart
Row(
  children: [
    Container(
    ),
    SizedBox(width: 10),
    Container(
    ),
  ],
),
```

`column (container; 10; container)`

```dart
Column(
  children: [
    Container(
    ),
    SizedBox(height: 10),
    Container(
    ),
  ],
),
```

## Placeholder

format: `placeholder`

A temporary widget in case you need to specify a widget that doesn't have an abbrevation defined.

This widget has no properties or children.