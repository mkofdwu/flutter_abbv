import 'package:flutter_abbv/widgets/base_widget.dart';

List<String> constructDartCode(
  List<dynamic> skeleton,
  Map<String, String> data,
) {
  final head = skeleton[0] as String;
  final code = ['$head('];
  for (final field in skeleton.sublist(1)) {
    if (field is List) {
      final fieldCode = constructDartCode(field, data);
      assert(fieldCode.length >= 2);
      if (fieldCode.length > 2) {
        // at least one value is specified
        code.addAll(fieldCode.map((s) => '  $s'));
      }
    } else {
      assert(field is String);
      if (data.containsKey(field)) {
        code.add('  $field: ${data[field]},');
      }
    }
  }
  code.add('),');
  return code;
}

List<String> constructChildCode(Widget child, String parentName) {
  final childDartCode = child.toDartCode(parentName);
  return ['  child: ${childDartCode[0]}'] +
      childDartCode.sublist(1).map((line) => '  $line').toList();
}

List<String> constructChildrenCode(List<Widget> children, String parentName) {
  final code = ['  children: ['];
  for (final child in children) {
    code.addAll(child.toDartCode(parentName).map((line) => '    $line'));
  }
  code.add('  ],');
  return code;
}

void insertExtraCode(List<String> code, List<String> extraCode) {
  code.insertAll(code.length - 1, extraCode.map((line) => '  $line'));
}

void insertChildCode(List<String> code, Widget child, String parentName) {
  code.insertAll(code.length - 1, constructChildCode(child, parentName));
}

void insertChildrenCode(
    List<String> code, List<Widget> children, String parentName) {
  code.insertAll(code.length - 1, constructChildrenCode(children, parentName));
}
