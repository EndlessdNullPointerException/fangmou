import 'dart:io';

import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';
import '../widget/template_base_layout.dart';

const String example = '''
import 'dart:io';

import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';
import '../widget/template_base_layout.dart';

const String example = \'\'\'
{{exampleValue}}
\'\'\';

class {{className}}Template extends ConsumerStatefulWidget {
  const {{className}}Template({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _{{className}}TemplateState();
}

class _{{className}}TemplateState extends ConsumerState<{{className}}Template> {
  final TextEditingController exampleCopyableFieldController = TextEditingController();

  final TextEditingController fileName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(paramField: paramField(), resultField: resultField(), resetParams: resetParams, clearAll: clearAll, generate: generate);
  }

  // region <- Functions:布局方法 ->
  Widget paramField() {
    return Column(
      children: [
        Row(children: [Spacer(flex: 40), fangmouStandardTextField(flex: 30, controller: fileName, labelText: "文件名"), Spacer(flex: 40)]),
      ],
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
}''';

class TemplateGenerateTemplate extends ConsumerStatefulWidget {
  const TemplateGenerateTemplate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TemplateGenerateTemplateState();
}

class _TemplateGenerateTemplateState extends ConsumerState<TemplateGenerateTemplate> {
  final TextEditingController exampleCopyableFieldController = TextEditingController();
  final TextEditingController fileName = TextEditingController();
  final TextEditingController className = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(
      paramField: paramField(),
      resultField: resultField(),
      resetParams: resetParams,
      clearAll: clearAll,
      generate: generate,
    );
  }

  // region <- Functions:布局方法 ->
  Widget paramField() {
    return Column(
      children: [
        Row(
          children: [
            Spacer(flex: 15),
            fangmouStandardTextFormField(
              flex: 30,
              controller: fileName,
              labelText: "文件名",
              validator: (value) {
                logger.d(value);
                if (value != null && value != "") return null;
                return "文件名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: className,
              labelText: "类名",
              validator: (value) {
                logger.d(value);
                logger.d(value);
                if (value != null && value != "") return null;
                return "类名不能为空";
              },
            ),
            Spacer(flex: 15),
          ],
        ),
      ],
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

  Future<void> generate(formKey, fileGenerate, directory) async {
    if (formKey.currentState == null) return;
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop();
    }

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
    result = example.replaceAll("{{className}}", className.text);
    return result;
  }

  // endregion <- Functions: 生成相关代码 ->
}
