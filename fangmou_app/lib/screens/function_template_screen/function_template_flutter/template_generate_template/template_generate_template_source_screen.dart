import './template_generate_template_enum.dart';

final String templateGenerateTemplateSourceScreen = '''
import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_state.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/file.dart';
import '../../widget/copyable_field.dart';
import './${Params.fileName.token}_enum.dart';

class ${Params.templateName.token}Screen extends TemplateCommonScreen {
  const ${Params.templateName.token}Screen({super.key, required super.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _${Params.templateName.token}ScreenState();
}

class _${Params.templateName.token}ScreenState extends TemplateCommonState<${Params.templateName.token}Screen,Templates,Params,Results> {


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


  @override
  Widget paramField(bool fileGenerate) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap[Params.fileName]!,
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
              controller: paramMap[Params.example]!,
              labelText: "示例",
              validator: (value) {
                if (value != null && value != "") return null;
                return "类名不能为空";
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
    // region <- Logic: 生成代码 ->
    String result = generator();

    // endregion <- Logic: 生成代码->

    // region <- Logic: 赋值可复制文本 ->
    resultMap[Results.example]!.controller.text = result;
    // endregion <- Logic: 赋值可复制文本->

    // 展开所有可复制文本
    allExpandOrCollapse(true);

    // region <- Logic: 创建文件->
    if (fileGenerate) {
      safeCreateFile({"\$directory/\${paramMap[Params.fileName].text}": result});
    }
    // endregion <- Logic:创建文件 ->
  }

  // region <- Functions: 生成代码方法 ->
  String generator() {
    String result = "";
    result = Templates.example.source.replaceAll({Params.example.token: paramMap[Params.example]!.text});
    return result;
  }
  // endregion <- Functions: 生成代码方法 ->
}''';
