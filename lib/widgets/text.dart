import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/errors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

final weightEnum = {
  'normal': 'normal',
  'bold': 'bold',
  'w100': 'w100',
  'w200': 'w200',
  'w300': 'w300',
  'w400': 'w400',
  'w500': 'w500',
  'w600': 'w600',
  'w700': 'w700',
  'w800': 'w800',
  'w900': 'w900',
};
final alignEnum = {
  'left': 'left',
  'cent': 'center',
  'right': 'right',
  'justify': 'justify',
};
final styleEnum = {'i': 'italic'};
final caseEnum = {'up': 'up'};

final overflowAbbv = {
  'c': 'clip',
  'e': 'ellipsis',
  'f': 'fade',
};

class Text extends Widget {
  Text(List<Token> properties) : super(properties, []);

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
        NamedProperty('sh', 'shadows', shadowToDartCode),
      ],
    );
    extractor.extractProps(properties);
    final p = Map<String, String>.from(extractor.extractedProps);
    final nums = extractor.extractedNumbers;
    final colors = extractor.extractedColors;
    // there should just be a single string
    final text = extractor.extractedDartCode.single;

    if (nums.length > 1) {
      throw InvalidPropertyError(
          nums.toString(), 'Text only accepts one number');
    }
    if (colors.length > 1) {
      throw InvalidPropertyError(
          colors.toString(), 'Text only accepts one color');
    }

    if (nums.length == 1) {
      p['fontSize'] = nums[0];
    }
    if (colors.length == 1) {
      p['color'] = colors[0];
    }
    if (p.containsKey('shadows')) {
      // kind of hacky
      p['shadows'] = p['shadows']!.replaceFirst('BoxShadow', 'Shadow');
    }

    final textSkeleton = [
      'Text',
      'textAlign',
      'maxLines',
      'overflow',
      [
        'style: TextStyle',
        'color',
        'fontSize',
        'fontWeight',
        'fontStyle',
        'letterSpacing',
        'shadows',
      ],
    ];
    final code = constructDartCode(textSkeleton, p);
    code.insert(1, "  $text${p['case'] == '.up' ? '.toUpperCase()' : ''},");

    return code;
  }
}
