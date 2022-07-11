import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

class EnumProperty {
  final String propName;
  final String enumName;
  final List<String> values;

  EnumProperty(this.propName, this.enumName, this.values);
}

class NamedProperty {
  final String code;
  final String actualName;
  final String Function(String) toDartCode;

  NamedProperty(this.code, this.actualName, this.toDartCode);

  factory NamedProperty.i(String code, String actualName) {
    return NamedProperty(code, actualName, (s) => s);
  }
}

class PropertyExtractor {
  final List<EnumProperty> enums;
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
    for (final enumProp in enums) {
      if (enumProp.values.contains(str)) {
        extractedProps[enumProp.propName] = '${enumProp.enumName}.$str';
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
    for (final namedProp in namedProperties) {
      if (str.startsWith(namedProp.code)) {
        extractedProps[namedProp.actualName] =
            namedProp.toDartCode(str.substring(namedProp.code.length));
        return true;
      }
    }
    return false;
  }
}
