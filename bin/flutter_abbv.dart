import 'dart:io';

import 'package:flutter_abbv/scanner.dart';

void main(List<String> arguments) {
  print('Reading file');
  final tokens = scanTokens(File(arguments[0]).readAsStringSync());
  for (var element in tokens) {
    print(element);
  }
}
