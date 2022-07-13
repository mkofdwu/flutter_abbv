import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class Padding extends Widget {
  Padding(List<Token> properties, List<Widget> children)
      : super(properties, children) {
    if (children.length != 1) {
      throw 'Padding requires exactly one child';
    }
  }

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: [],
      namedProperties: [NamedProperty('p', 'padding', paddingToDartCode)],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    final code = constructDartCode([
      'Padding',
      'padding',
    ], p);
    insertChildCode(code, children[0], 'padding');

    return code;
  }
}
