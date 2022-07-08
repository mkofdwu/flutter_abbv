import 'package:flutter_abbv/base_scanner.dart';

final fontWeight = ['light', 'regular', 'medium', 'semibold', 'bold', 'black'];
final imageFit = ['cover', 'contain', 'fill', 'fitheight', 'fitwidth', 'none'];
final alignment = ['tl', 'tc', 'tr', 'cl', 'c', 'cr', 'bl', 'bc', 'br'];

final allEnums = {
  'fontWeight': fontWeight,
  'imageFit': imageFit,
  'alignment': alignment,
};

enum PropertyType {
  number,
  namedNumber,
  anEnum, // e.g. gradient: gltr -> ltr is another enum
  color,
}

final propertyCodes = [
  'p', // padding
  'c', // crossAxisAlignment
  'm', // mainAxisAlignment
  'b', // border
  's', // shadow
  'g', // gradient
  'w', // font weight
  '',
];

class PropertyValue {
  final PropertyType type;
  final String str;

  PropertyValue(this.type, this.str);
}

class Property {
  final String name;
  final List<PropertyValue> values;

  Property(this.name, this.values);
}

class PropertyScanner extends BaseScanner {
  final List<PropertyValue> values = [];

  PropertyScanner(super.source);

  Property scan() {
    // check for enum names match before matching property names below
    // to prevent name clashes (e.g. 'bold' with 'b' border property)
    for (final name in allEnums.keys) {
      if (allEnums[name]!.contains(source)) {
        return Property(name, [PropertyValue(PropertyType.anEnum, source)]);
      }
    }
    final propCode = advance();
    final char = advance();
    switch (char) {
      case ',':
        break;
      case '#':
        return color();
      default:
        if (BaseScanner.isDigit(char)) {
          return number();
        } else if (BaseScanner.isAlpha(char)) {
          return namedValue();
        } else {
          throw 'Unexpected char: $char';
        }
    }
  }

  Property color() {}
}
