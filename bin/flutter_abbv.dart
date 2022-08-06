import 'package:flutter_abbv/config_loader.dart';
import 'package:flutter_abbv/parser.dart';
import 'package:flutter_abbv/scanner.dart';

void main(List<String> arguments) {
  // first argument: abbrevation to be expanded
  // second argument (optional): path to yaml config file

  if (arguments.length > 1) {
    loadConfig(arguments[1]);
  }

  try {
    final tokens = scanTokens(arguments[0]);
    final tree = Parser(tokens).widget();
    print(tree.toDartCode('').join('\n'));
  } catch (e) {
    print('ERROR: $e');
  }
}
