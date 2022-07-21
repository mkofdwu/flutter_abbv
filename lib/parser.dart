import 'package:flutter_abbv/token.dart';
import 'package:flutter_abbv/widgets/widgets.dart';
import 'package:flutter_abbv/widgets/text.dart';
import 'package:flutter_abbv/widgets/sizedbox.dart';

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
      final builder = desugarWrapInPadding((p, c) => (Text(text.lexeme, p)));
      return builder(properties, []);
    }
    if (check(TokenType.number)) {
      final size = int.parse(advance().lexeme);
      return SizedBox(size);
    }
    final name =
        consume(TokenType.widgetName, 'Widget name expected, got ${peek()}');
    final properties = widgetProps();
    final children = widgetChildren();
    return widgets[name.lexeme]!(properties, children);
  }

  List<Token> widgetProps() {
    final properties = <Token>[];
    while (check(TokenType.property) ||
        check(TokenType.number) ||
        check(TokenType.variable)) {
      properties.add(advance());
    }
    return properties;
  }

  List<Widget> widgetChildren() {
    if (match(TokenType.leftParen)) {
      // list of widgets
      final children = <Widget>[];
      children.add(widget());
      while (!check(TokenType.rightParen) && !isAtEnd()) {
        consume(TokenType.semicolon,
            'Expected semicolon in widget list, got ${peek()}');
        children.add(widget());
      }
      consume(TokenType.rightParen, 'Missing closing parenthesis');
      return children;
    }
    // single child
    if (check(TokenType.widgetName)) {
      return [widget()];
    }
    if (check(TokenType.text)) {
      final text = advance();
      final properties = widgetProps();
      return [Text(text.lexeme, properties)];
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
