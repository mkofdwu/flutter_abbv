import 'dart:io';

import 'package:flutter_abbv/config.dart';
import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/scanner.dart';
import 'package:flutter_abbv/widgets/custom_widget.dart';
import 'package:flutter_abbv/widgets/widgets.dart';
import 'package:yaml/yaml.dart';

void main(List<String> arguments) {
  // first argument: abbrevation to be expanded
  // second argument (optional): path to yaml config file

  if (arguments.length > 1) {
    final yaml = File(arguments[1]).readAsStringSync();
    final data = loadYaml(yaml);
    // TODO: add stuff later
  }

  try {
    final tokens = scanTokens(arguments[0]);
    final tree = Parser(tokens).widget();
    stdout.write(tree.toDartCode('').join('\n'));
  } catch (e) {
    stderr.write(e.toString());
  }
}
