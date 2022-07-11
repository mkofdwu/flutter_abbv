import 'package:flutter_abbv/token.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

import 'container.dart';
import 'row.dart';
import 'column.dart';
import 'scroll.dart';
import 'center.dart';
import 'icon.dart';

export 'base_widget.dart';
export 'text.dart';
export 'sizedbox.dart';
export 'container.dart';
export 'row.dart';
export 'column.dart' hide caxisAbbv, maxisAbbv, msizeEnum;
export 'center.dart';
export 'icon.dart';

final Map<String, Widget Function(List<Token>, List<Widget>)> widgets = {
  'container': (properties, children) => Container(properties, children),
  'row': (properties, children) => Row(properties, children),
  'column': (properties, children) => Column(properties, children),
  'scroll': (properties, children) =>
      SingleChildScrollView(properties, children),
  'center': (properties, children) => Center(properties, children),
  'icon': (properties, children) => Icon(properties, children),
  // 'textfield': (properties, children) => TextField(properties, children),
  // 'button': Button,
  // 'image': (properties, children) => Image(properties, children),
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
