enum TokenType {
  leftParen,
  rightParen,
  semicolon,
  widgetName,
  property,
  number,
  dartCode,
}

class Token {
  final TokenType type;
  final String lexeme;
  final int line;
  final int column;

  const Token(this.type, this.lexeme, this.line, this.column);

  @override
  String toString() {
    return '${type.toString().substring(10)}{$lexeme}';
  }
}
