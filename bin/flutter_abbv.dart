import 'dart:io';

import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';

void main(List<String> arguments) {
  final tokens = scanTokens(arguments[0]);
  final tree = Parser(tokens).widget();
  stdout.write(tree.toDartCode('').join('\n'));
}
