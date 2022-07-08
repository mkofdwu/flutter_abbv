import 'package:flutter_abbv/token.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

import 'container.dart';
import 'row.dart';
import 'column.dart';
import 'text_field.dart';
import 'image.dart';
import 'scroll.dart';

export 'base_widget.dart';
export 'container.dart';
export 'row.dart';
export 'column.dart';
export 'text.dart';
export 'text_field.dart';
export 'image.dart';
export 'scroll.dart';
export 'sizedbox.dart';

final Map<String, Widget Function(List<Token>, List<Widget>)> widgets = {
  'container': (properties, children) => Container(properties, children),
  'row': (properties, children) => Row(properties, children),
  'column': (properties, children) => Column(properties, children),
  'textfield': (properties, children) => TextField(properties, children),
  // 'button': Button,
  'image': (properties, children) => Image(properties, children),
  'scroll': (properties, children) =>
      SingleChildScrollView(properties, children),
  // 'listview': ListView,
  // 'listtile': ListTile,
  // 'icon': Icon,
  // 'iconbutton': IconButton,
  // 'spacer': Spacer,
};

String printWidgetTree(Widget w, int depth) {
  final indent = '    ' * depth;
  return '$indent${w.runtimeType}(\n$indent    ${w.properties},\n${w.children.map((c) => printWidgetTree(c, depth + 1)).join(',\n')}\n$indent)';
}
