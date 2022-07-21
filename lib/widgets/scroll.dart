import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/errors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

final directionEnum = {'vertical': 'vertical', 'horizontal': 'horizontal'};

class SingleChildScrollView extends Widget {
  SingleChildScrollView(super.properties, super.children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: [
        EnumProperty('reverse', '', {'rev': 'reverse'}),
        EnumProperty('direction', 'Axis', directionEnum),
      ],
      namedProperties: [
        NamedProperty('p', 'padding', paddingToDartCode),
      ],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;
    if (p['reverse'] != null) {
      p['reverse'] = 'true';
    }

    final code = constructDartCode([
      'SingleChildScrollView',
      'reverse',
      'direction',
      'padding',
    ], p);
    if (children.length != 1) {
      throw ChildCountError('SingleChildScrollView accepts exactly 1 child');
    }
    insertChildCode(code, children[0], 'scroll');

    return code;
  }
}
