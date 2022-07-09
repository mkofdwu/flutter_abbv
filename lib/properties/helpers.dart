import 'scanner.dart';

String scanColor(SimpleScanner sc) {
  // assumes # has already been consumed
  String dartCode;
  if (SimpleScanner.isAlpha(sc.peek())) {
    final colorName = sc.word();
    dartCode = 'Colors.$colorName';
  } else {
    // expects hex value
    final colorHex = sc.sequence(SimpleScanner.isHexChar);
    dartCode = 'Color(0xff$colorHex)';
  }

  if (sc.match('*')) {
    // alpha value
    sc.consumeString('0.', 'Alpha component must be a value <1 and >0');
    dartCode += '.withAlpha(0.${sc.sequence(SimpleScanner.isDigit)})';
  }

  return dartCode;
}

String colorToDartCode(String color) {
  // assumes # has already been consumed
  final sc = SimpleScanner(color);
  return scanColor(sc);
}

String paddingToDartCode(String source) {
  // source doesnt contain the first 'p' char
  final sc = SimpleScanner(source);
  int? left;
  int? top;
  int? right;
  int? bottom;
  int? horizontal;
  int? vertical;
  while (!sc.isAtEnd()) {
    switch (sc.advance()) {
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
      case '&':
        // ignore
        break;
      default:
        final numbers = [];
        while (true) {
          numbers.add(sc.number());
          if (sc.isAtEnd()) break;
          sc.consume('&', 'Expected & in padding, got ${sc.peek()}');
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
        throw 'You can only provide 1, 2 or 4 numbers to padding';
    }
  }
  if (left != null || top != null || right != null || bottom != null) {
    // T at the end stands for transformed
    return 'EdgeInsets.only(${[
      if (left != null) 'left: $left, ',
      if (top != null) 'top: $top, ',
      if (right != null) 'right: $right, ',
      if (bottom != null) 'bottom: $bottom, ',
    ].join(', ')})';
  }
  if (horizontal != null || vertical != null) {
    // T at the end stands for transformed
    return 'EdgeInsets.symmetric(${[
      if (horizontal != null) 'horizontal: $horizontal',
      if (vertical != null) 'vertical: $vertical',
    ].join(', ')})';
  }
  throw 'No values passed to padding';
}

String borderToDartCode(String source) {
  // source doesnt contain the first 'b' char
  final sc = SimpleScanner(source);
  String? color;
  int width = 1;
  String? borderStyle;
  while (true) {
    switch (sc.advance()) {
      case '#':
        color = scanColor(sc);
        break;
      default:
        if (SimpleScanner.isDigit(sc.peek())) {
          width = sc.number();
        } else {
          borderStyle = sc.word();
        }
        break;
    }
    if (sc.isAtEnd()) break;
    sc.consume('&', 'Expected & in border prop, got ${sc.peek()}');
  }
  return 'Border.all(color $color, width: $width, style: BorderStyle.$borderStyle)';
}

String shadowToDartCode(String source) {
  final sc = SimpleScanner(source);
  List<int> numbers = [];
  String? color;
  while (true) {
    switch (sc.advance()) {
      case '#':
        color = scanColor(sc);
        break;
      default:
        numbers.add(sc.number());
        break;
    }
    if (sc.isAtEnd()) break;
    sc.consume('&', 'Expected & in shadow prop, got ${sc.peek()}');
  }
  if (numbers.length == 1) {
    return '[BoxShadow(color: $color, blurRadius: ${numbers[0]}),]';
  }
  if (numbers.length == 3 || numbers.length == 4) {
    return '[BoxShadow(color: $color, offset: Offset(${numbers[0]}, ${numbers[1]}), blurRadius: ${numbers[2]},${numbers.length == 4 ? ' spreadRadius: ${numbers[3]},' : ''}),]';
  }
  throw 'You can only provide 1, 3 or 4 numbers to shadow';
}
