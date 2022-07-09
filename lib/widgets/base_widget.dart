import 'package:flutter_abbv/token.dart';

abstract class Widget {
  List<Token> properties = [];
  List<Widget> children = [];

  Widget(this.properties, this.children);

  List<String> toDartCode(String parentName);

  @override
  String toString() {
    return '$runtimeType($properties, $children)';
  }
}
