import 'package:flutter_abbv/properties/errors.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

class EnumProperty {
  final String propName;
  final String enumName;
  final Map<String, String> values;

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
  final Map<String, String> simpleAbbvs;

  Map<String, String> extractedProps = {};
  List<String> extractedNumbers = [];
  List<String> extractedColors = [];
  List<String> extractedDartCode = [];
  List<String> extraCode = []; // from simpleAbbvs

  PropertyExtractor({
    required this.enums,
    required this.namedProperties,
    this.simpleAbbvs = const {},
  });

  void extractProps(List<Token> properties) {
    for (final prop in properties) {
      final str = prop.lexeme;

      if (_tryEnum(str)) continue;
      if (_tryNumberOrColor(prop)) continue;
      if (_tryDartCode(prop)) continue;
      if (_tryNamedProp(str)) continue;
      if (_trySimpleAbbv(str)) continue;

      throw InvalidPropertyError(str, 'Could not recognize');
    }
  }

  bool _tryEnum(String str) {
    for (final enumProp in enums) {
      if (enumProp.values.containsKey(str)) {
        final actualValue = enumProp.values[str];
        extractedProps[enumProp.propName] = '${enumProp.enumName}.$actualValue';
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

  bool _tryDartCode(Token prop) {
    if (prop.type == TokenType.dartCode) {
      extractedDartCode.add(prop.lexeme);
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

  bool _trySimpleAbbv(String str) {
    if (simpleAbbvs.containsKey(str)) {
      extraCode.add(simpleAbbvs[str]!);
      return true;
    }
    return false;
  }
}
