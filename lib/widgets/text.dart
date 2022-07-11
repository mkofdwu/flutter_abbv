import 'package:flutter_abbv/properties/constructors.dart';
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
final alignEnum = [
  'left',
  'center',
  'right',
  'justify',
];
final styleEnum = ['italic'];
final caseEnum = ['up'];

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
      enums: [
        EnumProperty('fontWeight', 'FontWeight', weightEnum),
        EnumProperty('textAlign', 'TextAlign', alignEnum),
        EnumProperty('fontStyle', 'FontStyle', styleEnum),
        EnumProperty('case', '', caseEnum),
      ],
      namedProperties: [
        NamedProperty.i('max', 'maxLines'),
        NamedProperty.i('sp', 'letterSpacing'),
        NamedProperty(
            'o', 'overflow', (s) => 'TextOverflow.${overflowAbbv[s]!}'),
        NamedProperty('s', 'shadows', shadowToDartCode),
      ],
    );
    extractor.extractProps(properties);
    final p = Map<String, String>.from(extractor.extractedProps);
    final nums = extractor.extractedNumbers;
    final colors = extractor.extractedColors;

    if (nums.length > 1) throw 'Text only accepts one number';
    if (colors.length > 1) throw 'Text only accepts one color';

    if (nums.length == 1) {
      p['fontSize'] = nums[0];
    }
    if (colors.length == 1) {
      p['color'] = colors[0];
    }

    final textSkeleton = [
      'Text',
      'textAlign',
      'letterSpacing',
      'maxLines',
      'overflow',
      'shadows',
      ['style: TextStyle', 'color', 'fontSize', 'fontWeight', 'fontStyle'],
    ];
    final code = constructDartCode(textSkeleton, p);
    code.insert(1, "  '$text'${p['case'] == '.up' ? '.toUpperCase()' : ''},");

    return code;
  }
}
