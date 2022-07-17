import 'package:flutter_abbv/properties/scanner.dart';
import 'package:flutter_abbv/token.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

import 'container.dart';
import 'row.dart';
import 'column.dart';
import 'scroll.dart';
import 'center.dart';
import 'icon.dart';
import 'scaffold.dart';
import 'spacer.dart';
import 'align.dart';
import 'expanded.dart';
import 'padding.dart';

export 'base_widget.dart';

typedef WidgetConstructor = Widget Function(
    List<Token> properties, List<Widget> children);

WidgetConstructor desugarWrapInPadding(WidgetConstructor original) {
  return (properties, children) {
    for (int i = 0; i < properties.length; i++) {
      final prop = properties[i];
      final str = prop.lexeme;
      if (prop.type == TokenType.property &&
          str[0] == 'p' &&
          (('ltrbhv'.contains(str[1]) || StringScanner.isDigit(str[1])))) {
        return Padding(
          [prop],
          [
            original(
              properties.sublist(0, i) + properties.sublist(i + 1),
              children,
            )
          ],
        );
      }
    }
    return original(properties, children);
  };
}

final Map<String, Widget Function(List<Token>, List<Widget>)> widgets = {
  // (p, c) stand for (properties, children)
  'container': (p, c) => Container(p, c),
  'row': desugarWrapInPadding((p, c) => Row(p, c)),
  'column': desugarWrapInPadding((p, c) => Column(p, c)),
  'scroll': (p, c) => SingleChildScrollView(p, c),
  'icon': desugarWrapInPadding((p, c) => Icon(p, c)),
  'scaffold': (p, c) => Scaffold(p, c),
  'center': (p, c) => Center(p, c),
  'align': (p, c) => Align(p, c),
  'expanded': (p, c) => Expanded(p, c),
  'spacer': (p, c) => Spacer(p, c),
  'pad': (p, c) => Padding(p, c),
  // 'image': (p, c) => Image(p, c),
  // 'listview': ListView,
  // 'listtile': ListTile,
};

String printWidgetTree(Widget w, int depth) {
  final indent = '    ' * depth;
  return '$indent${w.runtimeType}(\n$indent    ${w.properties},\n${w.children.map((c) => printWidgetTree(c, depth + 1)).join(',\n')}\n$indent)';
}
