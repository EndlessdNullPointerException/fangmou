import 'package:fangmou_app/common_widgets/fangmou_standard_widget.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_source_enum.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_source_screen.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_source_source.dart';
import 'package:fangmou_app/screens/function_template_screen/model/param_map.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_state.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/all.dart';
import 'package:path/path.dart' as p;

import '../../../../utils/file_utils.dart';
import '../../../../utils/string_utils.dart';
import '../../widget/copyable_field.dart';
import './template_generate_template_enum.dart';

class TemplateGenerateTemplateScreen extends TemplateCommonScreen {
  const TemplateGenerateTemplateScreen({super.key, required super.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TemplateGenerateTemplateScreenState();
}

class _TemplateGenerateTemplateScreenState
    extends TemplateCommonState<TemplateGenerateTemplateScreen, Params, Results> with SourceSource,SourceEnum,SourceScreen {
  @override
  void paramMapInitiate() {
    paramMap = ParamMap({
      Params.fileName: TextEditingController(),
      Params.templateName: TextEditingController(),
      Params.lowerTemplateName: () => changeFirstLetterCase(paramMap[Params.templateName], toUpper: false),
      Params.language: "dart",
    });
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
              controller: paramMap.getController(Params.fileName),
              labelText: "文件名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "文件名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap.getController(Params.templateName),
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
    String screenPartResult = sourceScreen;
    String enumPartResult = sourceEnum;
    String sourcePartResult = sourceSource;

    // region <- Logic: 赋值可复制文本 ->
    resultMap[Results.screenPart]!.controller.text = screenPartResult;
    resultMap[Results.enumPart]!.controller.text = enumPartResult;
    resultMap[Results.sourcePart]!.controller.text = sourcePartResult;

    // endregion <- Logic: 赋值可复制文本->

    // 展开所有可复制文本
    allExpandOrCollapse(true);

    // region <- Logic: 生成文件->

    if (fileGenerate) {
      String fileName = paramMap[Params.fileName];
      safeCreateFile({
        p.join(directory, fileName, "${fileName}_screen.dart"): screenPartResult,
        p.join(directory, fileName, "${fileName}_enum.dart"): enumPartResult,
        p.join(directory, fileName, "${fileName}_source.dart"): sourcePartResult,
      });
    }

    // endregion <- Logic:生成文件 ->
  }
}
