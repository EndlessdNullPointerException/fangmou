import 'package:fangmou_app/common_widgets/fangmou_standard_widget.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/base_screen_template/base_screen_template_source_model.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/base_screen_template/base_screen_template_source_stateless_view.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/base_screen_template/base_screen_template_source_viewmodel.dart';
import 'package:fangmou_app/screens/function_template_screen/model/param_map.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_state.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../../utils/constants/constants.dart';
import '../../../../utils/string_utils.dart';
import '../../../../utils/file_utils.dart';
import './base_screen_template_enum.dart';
import 'base_screen_template_source_stateful_view.dart';

class BaseScreenTemplateScreen extends TemplateCommonScreen {
  const BaseScreenTemplateScreen({super.key, required super.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScreenTemplateScreenState();
}

class _BaseScreenTemplateScreenState extends TemplateCommonState<BaseScreenTemplateScreen, Params, Results>
    with SourceStatefulView, SourceStatelessView, SourceModel, SourceViewmodel {
  // 生成的页面是否是一个 StatefulWidget
  bool statefulScreen = true;

  // 生成的页面的 provider 是否需要异步状态
  bool asyncProviderState = false;

  // 生成的页面的 provider 是否需要传入参数
  bool familyProvider = false;

  @override
  void paramMapInitiate() {
    paramMap = ParamMap({
      Params.screenName: TextEditingController(),
      Params.fileName: TextEditingController(),
      Params.lowerScreenName: () => changeFirstLetterCase(paramMap[Params.screenName], toUpper: false),
      Params.viewBuildReturnValue: "",
      Params.viewmodelBuildReturnType: "",
      Params.viewModelCurrentState: "",
      Params.statefulScreen: "",
      Params.asyncProviderState: "",
      Params.familyProvider: "",
    });
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
              controller: paramMap.getController(Params.fileName),
              labelText: "文件名",
              validator: (value) {
                return null;
              },
            ),
            Spacer(flex: 1),
            fangmouStandardTextFormField(
              flex: 10,
              controller: paramMap.getController(Params.screenName),
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
    if (asyncProviderState) {
      paramMap[Params.viewBuildReturnValue] = '''
    screenState.when(
      data: (screenState) => layout(screenState, screenViewmodel),
      error: whenError,
      loading: whenLoading,
    )''';
      paramMap[Params.viewModelCurrentState] = '''
  ${paramMap[Params.screenName]}State get currentState => switch (state) {
    AsyncData(value: final value) => value,
    AsyncError() => throw Exception("FunctionTemplateScreenViewmodel 获取异步状态出现错误"),
    _ => ${paramMap[Params.screenName]}ScreenState.initiate([]),
  };''';
      paramMap[Params.asyncProviderState] = "async";
      paramMap[Params.viewmodelBuildReturnType] = "Future<${paramMap[Params.screenName]}ScreenState>";
    } else {
      paramMap[Params.viewBuildReturnValue] = "Container()";
      paramMap[Params.viewModelCurrentState] = "";
      paramMap[Params.asyncProviderState] = "";
      paramMap[Params.viewmodelBuildReturnType] = "${paramMap[Params.screenName]}ScreenState";
    }

    paramMap[Params.familyProvider] = familyProvider ? "(params)" : "";

    // 如果文件名未设置，则默认采用页面名转写形式
    if (paramMap[Params.fileName].isEmpty) {
      setState(() {
        paramMap[Params.fileName] = camelToSnake(paramMap[Params.screenName]);
      });
    }

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
      String fileName = paramMap[Params.fileName];
      safeCreateFile({
        p.join(directory, "${fileName}_screen", "${fileName}_screen_state.dart"): modelResult,
        p.join(directory, "${fileName}_screen", "${fileName}_screen_viewmodel.dart"): viewmodelResult,
        p.join(directory, "${fileName}_screen", "${fileName}_screen.dart"): viewResult,
      });
    }
    // endregion <- Logic:生成文件 ->
  }

  String viewGenerator() {
    String result;
    if (statefulScreen) {
      result = sourceStatefulView;
    } else {
      result = sourceStatelessView;
    }
    return result;
  }

  String modelGenerator() {
    return sourceModel;
  }

  String viewmodelGenerator() {
    return sourceViewmodel;
  }

  // endregion <- Functions: 代码生成方法 ->
}
