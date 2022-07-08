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
      case ',':
        addSingleCharToken(TokenType.comma);
        break;
      case "'":
        text();
        break;
      case '#':
        color();
        break;
      default:
        if (isDigit(char)) {
          number();
        } else if (isAlpha(char)) {
          word();
        } else if (isWhitespace(char)) {
          // ignore
        } else {
          throw 'Unexpected character: $char';
        }
        break;
    }
  }

  void text() {
    // scan text token
    final start = current - 1;
    final startLine = line;
    String text = '';
    while (peek() != "'" && !isAtEnd()) {
      text += advance();
    }
    consume("'", 'Unterminated text expression');
    addToken(TokenType.text, text, startLine, start);
  }

  void color() {
    // scan color token
    final start = current - 1;
    String color = '';
    while (isAlpha(peek()) || isDigit(peek())) {
      color += advance();
    }
    addToken(TokenType.color, color, line, start);
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

  void word() {
    // scan word token
    final start = current - 1;
    String word = previous();
    while (isAlpha(peek()) || isDigit(peek()) || peek() == ',') {
      // allow commas because needed in some properties (e.g. padding)
      word += advance();
    }
    if (widgets.keys.contains(word)) {
      addToken(TokenType.widgetName, word, line, start);
    } else {
      addToken(TokenType.word, word, line, start);
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

  void consume(String expected, String failMessage) {
    if (advance() != expected) {
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
