import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class ListView extends Widget {
  // just list of children for now
  ListView(List<Token> properties, List<Widget> children)
      : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      // variables: ['items', 'controller'],
      enums: [],
      namedProperties: [],
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;

    if (p.containsKey('items')) {
      p['itemCount'] = '${p['items']}.length';
      p['itemBuilder'] = '(context, i) {}';
    }

    final code = constructDartCode([
      'ListView',
      'controller',
      'itemCount',
      'itemBuilder',
    ], p);
    if (children.isNotEmpty) {
      insertChildrenCode(code, children, 'listview');
    }

    return code;
  }
}
