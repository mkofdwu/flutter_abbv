import 'package:flutter_abbv/config.dart';
import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/widgets/base_widget.dart';

class Icon extends Widget {
  Icon(super.properties, super.children);

  @override
  List<String> toDartCode(String parentName) {
    // first property is the icon name
    final extractor = PropertyExtractor(enums: [], namedProperties: []);
    extractor.extractProps(properties.sublist(1));
    final p = <String, String>{};
    if (extractor.extractedNumbers.isNotEmpty) {
      p['size'] = extractor.extractedNumbers[0];
    }
    if (extractor.extractedColors.isNotEmpty) {
      p['color'] = extractor.extractedColors[0];
    }
    final code = constructDartCode(['Icon', 'size', 'color'], p);
    code.insert(1, '  ${Config().iconSetName}.${properties[0].lexeme},');
    return code;
  }
}
