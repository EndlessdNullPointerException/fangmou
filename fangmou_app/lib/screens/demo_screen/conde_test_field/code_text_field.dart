import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

import 'package:flutter_highlight/themes/solarized-light.dart';
// 1. 导入你需要的语言和主题
import 'package:highlight/languages/dart.dart';

class CodeEditorPage extends StatefulWidget {
  const CodeEditorPage({super.key});

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  CodeController? _codeController;

  final String _initialSourceCode = """
// 一个简单的 Flutter Widget 示例
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 返回一个居中的 Text
    return const Center(
      child: Text('Hello, World!'),
    );
  }
}
""";

  @override
  void initState() {
    super.initState();
    // 2. 创建一个 CodeController
    _codeController = CodeController(
      text: _initialSourceCode,
      language: dart, // 指定语言为 Dart
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles: solarizedLightTheme),
      child: CodeField(
        controller: _codeController!,
        textStyle: const TextStyle(fontFamily: 'FiraCode'),
        maxLines: null,
      ),
    );
  }
}
