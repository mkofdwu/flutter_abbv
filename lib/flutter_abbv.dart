import 'dart:io';

import 'package:flutter_abbv/config.dart';
import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/scanner.dart';
import 'package:flutter_abbv/widgets/custom_widget.dart';
import 'package:flutter_abbv/widgets/widgets.dart';
import 'package:yaml/yaml.dart';

class WidgetConfig {
  final String code;
  final List<EnumProperty> enumProps;
  final List<NamedProperty> namedProps;
  final Map<String, String> simpleAbbvs;
  final List<String> variables;
  final List<dynamic>? skeleton;

  const WidgetConfig({
    required this.code,
    required this.enumProps,
    required this.namedProps,
    required this.simpleAbbvs,
    required this.variables,
    required this.skeleton,
  });
}

WidgetConfig _extractWidgetConfig(YamlMap rawConfig) {
  final enumProps = <EnumProperty>[];
  final namedProps = <NamedProperty>[];
  final simpleAbbvs = <String, String>{};
  final variables = <String>[];
  List<dynamic>? skeleton;

  for (final prop in rawConfig.keys) {
    if (prop == 'code') continue;
    if (prop == '_construct') {
      skeleton = rawConfig[prop];
      continue;
    }

    final propData = rawConfig[prop];
    if (propData is YamlMap) {
      if (propData.containsKey('enum')) {
        final enumName = propData.remove('enum')!;
        enumProps.add(EnumProperty(
          prop,
          enumName,
          Map<String, String>.from(propData.value),
        ));
      } else {
        assert(propData.length == 1); // namedproperties should only have 1
        final propCode = propData.keys.single;
        final propFormat = propData.values.single;
        if (propFormat == '\$variable') {
          namedProps.add(NamedProperty(propCode, prop, (s) {
            // rest of prop must be just the dart code
            assert(s[0] == '{');
            assert(s[s.length - 1] == '}');
            return s.substring(1, s.length - 1);
          }));
        } else {
          namedProps.add(NamedProperty(
            propCode,
            prop,
            (s) => propFormat.replaceAll('\$', s),
          ));
        }
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
          case '\$variable':
            variables.add(prop);
        }
      }
    }
  }
  return WidgetConfig(
    code: rawConfig['code'],
    enumProps: enumProps,
    namedProps: namedProps,
    simpleAbbvs: simpleAbbvs,
    variables: variables,
    skeleton: skeleton,
  );
}

void main() {
  final yaml = File('./example_config.yaml').readAsStringSync();
  final data = loadYaml(yaml);

  if (data['color_palette'] != null) {
    Config().colorPaletteName = data['color_palette'];
  }
  if (data['icon_set'] != null) {
    Config().iconSetName = data['icon_set'];
  }

  for (final widgetName in data['widgets'].keys) {
    final config = _extractWidgetConfig(data['widgets'][widgetName]);
    widgets[config.code] = (p, c) => CustomWidget(
          widgetName,
          config.enumProps,
          config.namedProps,
          config.simpleAbbvs,
          config.variables,
          config.skeleton,
          p,
          c,
        );
  }

  final tokens =
      scanTokens("button h100 'Hello world' t{'Message \${user.username}'}");
  final tree = Parser(tokens).widget();
  print(tree.toDartCode('').join('\n'));
}
