// shitcode

import 'package:flutter_abbv/properties/properties.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

final shapeEnum = ['rectangle', 'circle'];

class Container extends Widget {
  Container(List<Token> properties, List<Widget> children)
      : super(properties, children);

  String toDartCode() {
    int? width;
    int? height;
    String? color;
    String? shape;
    String? padding;
    String? border;
    String? radius;
    String? shadow;

    for (final prop in properties) {
      final str = prop.lexeme;
      if (prop.type == TokenType.number) {
        // width and height
        if (width == null) {
          width = int.parse(str);
        } else {
          height ??= int.parse(str);
        }
      } else if (prop.type == TokenType.color) {
        color = str;
      } else if (shapeEnum.contains(str)) {
        shape = str;
      } else {
        switch (str[0]) {
          case 'p':
            padding = str.substring(1);
            break;
          case 'b':
            border = str.substring(1);
            break;
          case 'r':
            radius = str.substring(1);
            break;
          case 's':
            shadow = str.substring(1);
            break;
          default:
            throw 'Invalid property $str'; // TODO: improve error message
        }
      }
    }

    height ??= width; // if only one number is provided treat as a square

    final code = ['Container('];
    if (width != null) {
      code.add('width: $width,');
    }
    if (height != null) {
      code.add('height: $height,');
    }
    if (padding != null) {
      code.add('padding: ${paddingToDartCode(padding)},');
    }
    // check to see if boxdecoration is needed
    if (shape == null && border == null && radius == null && shadow == null) {
      code.add('decoration: BoxDecoration(');
      if (color != null) {
        // TODO: switch out the enum if necessary
        code.add('  color: Colors.$color,');
      }
      if (shape != null) {
        code.add('  shape: BoxShape.$shape,');
      }
      if (border != null) {
        code.add('  border: ${borderToDartCode(border)}');
      }
      if (radius != null) {
        code.add('  borderRadius: BorderRadius.circular(${radius}),');
      }
    }
  }
}
