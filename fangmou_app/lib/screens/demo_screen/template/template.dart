import 'dart:io';

import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../function_template_screen/model/template.dart';
import '../../function_template_screen/widget/template_base_layout.dart';

enum Templates {
  source;

  const Templates();

  Template get template {
    switch (this) {
      case Templates.source:
        return Template(
          placeholders: Templates.source.tokens,
          template: '''
${Tokens.example.token} ''',
        );
    }
  }

  List<String> get tokens =>
      Tokens.values.where((item) => item.templates.contains(this)).map((item) => item.token).toList();
}

enum Tokens {
  example(token: "{{example}}", templates: [Templates.source]),
  path(token: "", templates: []);

  const Tokens({required this.token, required this.templates});
  final String token;
  final List<Templates> templates;
}

enum Results { example }

class AbcScreen extends ConsumerStatefulWidget {
  final FangMouGoRoute route;
  const AbcScreen({super.key, required this.route});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AbcScreenState();
}

class _AbcScreenState extends ConsumerState<AbcScreen> {
  final Map<Tokens, TextEditingController> paramMap = {
    Tokens.example: TextEditingController(),
    Tokens.path: TextEditingController(),
  };
  final Map<Results, TextEditingController> resultMap = {Results.example: TextEditingController()};

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(
      name: widget.route.name!,
      paramField: paramField,
      resultField: resultField(),
      resetParams: resetParams,
      clearAll: clearAll,
      generate: generate,
    );
  }

  // region <- Functions:布局方法 ->
  Widget paramField(bool fileGenerate) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap[Tokens.path]!,
              labelText: "文件名",
              validator: (value) {
                if (!fileGenerate) return null;
                if (value != null && value != "") return null;
                return "文件名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap[Tokens.example]!,
              labelText: "示例",
              validator: (value) {
                return null;
              },
            ),
            Spacer(flex: 10),
          ],
        ),
      ],
    );
  }

  Widget resultField() {
    return Column(children: [CopyableField(controller: resultMap[Results.example]!)]);
  }
  // endregion <- Functions:布局方法 ->

  // region <- Functions:基本方法 ->
  void resetParams(formKey) {
    formKey.currentState!.reset();
    for (var item in paramMap.values) {
      item.text = "";
    }
  }

  void clearAll(formKey) {
    resetParams(formKey);
    for (var item in resultMap.values) {
      item.text = "";
    }
  }

  Future<void> generate(formKey, fileGenerate, directory) async {
    try {
      // region <- Logic:参数校验 ->
      if (formKey.currentState == null) return;
      if (!formKey.currentState!.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        return;
      }
      if (fileGenerate && directory.isEmpty) {
        showCustomToast("请选择路径");
        return;
      }
      // endregion <- Logic:参数校验 ->

      String result = "";

      // region <- Logic: 生成可复制文本 ->
      result = sourceTemplateGenerator();
      resultMap[Results.example]!.text = result;
      // endregion <- Logic: 生成可复制文本->

      // region <- Logic: 生成文件->
      if (fileGenerate) {
        try {
          var file = File("$directory/${paramMap[Tokens.example]!.text}.dart");
          await file.writeAsString(result);
        } catch (e) {
          logger.e(e);
        }
      }

      // endregion <- Logic:生成文件 ->
    } catch (e) {
      showCustomDialog(e.toString());
      rethrow;
    }
  }
  // endregion <- Functions:基本方法 ->

  // region <- Functions: 生成代码方法 ->
  String sourceTemplateGenerator() {
    String result = "";
    result = Templates.source.template.replaceAll({Tokens.example.token: paramMap[Tokens.example]!.text});

    return result;
  }

  // endregion <- Functions: 生成代码方法 ->
}
