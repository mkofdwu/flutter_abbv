import 'dart:io';

import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';
import 'package:test/test.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:path/path.dart' as path;

Frame _frame() {
  return Frame.caller(1);
}

// hacky method to get current script path
final currentDir = path.dirname(_frame().uri.path.substring(1));

String readRelativeFile(String relativePath) {
  final absPath = path.join(currentDir, relativePath);
  return File(absPath).readAsStringSync().replaceAll('\r\n', '\n');
}

void main() {
  for (int n = 1; n <= 2; n++) {
    test('Example $n', () {
      final input = readRelativeFile('examples/${n}_in');
      final expectedOutput = readRelativeFile('examples/${n}_out');
      final tokens = scanTokens(input);
      final tree = Parser(tokens).widget();
      expect(tree.toDartCode('').join('\n'), expectedOutput);
    });
  }
}
