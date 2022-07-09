import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

final caxisAbbv = {
  's': 'start',
  'c': 'center',
  'e': 'end',
  'S': 'stretch',
};

final maxisAbbv = {
  's': 'start',
  'c': 'center',
  'e': 'end',
  'sb': 'spaceBetween',
  'sa': 'spaceAround',
  'se': 'spaceEvenly',
};

final msizeEnum = ['min', 'max'];

class Column extends Widget {
  Column(List<Token> properties, List<Widget> children)
      : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: {'msize': msizeEnum},
      namedProperties: [
        NamedProperty('c', (s) => caxisAbbv[s]!),
        NamedProperty('m', (s) => maxisAbbv[s]!),
      ],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    final code = ['Column('];
    if (p['c'] != null) {
      code.add('  crossAxisAlignment: CrossAxisAlignment.${p['c']},');
    }
    if (p['m'] != null) {
      code.add('  mainAxisAlignment: MainAxisAlignment.${p['m']},');
    }
    if (p['msize'] != null) {
      code.add('  mainAxisSize: MainAxisSize.${p['msize']},');
    }
    code.add('  children: [');
    for (final child in children) {
      code.addAll(child.toDartCode('column').map((line) => '    $line'));
    }
    code.add('  ],');
    code.add('),');

    return code;
  }
}
