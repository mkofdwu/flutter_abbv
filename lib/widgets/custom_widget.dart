import 'package:flutter_abbv/properties/constructors.dart';
import 'package:flutter_abbv/properties/extractor.dart';
import 'package:flutter_abbv/token.dart';

import 'base_widget.dart';

class CustomWidget extends Widget {
  final String name;
  final List<EnumProperty> enums;
  final List<NamedProperty> namedProperties;
  final Map<String, String> simpleAbbvs;
  final List<String> variables;
  final List<dynamic> skeleton;

  CustomWidget(
    this.name,
    this.enums,
    this.namedProperties,
    this.simpleAbbvs,
    this.variables,
    this.skeleton,
    List<Token> properties,
    List<Widget> children,
  ) : super(properties, children);

  @override
  List<String> toDartCode(String parentName) {
    final extractor = PropertyExtractor(
      enums: enums,
      namedProperties: namedProperties,
      simpleAbbvs: simpleAbbvs,
    );
    extractor.extractProps(properties);
    final p = extractor.extractedProps;
    if (extractor.extractedColors.isNotEmpty) {
      p['color'] = extractor.extractedColors.single;
    }
    // NOTE: unlabelled numbers arent used for custom widgets
    final extractedDartCode = extractor.extractedDartCode;
    // for a custom widget, all dart code (named or unnamed) is a property
    // in order of importance (e.g. if only one variable is supplied only the first var name is used)
    for (int i = 0; i < extractedDartCode.length; i++) {
      p[variables[i]] = extractedDartCode[i];
    }

    final code = constructDartCode(_yamlToSkeleton(skeleton), p);
    insertExtraCode(code, extractor.extraCode);
    if (children.length == 1) {
      insertChildCode(code, children.single, parentName);
    } else if (children.length > 1) {
      insertChildrenCode(code, children, parentName);
    }
    return code;
  }

  List<dynamic> _yamlToSkeleton(List<dynamic> yamlSkeleton) {
    // yaml represets subtrees as maps instead of lists
    // Example:
    // ===========================
    // _construct:
    //   - width
    //   - height
    //   - color
    //   - decoration:
    //       - BoxDecoration
    //       - radius
    //       - border
    //
    // yaml data: ['width', 'height', 'color', {'decoration': ['BoxDecoration', 'radius', 'border']}]
    //
    // This is converted into: ['width', 'height', 'color', ['decoration: BoxDecoration', 'radius', 'border']]

    return yamlSkeleton.map((e) {
      if (e is Map) {
        final propName = e.keys.single;
        final subProps = e[propName];
        assert(subProps is List<String>);
        final objectName = (subProps as List<String>).removeAt(0);
        return ['$propName: $objectName', ...subProps];
      }
      return e;
    }).toList();
  }
}
