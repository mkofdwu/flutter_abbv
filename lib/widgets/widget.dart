import 'package:flutter_abbv/token.dart';

class Widget {
  List<String> properties = [];
  List<Widget> children = [];

  Widget(this.properties, this.children);
}

class Text extends Widget {
  final String text;

  Text(this.text, List<String> properties) : super(properties, []);
}

class SizedBox extends Widget {
  // used for both rows and columns
  final int size;

  SizedBox(this.size) : super([], []);
}

// class Container extends Widget {
//   Map<TokenType, dynamic> typeMap = {
//     TokenType.number: 'fontSize',
//     TokenType.color: 'color',
//   };
//   Container(List<String> properties, List<Widget> children)
//       : super(properties, children);
// }
