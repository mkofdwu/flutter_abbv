// shitcode

import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

final shapeEnum = {'rect': 'rectangle', 'circle': 'circle'};

class Container extends Widget {
  Container(List<Token> properties, List<Widget> children)
      : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: [
        EnumProperty('shape', 'BoxShape', shapeEnum),
      ],
      namedProperties: [
        NamedProperty('p', 'padding', paddingToDartCode),
        NamedProperty('b', 'border', borderToDartCode),
        NamedProperty('r', 'borderRadius', (s) => 'BorderRadius.circular($s)'),
        NamedProperty('s', 'boxShadow', shadowToDartCode),
      ],
    );
    extractor.extractProps(properties);
    final p = Map<String, String>.from(extractor.extractedProps);
    final nums = extractor.extractedNumbers;
    final colors = extractor.extractedColors;
    if (nums.length > 2) throw 'Container accepts at most 2 numbers';
    if (colors.length > 1) throw 'Container only accepts one color';
    if (nums.isNotEmpty) {
      p['width'] = nums[0];
      p['height'] = nums.length == 2 ? nums[1] : nums[0];
      // use 0 to omit width or height
      if (p['width'] == '0') p.remove('width');
      if (p['height'] == '0') p.remove('height');
    }
    if (colors.isNotEmpty) {
      p['color'] = colors[0];
    }
    final needsBoxDecoration = p['shape'] != null ||
        p['border'] != null ||
        p['borderRadius'] != null ||
        p['boxShadow'] != null;

    final code = constructDartCode([
      'Container',
      'width',
      'height',
      'padding',
      if (!needsBoxDecoration)
        'color'
      else
        [
          'decoration: BoxDecoration',
          'color',
          'shape',
          'border',
          'borderRadius',
          'boxShadow'
        ],
    ], p);

    if (children.length > 1) {
      throw 'Container can only have one child';
    }
    if (children.length == 1) {
      insertChildCode(code, children[0], 'container');
    }

    return code;
  }
}
