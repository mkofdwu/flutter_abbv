import 'package:flutter_abbv/config.dart';
import 'package:flutter_abbv/properties/errors.dart';

import 'scanner.dart';

String scanColor(StringScanner sc) {
  // assumes # has already been consumed
  String dartCode;
  // check color hex first before named color
  final colorHex = sc.sequence(StringScanner.isHexChar);
  if (colorHex.length == 3 || colorHex.length == 6) {
    dartCode = 'Color(0xff${colorHex.length == 3 ? colorHex * 2 : colorHex})';
  } else {
    // add colorHex in case it consumed some characters
    final colorName = colorHex + sc.word();
    dartCode = '${Config().colorPaletteName}.$colorName';
  }

  if (sc.match('*')) {
    // alpha value
    sc.consumeString('0.', 'Alpha component must be a value <1 and >0');
    dartCode += '.withOpacity(0.${sc.sequence(StringScanner.isDigit)})';
  }

  return dartCode;
}

String colorToDartCode(String color) {
  // assumes # has already been consumed
  final sc = StringScanner(color);
  return scanColor(sc);
}

String paddingToDartCode(String source) {
  // source doesnt contain the first 'p' char
  final sc = StringScanner(source);
  int? left;
  int? top;
  int? right;
  int? bottom;
  int? horizontal;
  int? vertical;
  while (!sc.isAtEnd()) {
    final char = sc.advance();
    switch (char) {
      case 'l':
        left = sc.number();
        break;
      case 't':
        top = sc.number();
        break;
      case 'r':
        right = sc.number();
        break;
      case 'b':
        bottom = sc.number();
        break;
      case 'h':
        horizontal = sc.number();
        break;
      case 'v':
        vertical = sc.number();
        break;
      case ',':
        // ignore
        break;
      default:
        if (!StringScanner.isDigit(char)) {
          throw InvalidPropertyError(
            source,
            'Invalid character $char, expected one of `ltrbhv` or a number',
          );
        }
        final numbers = [];
        while (true) {
          numbers.add(sc.number(offset: -1));
          if (sc.isAtEnd()) break;
          sc.consume(',', 'Expected comma in padding, got ${sc.peek()}');
        }
        if (numbers.length == 1) {
          return 'EdgeInsets.all(${numbers[0]})';
        }
        if (numbers.length == 2) {
          return 'EdgeInsets.symmetric(horizontal: ${numbers[0]}, vertical: ${numbers[1]})';
        }
        if (numbers.length == 4) {
          return 'EdgeInsets.fromLTRB(${numbers.join(", ")})';
        }
        throw InvalidPropertyError(
            source, 'You can only provide 1, 2 or 4 numbers to padding');
    }
  }
  if (left != null || top != null || right != null || bottom != null) {
    return 'EdgeInsets.only(${[
      if (left != null) 'left: $left, ',
      if (top != null) 'top: $top, ',
      if (right != null) 'right: $right, ',
      if (bottom != null) 'bottom: $bottom, ',
    ].join(', ')})';
  }
  if (horizontal != null || vertical != null) {
    return 'EdgeInsets.symmetric(${[
      if (horizontal != null) 'horizontal: $horizontal',
      if (vertical != null) 'vertical: $vertical',
    ].join(', ')})';
  }
  throw InvalidPropertyError(source, 'No values passed to padding');
}

String borderToDartCode(String source) {
  // source doesnt contain the first 'b' char
  final sc = StringScanner(source);
  String? color;
  int width = 1;
  String? borderStyle;
  while (true) {
    final char = sc.advance();
    switch (char) {
      case '#':
        color = scanColor(sc);
        break;
      default:
        if (StringScanner.isDigit(char)) {
          width = sc.number(offset: -1);
        } else {
          borderStyle = sc.word();
        }
        break;
    }
    if (sc.isAtEnd()) break;
    sc.consume(',', 'Expected comma in border prop, got ${sc.peek()}');
  }
  final borderProps = [
    if (color != null) 'color: $color',
    'width: $width',
    if (borderStyle != null) 'style: BorderStyle.$borderStyle',
  ].join(', ');
  return 'Border.all($borderProps)';
}

String shadowToDartCode(String source) {
  final sc = StringScanner(source);
  List<int> numbers = [];
  String? color;
  while (true) {
    final char = sc.advance();
    switch (char) {
      case '#':
        color = scanColor(sc);
        break;
      default:
        if (StringScanner.isDigit(char)) {
          numbers.add(sc.number(offset: -1));
        } else {
          throw InvalidPropertyError(source, 'Unexpected character $char');
        }
        break;
    }
    if (sc.isAtEnd()) break;
    sc.consume(',', 'Expected comma in shadow prop, got ${sc.peek()}');
  }
  if (numbers.length == 1) {
    return '[BoxShadow(color: $color, blurRadius: ${numbers[0]}),]';
  }
  if (numbers.length == 3 || numbers.length == 4) {
    return '[BoxShadow(color: $color, offset: Offset(${numbers[0]}, ${numbers[1]}), blurRadius: ${numbers[2]},${numbers.length == 4 ? ' spreadRadius: ${numbers[3]},' : ''}),]';
  }
  throw InvalidPropertyError(
      source, 'You can only provide 1, 3 or 4 numbers to shadow');
}
