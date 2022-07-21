# Common properties

## colors

To specify a color, use `#` followed by the hex code or the name of the color. Examples: `#ff0000` or `#red`. To specify an alpha value append `*` followed by the opacity from 0 to 1, e.g. `#black*0.6`.

- `#ff0000` -> `Color(0xffff0000)`
- `#red` -> `Colors.red`
- `#black*0.6` -> `Colors.black.withOpacity(0.6)`

## padding

To add padding to a widget, add a property starting with `p`. It can be any of the following

| abbrevation | dart code |
| --- | --- |
| p10 | EdgeInsets.all(10) |
| p10,8,10,6 | EdgeInsets.fromLTRB(10, 8, 10, 6) |
| p10,20 | EdgeInsets.symmetric(horizontal: 10, vertical: 20) |
| ph10 | EdgeInsets.symmetric(horizontal: 10) |
| pt4 | EdgeInsets.only(top: 4) |

In addition to the 5th example, you can use any combination of the letters `ltrb` to specify padding at any side (will use .only). Use the letter `v` to specify vertical padding.

If the widget has a padding property (e.g. Container, SingleChildScrollView), it will be added as a property, otherwise the widget will be wrapped in a padding widget.