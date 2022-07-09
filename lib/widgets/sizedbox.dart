import 'base_widget.dart';

class SizedBox extends Widget {
  // used for both rows and columns
  final int size;

  SizedBox(this.size) : super([], []);

  @override
  List<String> toDartCode(String parentName) {
    if (parentName == 'row') {
      return ['SizedBox(width: $size),'];
    } else if (parentName == 'column') {
      return ['SizedBox(height: $size),'];
    }
    throw 'Can only use SizedBox in a row or column';
  }
}
