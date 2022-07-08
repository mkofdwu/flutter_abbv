import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class Text extends Widget {
  final String text;

  Text(this.text, List<Token> properties) : super(properties, []);
}
