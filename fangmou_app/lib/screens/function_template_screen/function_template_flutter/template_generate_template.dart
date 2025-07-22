import 'dart:io';

import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';
import '../widget/template_base_layout.dart';

const String example ='''
import 'dart:io';

import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';
import '../widget/template_base_layout.dart';

const String example ='''

    ''';


class TemplateGenerateTemplate extends ConsumerStatefulWidget {
  const TemplateGenerateTemplate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TemplateGenerateTemplateState();
}

class _TemplateGenerateTemplateState extends ConsumerState<TemplateGenerateTemplate> {
  final TextEditingController exampleCopyableFieldController = TextEditingController();

  final TextEditingController fileName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(paramField: paramField(), resultField: resultField(), resetParams: resetParams, clearAll: clearAll, generate: generate);
  }

  // region <- Functions:布局方法 ->
  Widget paramField() {
    return TextField(
      controller: fileName,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blue, width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
        labelText: '文件名',
      ),
    );
  }

  Widget resultField() {
    return Column(children: [CopyableField(controller: exampleCopyableFieldController)]);
  }
  // endregion <- Functions:布局方法 ->

  // region <- Functions:基本方法 ->
  void resetParams() {
    logger.d('┏━━━━━━━━━━━━━━━━resetParams━━━━━━━━━━━━━━━━┓');
    fileName.text = "";
    logger.d('┗━━━━━━━━━━━━━━━━resetParams━━━━━━━━━━━━━━━━┛');
  }

  void clearAll() {
    logger.d('┏━━━━━━━━━━━━━━━━clearAll━━━━━━━━━━━━━━━━┓');
    resetParams();
    exampleCopyableFieldController.text = "";
    logger.d('┗━━━━━━━━━━━━━━━━clearAll━━━━━━━━━━━━━━━━┛');
  }

  Future<void> generate(fileGenerate, directory) async {
    logger.d('┏━━━━━━━━━━━━━━━━generate━━━━━━━━━━━━━━━━┓');
    logger.d(fileGenerate);
    logger.d(directory);

    String result = "";

    // region <- Logic: 生成可复制文本 ->
    result = exampleGenerator();
    exampleCopyableFieldController.text = result;
    // endregion <- Logic: 生成可复制文本->

    // region <- Logic: 生成文件->
    if (fileGenerate) {
      if (directory.isEmpty) {
        showCustomDialog("请选择路径");
        return;
      }

      try {
        var file = File("\$directory/fileName.dart");
        await file.writeAsString(result);
      } catch (e) {
        logger.d(e);
      }
    }

    // endregion <- Logic:生成文件 ->
    logger.d('┗━━━━━━━━━━━━━━━━generate━━━━━━━━━━━━━━━━┛');
  }
  // endregion <- Functions:基本方法 ->

  // region <- Functions: 生成相关代码 ->
  String exampleGenerator() {
    String result = "";
    result = example.replaceAll("{{exampleValue}}", "value");
    return result;
  }

  // endregion <- Functions: 生成相关代码 ->
}

''';


class TemplateGenerateTemplate extends ConsumerStatefulWidget {
  const TemplateGenerateTemplate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TemplateGenerateTemplateState();
}

class _TemplateGenerateTemplateState extends ConsumerState<TemplateGenerateTemplate> {
  final TextEditingController exampleCopyableFieldController = TextEditingController();

  final TextEditingController fileName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(paramField: paramField(), resultField: resultField(), resetParams: resetParams, clearAll: clearAll, generate: generate);
  }

  // region <- Functions:布局方法 ->
  Widget paramField() {
    return TextField(
      controller: fileName,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blue, width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
        labelText: '文件名',
      ),
    );
  }

  Widget resultField() {
    return Column(children: [CopyableField(controller: exampleCopyableFieldController)]);
  }
  // endregion <- Functions:布局方法 ->

  // region <- Functions:基本方法 ->
  void resetParams() {
    logger.d('┏━━━━━━━━━━━━━━━━resetParams━━━━━━━━━━━━━━━━┓');
    fileName.text = "";
    logger.d('┗━━━━━━━━━━━━━━━━resetParams━━━━━━━━━━━━━━━━┛');
  }

  void clearAll() {
    logger.d('┏━━━━━━━━━━━━━━━━clearAll━━━━━━━━━━━━━━━━┓');
    resetParams();
    exampleCopyableFieldController.text = "";
    logger.d('┗━━━━━━━━━━━━━━━━clearAll━━━━━━━━━━━━━━━━┛');
  }

  Future<void> generate(fileGenerate, directory) async {
    logger.d('┏━━━━━━━━━━━━━━━━generate━━━━━━━━━━━━━━━━┓');
    logger.d(fileGenerate);
    logger.d(directory);

    String result = "";

    // region <- Logic: 生成可复制文本 ->
    result = exampleGenerator();
    exampleCopyableFieldController.text = result;
    // endregion <- Logic: 生成可复制文本->

    // region <- Logic: 生成文件->
    if (fileGenerate) {
      if (directory.isEmpty) {
        showCustomDialog("请选择路径");
        return;
      }

      try {
        var file = File("$directory/fileName.dart");
        await file.writeAsString(result);
      } catch (e) {
        logger.d(e);
      }
    }

    // endregion <- Logic:生成文件 ->
    logger.d('┗━━━━━━━━━━━━━━━━generate━━━━━━━━━━━━━━━━┛');
  }
  // endregion <- Functions:基本方法 ->

  // region <- Functions: 生成相关代码 ->
  String exampleGenerator() {
    String result = "";
    result = example.replaceAll("{{exampleValue}}", "value");
    return result;
  }
  // endregion <- Functions: 生成相关代码 ->
}
