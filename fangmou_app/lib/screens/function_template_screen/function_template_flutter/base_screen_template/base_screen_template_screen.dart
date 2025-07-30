import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_state.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../../utils/file.dart';
import './base_screen_template_enum.dart';

class BaseScreenTemplateScreen extends TemplateCommonScreen {
  const BaseScreenTemplateScreen({super.key, required super.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScreenTemplateScreenState();
}

class _BaseScreenTemplateScreenState extends TemplateCommonState<BaseScreenTemplateScreen, Templates, Params, Results> {
  // 生成的页面是否是一个 StatefulWidget
  bool statefulScreen = true;

  // 生成的页面的 provider 是否需要异步状态
  bool asyncProviderState = false;

  // 生成的页面的 provider 是否需要传入参数
  bool familyProvider = false;

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
            Spacer(flex: 1),
            Checkbox(
              value: statefulScreen,
              onChanged: (value) {
                setState(() {
                  statefulScreen = value!;
                });
              },
            ),
            Text("状态页面"),
            Checkbox(
              value: asyncProviderState,
              onChanged: (value) {
                setState(() {
                  asyncProviderState = value!;
                });
              },
            ),
            Text("异步 provider"),
            Checkbox(
              value: familyProvider,
              onChanged: (value) {
                setState(() {
                  familyProvider = value!;
                });
              },
            ),
            Text("参数 provider"),
            Spacer(flex: 1),
          ],
        ),
        Row(
          children: [
            Spacer(flex: 1),
            fangmouStandardTextFormField(
              flex: 10,
              controller: paramMap[Params.fileName]!,
              labelText: "文件名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "文件名不能为空";
              },
            ),
            Spacer(flex: 1),
            fangmouStandardTextFormField(
              flex: 10,
              controller: paramMap[Params.screenName]!,
              labelText: "页面名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "页面名不能为空";
              },
            ),
            Spacer(flex: 1),
          ],
        ),
      ],
    );
  }

  // region <- Functions: 代码生成方法 ->
  @override
  Future<void> generate(fileGenerate, directory) async {
    String modelResult = modelGenerator();
    String viewmodelResult = viewmodelGenerator();
    String viewResult = viewGenerator();

    // region <- Logic: 生成可复制文本 ->
    resultMap[Results.model]!.controller.text = modelResult;
    resultMap[Results.viewmodel]!.controller.text = viewmodelResult;
    resultMap[Results.view]!.controller.text = viewResult;
    // endregion <- Logic: 生成可复制文本->

    // 展开所有可复制文本
    allExpandOrCollapse(true);

    // region <- Logic: 生成文件->
    if (fileGenerate) {
      safeCreateFile({
        p.join(directory, paramMap[Params.fileName]! + "_screen", paramMap[Params.fileName]! + "_screen_model.dart"):
            modelResult,
        p.join(
              directory,
              paramMap[Params.fileName]! + "_screen",
              paramMap[Params.fileName]! + "_screen_viewmodel.dart",
            ):
            viewmodelResult,
        p.join(directory, paramMap[Params.fileName]! + "_screen", paramMap[Params.fileName]! + "_screen_view.dart"):
            viewResult,
      });
    }

    // endregion <- Logic:生成文件 ->
  }

  String modelGenerator() {
    String result = Templates.model.source.replaceAll({Params.screenName.token: paramMap[Params.screenName]!.text});
    return result;
  }

  String viewmodelGenerator() {
    String result;

    String currentState =
        asyncProviderState
            ? ""
            : '''
  FunctionTemplateScreenState get currentState => switch (state) {
    AsyncData(value: final value) => value,
    AsyncError() => throw Exception("FunctionTemplateScreenViewmodel 获取异步状态出现错误"),
    _ => FunctionTemplateScreenState.initiate([]),
  };''';

    result = Templates.viewmodel.source.replaceAll({
      Params.asyncProviderState.token:asyncProviderState ? "async" :"",
      Params.familyProvider.token: familyProvider? "Params" :"" ,
      Params.fileName.token: paramMap[Params.fileName]!.text,
      Params.screenName.token: paramMap[Params.screenName]!.text,
      Params.currentState.token: currentState,
    });
    return result;
  }

  String viewGenerator() {
    String result;
    if (statefulScreen) {
      result = Templates.statefulView.source.replaceAll({
        Params.screenName.token: paramMap[Params.screenName]!.text,
        Params.familyProvider.token:familyProvider? "Params" :"" ,
      });
    } else {
      result = Templates.statelessView.source.replaceAll({
        Params.screenName.token: paramMap[Params.screenName]!.text,
        Params.familyProvider.token: "",
        Params.buildReturn.token: "",
      });
    }
    return result;
  }

  // endregion <- Functions: 代码生成方法 ->
}
