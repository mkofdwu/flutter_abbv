import 'package:flutter_abbv/properties/constructors.dart';
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
      enums: [
        EnumProperty('mainAxisSize', 'MainAxisSize', msizeEnum),
      ],
      namedProperties: [
        NamedProperty(
          'c',
          'crossAxisAlignment',
          (s) => 'CrossAxisAlignment.${caxisAbbv[s]!}',
        ),
        NamedProperty(
          'm',
          'mainAxisAlignment',
          (s) => 'MainAxisAlignment.${maxisAbbv[s]!}',
        ),
      ],
    );
    extractor.extractProps(properties);

    final code = constructDartCode([
      'Column',
      'crossAxisAlignment',
      'mainAxisAlignment',
      'mainAxisSize',
    ], extractor.extractedProps);
    insertChildrenCode(code, children, 'column');

    return code;
  }
}
