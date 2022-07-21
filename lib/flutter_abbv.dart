import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';

void main() {
  final tokens = scanTokens(
      "'The quick brown fox jumps over the lazy dog' 16 w700 #grey i cent sp1.4 max2 oe sh#black*0.1,10 up");
  final tree = Parser(tokens).widget();
  print(tree.toDartCode('').join('\n'));
}
