import 'scanner.dart';

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
      default:
        final numbers = [];
        while (true) {
          numbers.add(sc.number());
          if (sc.isAtEnd()) break;
          sc.consume(',', 'Unexpected char ${sc.peek()} in padding property');
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
      if (horizontal != null) 'horizontal: $horizontal, ',
      if (vertical != null) 'vertical: $vertical, ',
    ].join(', ')})';
  }
  throw 'No values passed to padding';
}

String borderToDartCode(String source) {}
