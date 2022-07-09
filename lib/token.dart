enum TokenType {
  leftParen,
  rightParen,
  comma,
  text, // text widget (e.g. 'Sample text' red 36 w700)
  widgetName,
  word,
  number,
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
