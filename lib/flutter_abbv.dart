import 'package:flutter_abbv/config_loader.dart';
import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';

void main() {
  loadConfig('discourse_config.yaml');
  final tokens = scanTokens(
      "button 'Sign up' primary loading fillw pre.check on{handleSignUp}");
  final tree = Parser(tokens).widget();
  print(tree.toDartCode('').join('\n'));
}
