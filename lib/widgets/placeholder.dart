import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class Placeholder extends Widget {
  Placeholder(List<Token> properties, List<Widget> children)
      : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    return ['Placeholder(),'];
  }
}
