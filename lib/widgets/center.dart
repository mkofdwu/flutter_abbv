import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/errors.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

class Center extends Widget {
  Center(super.properties, super.children);

  @override
  List<String> toDartCode(String parentName) {
    if (children.length != 1) {
      throw ChildCountError('Center requires exactly one child');
    }
    return [
      'Center(',
      ...constructChildCode(children[0], 'center'),
      '),',
    ];
  }
}
