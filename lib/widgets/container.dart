// shitcode

import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

final shapeEnum = ['rectangle', 'circle'];

class Container extends Widget {
  Container(List<Token> properties, List<Widget> children)
      : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: {'shape': shapeEnum},
      namedProperties: [
        NamedProperty('p', paddingToDartCode),
        NamedProperty('b', borderToDartCode),
        NamedProperty.i('r'),
        NamedProperty('s', shadowToDartCode),
      ],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;
    final nums = extractor.extractedNumbers;

    if (nums.length > 2) throw 'Container accepts at most 2 numbers';

    final code = ['Container('];
    if (nums.isNotEmpty) {
      code.add('  width: ${nums[0]},');
      code.add('  height: ${nums.length == 2 ? nums[1] : nums[0]},');
    }
    if (p['p'] != null) {
      code.add('  padding: ${p['p']},');
    }
    // check to see if BoxDecoration is needed
    if (p['shape'] != null ||
        p['b'] != null ||
        p['r'] != null ||
        p['s'] != null) {
      code.add('  decoration: BoxDecoration(');
      if (extractor.extractedColors.isNotEmpty) {
        code.add('    color: ${extractor.extractedColors[0]},');
      }
      if (p['shape'] != null) {
        code.add('    shape: BoxShape.${p['shape']},');
      }
      if (p['b'] != null) {
        code.add('    border: ${p['b']},');
      }
      if (p['r'] != null) {
        code.add('    borderRadius: BorderRadius.circular(${p['r']}),');
      }
      if (p['s'] != null) {
        code.add('    boxShadow: ${p['s']},');
      }
      code.add('  ),');
    }

    if (children.length > 1) {
      throw 'Container can only have one child';
    }
    if (children.length == 1) {
      final childDartCode = children[0].toDartCode('container');
      code.add('  child: ${childDartCode[0]}');
      for (final line in childDartCode.sublist(1)) {
        code.add('  $line');
      }
    }
    code.add('),');

    return code;
  }
}
