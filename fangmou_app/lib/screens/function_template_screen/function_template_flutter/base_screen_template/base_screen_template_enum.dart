import 'package:fangmou_app/screens/function_template_screen/model/param_type.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart';

enum Params with ParamsFormat {
  screenName(type: ParamType.input),
  fileName(type: ParamType.input),
  lowerScreenName(type: ParamType.transfer),
  viewBuildReturnValue(type: ParamType.condition),
  viewmodelBuildReturnType(type: ParamType.condition),
  asyncProviderState(type: ParamType.condition),
  familyProvider(type: ParamType.condition),
  viewModelCurrentState(type: ParamType.condition),
  statefulScreen(type: ParamType.condition);

  const Params({required this.type});

  @override
  final ParamType type;
}

enum Results implements ResultsFormat {
  view(name: "Screen"),
  model(name: "State"),
  viewmodel(name: "ViewModel");

  const Results({required this.name});
  @override
  final String name;
  @override
  Mode get language {
    switch (this) {
      case Results.view:
        return dart;
      case Results.model:
        return dart;
      case Results.viewmodel:
        return dart;
    }
  }
}
