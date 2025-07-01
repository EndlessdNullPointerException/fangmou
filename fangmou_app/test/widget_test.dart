// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('示例测试', () {
    logger.d('\x1B[31m红色文本\x1B[0m'); // ANSI 转义码示例
  });
}

void pickFolder() async {
  // 使用静态方法直接调用
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  // 或者使用新 API（推荐）
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any, // 必须指定类型
    allowMultiple: false);

  if (selectedDirectory != null) {
    logger.d("选择的目录: $selectedDirectory");
  } else if (result != null) {
    logger.d("路径: ${result.files.single.path}");
  }
}
