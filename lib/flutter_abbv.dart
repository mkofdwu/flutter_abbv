import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';

void main() {
  final tokens = scanTokens(
      'container #green b2 sh#black*0.2,0,14,30 r10 p12 \'Hello world\'');
  final tree = Parser(tokens).widget();
  print(tree.toDartCode('').join('\n'));
}
