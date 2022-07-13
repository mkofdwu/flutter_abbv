import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class Spacer extends Widget {
  Spacer(List<Token> properties, List<Widget> children)
      : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(enums: [], namedProperties: []);
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    if (extractor.extractedNumbers.isNotEmpty) {
      p['flex'] = extractor.extractedNumbers[0];
    }

    final code = constructDartCode([
      'Spacer',
      'flex',
    ], p);

    return code;
  }
}
