import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class Expanded extends Widget {
  Expanded(List<Token> properties, List<Widget> children)
      : super(properties, children) {
    if (children.length != 1) {
      throw 'Expanded requires exactly one child';
    }
  }

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(enums: [], namedProperties: []);
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    if (extractor.extractedNumbers.isNotEmpty) {
      p['flex'] = extractor.extractedNumbers[0];
    }

    final code = constructDartCode([
      'Expanded',
      'flex',
    ], p);
    insertChildCode(code, children[0], 'expanded');

    return code;
  }
}
