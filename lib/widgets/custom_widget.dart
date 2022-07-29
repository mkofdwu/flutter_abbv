import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class CustomWidget extends Widget {
  final String name;
  final List<EnumProperty> enums;
  final List<NamedProperty> namedProperties;
  final Map<String, String> simpleAbbvs;
  final List<dynamic>? skeleton;

  CustomWidget(
    this.name,
    this.enums,
    this.namedProperties,
    this.simpleAbbvs,
    List<Token> properties,
    List<Widget> children, {
    this.skeleton,
  }) : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: enums,
      namedProperties: namedProperties,
      simpleAbbvs: simpleAbbvs,
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;
    p['color'] = extractor.extractedColors.single;
    p['color'] = extractor.extractedNumbers.single;

    // TODO: allow specifying numbers

    final sk = skeleton ??
        [
          name,
          ...enums.map((e) => e.propName),
          ...namedProperties.map((p) => p.actualName),
        ];

    return constructDartCode(sk, p);
  }
}
