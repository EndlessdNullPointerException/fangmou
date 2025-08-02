import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_screen.dart';

import '../../model/template_common_state.dart';
import './template_generate_template_enum.dart';

mixin SourceEnum on TemplateCommonState<TemplateGenerateTemplateScreen, Params, Results> {
  String get sourceEnum => '''
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/${paramMap[Params.language]}.dart';

import '../../model/param_type.dart';
import '../../model/template_source.dart';
import '../../model/template_common_enum.dart';
import './${paramMap[Params.fileName]}_source.dart';

enum Params with ParamsFormat{
  fileName( type: ParamType.input,),
  example( type: ParamType.input,);
 
  const Params({ required this.type});

  @override
  final ParamType type;
}

enum Results implements ResultsFormat{
  example(name: "示例",);

  const Results({required this.name});

  @override
  final String name;

  @override
  Mode get language {
    switch (this) {
      case Results.example:
        return ${paramMap[Params.language]};
    }
  }
}''';
}
