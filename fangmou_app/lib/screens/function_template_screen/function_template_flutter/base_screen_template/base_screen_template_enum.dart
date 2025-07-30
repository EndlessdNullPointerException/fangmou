import 'package:fangmou_app/screens/function_template_screen/model/param_type.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart';

import '../../model/template_source.dart';
import 'base_screen_template_source_model.dart';
import 'base_screen_template_source_stateful_view.dart';
import 'base_screen_template_source_stateless_view.dart';
import 'base_screen_template_source_viewmodel.dart';

enum Templates implements TemplatesFormat {
  statefulView,
  statelessView,
  model,
  viewmodel;

  const Templates();

  @override
  TemplateSource get source {
    switch (this) {
      case Templates.statefulView:
        return TemplateSource(name: this, source: baseScreenTemplateSourceStatefulView);
      case Templates.statelessView:
        return TemplateSource(name: this, source: baseScreenTemplateSourceStatelessView);
      case Templates.model:
        return TemplateSource(name: this, source: baseScreenTemplateSourceModel);
      case Templates.viewmodel:
        return TemplateSource(name: this, source: baseScreenTemplateSourceViewmodel);
    }
  }
}

enum Params with ParamsFormat {
  screenName(type: ParamType.input),
  asyncProviderState(type: ParamType.condition),
  familyProvider(type: ParamType.condition),
  currentState(type: ParamType.input),
  buildReturn(type: ParamType.input),
  statefulScreen(type: ParamType.condition),
  fileName(type: ParamType.input);

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
