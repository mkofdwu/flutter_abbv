import 'package:flutter_abbv/token.dart';
import 'package:flutter_abbv/widgets/widget.dart';

class ParseError extends Error {
  String message;

  ParseError(this.message);

  @override
  String toString() {
    return 'ParseError: $message';
  }
}

class Parser {
  final List<Token> tokens;

  int current = 0;

  Parser(this.tokens);

  Widget widget() {
    if (check(TokenType.text)) {
      final text = advance();
      final properties = widgetProps();
      return Text(text.lexeme, properties);
    }
    if (check(TokenType.number)) {
      final size = int.parse(advance().lexeme);
      return SizedBox(size);
    }
    final name = consume(TokenType.widgetName, 'Widget name expected');
    final properties = widgetProps();
    final children = widgetChildren();
    return Container(name.lexeme, properties, children);
  }

  List<String> widgetProps() {
    final properties = <String>[];
    while (check(TokenType.word) ||
        check(TokenType.color) ||
        check(TokenType.number)) {
      properties.add(advance().lexeme);
    }
    return properties;
  }

  List<Widget> widgetChildren() {
    if (match(TokenType.leftParen)) {
      // list of widgets
      final children = <Widget>[];
      children.add(widget());
      while (!check(TokenType.rightParen) && !isAtEnd()) {
        consume(TokenType.comma, 'Expect comma to separate list of widgets');
        children.add(widget());
      }
      consume(TokenType.rightParen, 'Missing closing parenthesis');
      return children;
    }
    if (check(TokenType.widgetName)) {
      // single child
      return [widget()];
    }
    return [];
  }

  bool isAtEnd() {
    return current >= tokens.length;
  }

  bool check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  bool match(TokenType type) {
    if (!check(type)) return false;
    advance();
    return true;
  }

  Token advance() {
    return tokens[current++];
  }

  Token peek() {
    return tokens[current];
  }

  Token previous() {
    return tokens[current - 1];
  }

  Token consume(TokenType type, String failMessage) {
    if (check(type)) {
      return advance();
    }
    throw ParseError(failMessage);
  }
}
