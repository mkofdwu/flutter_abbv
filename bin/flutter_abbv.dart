import 'dart:io';

import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';
import 'package:flutter_abbv/widgets/widgets.dart';

void main(List<String> arguments) {
  print('Reading file');
  final tokens = scanTokens(File(arguments[0]).readAsStringSync());
  for (var element in tokens) {
    print(element);
  }
  final tree = Parser(tokens).widget();
  print(printWidgetTree(tree, 0));
}
