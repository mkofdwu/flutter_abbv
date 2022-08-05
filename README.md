# flutter_abbv

Speed up flutter development with abbreviation for constructing widget trees.
Like emmet abbreviation but for flutter

* Speeds up implementing new widgets/pages, especially when creating a new app.
* Effective for common widgets such as Text / Padding with a lot of repetitive typing
* Intended to be used for simple widgets without complex logic / animations.

## Installation

VSCode: Download and install the .vsix file

## Usage

In a dart file, prefix each abbrevation with an `@` symbol. For example, type `@container` and press ctrl+space, a suggestion for `Container()` should show up. For subsequent examples in these docs, the leading `@` will be omitted, just remember to include it.

Each abbrevation has the format {widget name} {properties} {children}, like: `container 100 100 #red r10` -> Container of width and height 100, red color and border radius 10. Note that the order of the properties does not matter.

To define a text widget, write T followed by a string enclosed in quotes, for example: `T 'This is some text' 16 w700 #green`.

To define a list of widgets, wrap in parentheses and separate with semicolons, example: `column cs ('Title' 20 bold; 8; 'The quick brown fox jumps over the lazy dog')` Here cs refers to CrossAxisAlignment.start, and 8 expands to `SizedBox(height: 8)`.

## Example

`scaffold #black column cs ph30 mc (spacer; T 'Title' 36 w700 #white; 12; T 'Lorem ipsum sit dolor amet' 16 w500 #fff*0.6; 36: spacer 2; align cr container #blue ph20v8 r10 T 'Continue' w600; spacer)`

This expands to:

```dart
Scaffold(
  backgroundColor: Colors.black,
  body: Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(
        ),
        Text(
          'Title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Lorem ipsum sit dolor amet',
          style: TextStyle(
            color: Color(0xffffffff).withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 36),
        Spacer(
          flex: 2,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Spacer(
        ),
      ],
    ),
  ),
),
```