class SimpleScanner {
  final String source;

  int current = 0; // current position in source

  SimpleScanner(this.source);

  int number() {
    final start = current;
    while (isDigit(peek())) {
      advance();
    }
    return int.parse(source.substring(start, current));
  }

  String word() {
    final start = current;
    if (!isAlpha(peek())) return '';
    while (isAlpha(peek()) || isDigit(peek())) {
      advance();
    }
    return source.substring(start, current);
  }

  String hexChars() {
    final start = current;
    while (isHexChar(peek())) {
      advance();
    }
    return source.substring(start, current);
  }

  String color() {
    // assumes # has already been consumed
    String result = '';
    if (isAlpha(peek())) {
      result += word();
    } else {
      // expects hex value
      result += hexChars();
    }
    if (peek() == '*') {
      // alpha value
      advance();
      consumeSequence('0.1', '');
    }
  }

  static bool isDigit(String char) {
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  }

  static bool isAlpha(String char) {
    return (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) ||
        (char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) ||
        char == '_';
  }

  static bool isHexChar(String char) {
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57 || // 0-9
        char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 70 || // A-F
        char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 102; // a-f
  }

  static bool isWhitespace(String char) {
    return char == ' ' || char == '\t' || char == '\n' || char == '\r';
  }

  bool isAtEnd() {
    return current >= source.length;
  }

  String advance() {
    // return the next character and move forward
    return source[current++];
  }

  String peek() {
    if (isAtEnd()) return '';
    return source[current];
  }

  String previous() {
    return source[current - 1];
  }

  void consume(String expected, String failMessage) {
    if (advance() != expected) {
      // throw ScanError(failMessage);
      throw failMessage;
    }
  }
}
