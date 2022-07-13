import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/properties/helpers.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

class Scaffold extends Widget {
  Scaffold(super.properties, super.children) {
    if (children.length > 2 || children.isEmpty) {
      throw 'Scaffold accepts only 1 or 2 children';
    }
  }

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(enums: [], namedProperties: []);
    extractor.extractProps(properties);
    final p = extractor.extractedProps; // for now should be empty
    if (extractor.extractedColors.isNotEmpty) {
      p['backgroundColor'] = extractor.extractedColors[0];
    }

    final code = constructDartCode([
      'Scaffold',
      'backgroundColor',
    ], p);
    if (children.length == 2) {
      final titleCode = children[0].toDartCode('appbar');
      final appBarCode = [
        '  appBar: AppBar(',
        '    title: ${titleCode[0]}',
        ...titleCode.sublist(1).map((s) => '    $s'),
        '  ),'
      ];
      code.insertAll(code.length - 1, appBarCode);
    }
    final bodyCode = children.last.toDartCode('scaffold');
    code.insertAll(code.length - 1, [
      '  body: ${bodyCode[0]}',
      ...bodyCode.sublist(1).map((s) => '  $s'),
    ]);

    return code;
  }
}
