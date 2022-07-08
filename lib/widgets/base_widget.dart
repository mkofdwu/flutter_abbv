import 'package:flutter_abbv/properties/properties.dart';
import 'package:flutter_abbv/token.dart';

class Widget {
  List<Token> properties = [];
  List<Widget> children = [];

  Map<TokenType, Property> getTypePropMap() {
    // to implement this method in subclasses
    throw UnimplementedError();
  }

  Map<String, Property> getPropMap() {
    // to implement this method in subclasses
    throw UnimplementedError();
  }

  Widget(this.properties, this.children);

  String propertiesToDartCode() {
    final codeList = [];
    for (final prop in properties) {
      Property property;
      if (prop.type != TokenType.word) {
        // is color or number
        if (!getTypePropMap().containsKey(prop.type)) {
          throw 'Unexpected property type: ${prop.type}';
        }
        property = getTypePropMap()[prop.type]!;
      } else {
        // property type is identified by first character
        final id = prop.lexeme[0];
        if (!getPropMap().containsKey(id)) {
          throw 'Invalid property: $prop';
        }
        property = getTypePropMap()[prop.type]!;
      }
      final data = prop.lexeme.substring(1);
      codeList.add(property.toDartCode(data));
    }
    return codeList.join('\n');
  }

  @override
  String toString() {
    return '$runtimeType($properties, $children)';
  }
}
