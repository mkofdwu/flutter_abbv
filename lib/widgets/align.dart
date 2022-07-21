import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/errors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

const alignEnum = {
  'tl': 'topLeft',
  'tc': 'topCenter',
  'tr': 'topRight',
  'c': 'center',
  'cl': 'centerLeft',
  'cr': 'centerRight',
  'bl': 'bottomLeft',
  'bc': 'bottomCenter',
  'br': 'bottomRight',
};

class Align extends Widget {
  Align(List<Token> properties, List<Widget> children)
      : super(properties, children) {
    if (children.length != 1) {
      throw ChildCountError('Align requires exactly one child');
    }
  }

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: [EnumProperty('alignment', 'Alignment', alignEnum)],
      namedProperties: [],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    final code = constructDartCode([
      'Align',
      'alignment',
    ], p);
    insertChildCode(code, children[0], 'align');

    return code;
  }
}
