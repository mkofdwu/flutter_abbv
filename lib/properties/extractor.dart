import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

class NamedProperty {
  final String name;
  final String Function(String) toDartCode;

  NamedProperty(this.name, this.toDartCode);

  factory NamedProperty.i(String name) {
    return NamedProperty(name, (s) => s);
  }
}

class PropertyExtractor {
  final Map<String, List<String>> enums;
  final List<NamedProperty>
      namedProperties; // order from longest to shortest name

  Map<String, String> extractedProps = {};
  List<String> extractedNumbers = [];
  List<String> extractedColors = [];

  PropertyExtractor({
    required this.enums,
    required this.namedProperties,
  });

  void extractProps(List<Token> properties) {
    for (final prop in properties) {
      final str = prop.lexeme;

      if (_tryEnum(str)) continue;
      if (_tryNumberOrColor(prop)) continue;
      if (_tryNamedProp(str)) continue;

      throw 'Invalid property $str'; // TODO: improve error message
    }
  }

  bool _tryEnum(String str) {
    for (final propName in enums.keys) {
      if (enums[propName]!.contains(str)) {
        extractedProps[propName] = str;
        return true;
      }
    }
    return false;
  }

  bool _tryNumberOrColor(Token prop) {
    if (prop.type == TokenType.number) {
      extractedNumbers.add(prop.lexeme);
      return true;
    }
    if (prop.lexeme.startsWith('#')) {
      extractedColors.add(colorToDartCode(prop.lexeme.substring(1)));
      return true;
    }
    return false;
  }

  bool _tryNamedProp(String str) {
    for (final prop in namedProperties) {
      if (str.startsWith(prop.name)) {
        extractedProps[prop.name] =
            prop.toDartCode(str.substring(prop.name.length));
        return true;
      }
    }
    return false;
  }
}
