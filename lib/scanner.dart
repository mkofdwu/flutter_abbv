import 'package:flutter_abbv/token.dart';
import 'package:flutter_abbv/widgets/widgets.dart';

class ScanError extends Error {
  String message;

  ScanError(this.message);

  @override
  String toString() {
    return 'ScanError: $message';
  }
}

class _Scanner {
  final String source;

  List<Token> tokens = [];
  int line = 0;
  int lineStart = 0; // position of most recent line start
  int current = 0; // current position in source
  int get column => current - lineStart;

  _Scanner(this.source);

  void scanToken() {
    final char = advance();
    switch (char) {
      case '\n':
        line++;
        lineStart = current;
        break;
      case '(':
        addSingleCharToken(TokenType.leftParen);
        break;
      case ')':
        addSingleCharToken(TokenType.rightParen);
        break;
      case ';':
        addSingleCharToken(TokenType.semicolon);
        break;
      case '{': // code can contain strings as well
        dartCode();
        break;
      case "'": // '...' is desugared to {'...'}
        text();
        break;
      case '#':
        // color
        propertyOrWidget();
        break;
      default:
        if (isDigit(char)) {
          number();
        } else if (isAlpha(char)) {
          propertyOrWidget();
        } else if (isWhitespace(char)) {
          // ignore
        } else {
          throw ScanError('Unexpected character: $char');
        }
        break;
    }
  }

  void _consumeDartCode() {
    // to allow maps in dart code
    // this would work most of the time
    int bracketCount = 1;
    while (!isAtEnd()) {
      advance();

      if (peek() == '{') {
        bracketCount++;
      } else if (peek() == '}') {
        bracketCount--;
        if (bracketCount == 0) break;
      }
    }
    consume('}', "Expected '}'");
  }

  void dartCode() {
    // lexeme extracted does not contain braces
    final start = current;
    final startLine = line;
    _consumeDartCode();
    addToken(
      TokenType.dartCode,
      source.substring(start, current - 1),
      startLine,
      start,
    );
  }

  void _consumeText() {
    while (peek() != "'" && !isAtEnd()) {
      advance();
    }
    consume("'", 'Unterminated text expression');
  }

  void text() {
    final start = current - 1;
    final startLine = line;
    _consumeText();
    addToken(
      TokenType.dartCode,
      source.substring(start, current),
      startLine,
      start,
    );
  }

  void number() {
    // no floating point numbers for now
    final start = current - 1;
    String number = previous();
    while (isDigit(peek())) {
      number += advance();
    }
    addToken(TokenType.number, number, line, start);
  }

  void propertyOrWidget() {
    final start = current - 1;
    // allow putting colors in a named property
    const allowedSymbols = ['_', '#', '*', '.', ','];
    while (
        isAlpha(peek()) || isDigit(peek()) || allowedSymbols.contains(peek())) {
      advance();
    }
    // allow putting dart code in a named property
    if (match('{')) {
      _consumeDartCode();
    }
    // allow putting text in a named property
    if (match("'")) {
      _consumeText();
    }
    final lexeme = source.substring(start, current);
    if (widgets.keys.contains(lexeme)) {
      addToken(TokenType.widgetName, lexeme, line, start);
    } else {
      addToken(TokenType.property, lexeme, line, start);
    }
  }

  static bool isDigit(String char) {
    if (char.isEmpty) return false;
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  }

  static bool isAlpha(String char) {
    if (char.isEmpty) return false;
    return (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) ||
        (char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) ||
        char == '_';
  }

  static bool isWhitespace(String char) {
    return char == ' ' || char == '\t' || char == '\n' || char == '\r';
  }

  void addToken(TokenType token, String lexeme, int line, int position) {
    tokens.add(Token(token, lexeme, line, position));
  }

  void addSingleCharToken(TokenType type) {
    tokens.add(Token(type, previous(), line, current));
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

  bool match(String expected) {
    if (peek() != expected) return false;
    advance();
    return true;
  }

  void consume(String expected, String failMessage) {
    if (isAtEnd() || advance() != expected) {
      throw ScanError(failMessage);
    }
  }
}

List<Token> scanTokens(String source) {
  final scanner = _Scanner(source);
  while (!scanner.isAtEnd()) {
    scanner.scanToken();
  }
  return scanner.tokens;
}
