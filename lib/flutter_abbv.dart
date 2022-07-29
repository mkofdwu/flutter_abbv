import 'dart:io';

import 'package:flutter_abbv/config.dart';
import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/scanner.dart';
import 'package:flutter_abbv/widgets/container.dart';
import 'package:flutter_abbv/widgets/custom_widget.dart';
import 'package:flutter_abbv/widgets/widgets.dart';
import 'package:yaml/yaml.dart';

void main() {
  final yaml = File('./example_config.yaml').readAsStringSync();
  final data = loadYaml(yaml);

  if (data['color_palette'] != null) {
    Config().colorPaletteName = data['color_palette'];
  }
  if (data['icon_set'] != null) {
    Config().iconSetName = data['icon_set'];
  }

  final widgets = data['widgets'];
  for (final widgetName in widgets.keys) {
    final Map<String, dynamic> widget = widgets[widgetName];
    final enumProps = <EnumProperty>[];
    final namedProps = <NamedProperty>[];
    final simpleAbbvs = <String, String>{};
    for (final prop in widget.keys) {
      if (prop == 'code') continue;
      if (prop == '_construct') {
        // special property
        // TODO
        continue;
      }

      final propData = widget[prop];
      if (propData is Map<String, String>) {
        if (propData.containsKey('enum')) {
          final enumName = propData.remove('enum')!;
          enumProps.add(EnumProperty(prop, enumName, propData));
        } else {
          assert(propData.length == 1); // namedproperties should only have 1
          namedProps.add(NamedProperty(
            propData.keys.first,
            prop,
            (s) => propData.values.first.replaceAll('\$', s),
          ));
        }
      } else {
        assert(propData is String);
        if (propData[0] != '\$') {
          // is just direct substitution
          simpleAbbvs[prop] = propData;
        } else {
          switch (propData) {
            case '\$padding':
              namedProps.add(NamedProperty('p', 'padding', paddingToDartCode));
              break;
            case '\$border':
              namedProps.add(NamedProperty('b', 'border', borderToDartCode));
              break;
            case '\$shadow':
              namedProps.add(NamedProperty('sh', 'shadows', shadowToDartCode));
              break;
          }
        }
      }
    }
    widgets[widget['code']] =
        (p, c) => CustomWidget(enumProps, namedProps, simpleAbbvs, p, c);
  }

  final tokens = scanTokens(
      "'The quick brown fox jumps over the lazy dog' 16 w700 #grey i cent sp1.4 max2 oe sh#black*0.1,10 up");
  final tree = Parser(tokens).widget();
  print(tree.toDartCode('').join('\n'));
}
