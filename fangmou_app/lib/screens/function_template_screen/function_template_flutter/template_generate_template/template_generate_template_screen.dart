import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_state.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/all.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/file.dart';
import '../../widget/copyable_field.dart';
import './template_generate_template_enum.dart';

class TemplateGenerateTemplateScreen extends TemplateCommonScreen {
  const TemplateGenerateTemplateScreen({super.key, required super.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TemplateGenerateTemplateScreenState();
}

class _TemplateGenerateTemplateScreenState
    extends TemplateCommonState<TemplateGenerateTemplateScreen, Templates, Params, Results> {
  @override
  void paramMapInitiate() {
    paramMap = {for (Params param in Params.values) param: TextEditingController()};
  }

  @override
  void resultMapInitiate() {
    resultMap = {
      for (Results result in Results.values) result: CopyableFieldParams(name: result.name, language: result.language),
    };
  }

  String language = "dart";

  @override
  Widget paramField(bool fileGenerate) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text("模板语言"),
            DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
              ),
              menuHeight: 200,
              initialSelection: language,
              onSelected: (value) {
                language = value!;
              },
              dropdownMenuEntries:
                  allLanguages.keys.map((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap[Params.fileName]!,
              labelText: "文件名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "文件名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap[Params.templateName]!,
              labelText: "模板名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "模板名不能为空";
              },
            ),
            Spacer(flex: 10),
          ],
        ),
      ],
    );
  }

  @override
  Future<void> generate(fileGenerate, directory) async {
    String screenPartResult = screenPartGenerator();
    String enumPartResult = enumPartGenerator();
    String sourcePartResult = sourcePartGenerator();

    // region <- Logic: 赋值可复制文本 ->
    resultMap[Results.screenPart]!.controller.text = screenPartResult;
    resultMap[Results.enumPart]!.controller.text = enumPartResult;
    resultMap[Results.sourcePart]!.controller.text = sourcePartResult;

    // endregion <- Logic: 赋值可复制文本->

    // 展开所有可复制文本
    allExpandOrCollapse(true);

    // region <- Logic: 生成文件->
    logger.d("$directory/${paramMap[Params.fileName].text}/${paramMap[Params.fileName].text}_screen.dart");

    if (fileGenerate) {
      safeCreateFile({
        "$directory\\${paramMap[Params.fileName].text}\\${paramMap[Params.fileName].text}_screen.dart":
            screenPartResult,
        "$directory\\${paramMap[Params.fileName].text}\\${paramMap[Params.fileName].text}_enum.dart": enumPartResult,
        "$directory\\${paramMap[Params.fileName].text}\\${paramMap[Params.fileName].text}_source.dart":
            sourcePartResult,
      });
    }

    // endregion <- Logic:生成文件 ->
  }

  // region <- Functions: 生成代码方法 ->
  screenPartGenerator() {
    String result = Templates.screenPart.source.replaceAll({
      Params.templateName.token: paramMap[Params.templateName]!.text,
      Params.fileName.token: paramMap[Params.fileName]!.text,
    });
    return result;
  }

  enumPartGenerator() {
    String result = Templates.enumPart.source.replaceAll({
      Params.lowerTemplateName.token: paramMap[Params.lowerTemplateName]!.text,
      Params.language.token: language,
      Params.fileName.token: paramMap[Params.fileName]!.text,
    });
    return result;
  }

  sourcePartGenerator() {
    String result = Templates.sourcePart.source.replaceAll({
      Params.lowerTemplateName.token: paramMap[Params.lowerTemplateName]!.text,
      Params.fileName.token: paramMap[Params.fileName]!.text,
    });
    return result;
  }

  // endregion <- Functions: 生成代码方法 ->
}
