@JS()
library flutter_abbv;

import 'package:js/js.dart';
import 'parser.dart';
import 'scanner.dart';

@JS('expand')
external set _expand(String Function(String) f);

String expand(String s) {
  final tokens = scanTokens(s);
  final tree = Parser(tokens).widget();
  return tree.toDartCode('').join('\n');
}

void main() {
  _expand = allowInterop(expand);
}
