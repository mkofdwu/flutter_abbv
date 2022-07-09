import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

final weightEnum = [
  'normal',
  'bold',
  'w100',
  'w200',
  'w300',
  'w400',
  'w500',
  'w600',
  'w700',
  'w800',
  'w900',
];
final alignEnum = ['left', 'center', 'right', 'justify'];
final styleEnum = ['italic'];
final caseEnum = ['upper'];

final overflowAbbv = {
  'c': 'clip',
  'e': 'ellipsis',
  'f': 'fade',
};

class Text extends Widget {
  final String text;

  Text(this.text, List<Token> properties) : super(properties, []);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: {
        'weight': weightEnum,
        'align': alignEnum,
        'style': styleEnum,
        'case': caseEnum,
      },
      namedProperties: [
        NamedProperty.i('max'),
        NamedProperty.i('sp'),
        NamedProperty('o', (s) => overflowAbbv[s]!),
        NamedProperty('s', shadowToDartCode),
      ],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;
    final nums = extractor.extractedNumbers;
    final colors = extractor.extractedColors;

    if (nums.length > 1) throw 'Text only accepts one number';
    if (colors.length > 1) throw 'Text only accepts one color';

    final code = [
      'Text(',
      "  '$text'${p['case'] == 'upper' ? '.toUpperCase()' : ''},",
    ];
    if (p['color'] != null ||
        p['fontSize'] != null ||
        p['fontWeight'] != null) {
      code.add('  style: TextStyle(');
      if (p['color'] != null) {
        code.add('    color: ${p['color']},');
      } else if (nums.length == 1) {
        code.add('    fontSize: ${nums[0]},');
      } else if (p['weight'] != null) {
        code.add('    fontWeight: FontWeight.${p['weight']},');
      } else if (p['style'] != null) {
        code.add('    fontStyle: FontStyle.${p['style']},');
      }
    }
    if (p['align'] != null) {
      code.add('  textAlign: TextAlign.${p['align']},');
    }
    if (p['sp'] != null) {
      code.add('  letterSpacing: ${p['sp']},');
    }
    if (p['max'] != null) {
      code.add('  maxLines: ${p['max']},');
    }
    if (p['o'] != null) {
      code.add('  overflow: TextOverflow.${p['o']},');
    }
    if (p['s'] != null) {
      code.add('  shadows: ${p['s']},');
    }
    code.add('),');

    return code;
  }
}
