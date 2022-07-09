import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

import '../properties/extractor.dart';

final directionEnum = ['vertical', 'horizontal'];

class SingleChildScrollView extends Widget {
  SingleChildScrollView(super.properties, super.children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: {
        'dir': directionEnum,
        'reverse': ['r'],
      },
      namedProperties: [NamedProperty('p', paddingToDartCode)],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    final code = ['SingleChildScrollView('];
    if (p['reverse'] != null) {
      code.add('  reverse: true,');
    }
    if (p['dir'] != null) {
      code.add('  scrollDirection: Axis.${p['dir']},');
    }
    if (p['p'] != null) {
      code.add('  padding: ${p['p']},');
    }

    if (children.length != 1) {
      throw 'SingleChildScrollView accepts exactly 1 child';
    }
    final childDartCode = children[0].toDartCode('scroll');
    code.add('  child: ${childDartCode[0]}');
    for (final line in childDartCode.sublist(1)) {
      code.add('  $line');
    }
    code.add('),');

    return code;
  }
}
