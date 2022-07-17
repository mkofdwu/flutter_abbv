import 'dart:io';

import 'package:flutter_abbv/config.dart';
import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';

void main(List<String> arguments) {
  if (arguments.length > 1) {
    // extra config options (for color, etc)
    Config().colorPaletteName = arguments[1];
  }
  try {
    final tokens = scanTokens(arguments[0]);
    final tree = Parser(tokens).widget();
    stdout.write(tree.toDartCode('').join('\n'));
  } catch (e) {
    stderr.write(e.toString());
  }
}
