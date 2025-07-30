import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart';

import '../../model/param_type.dart';
import '../../model/template_source.dart';
import '../../model/template_common_enum.dart';
import './template_generate_template_source_enum.dart';
import './template_generate_template_source_screen.dart';
import './template_generate_template_source_source.dart';

enum Templates implements TemplatesFormat {
  screenPart,
  enumPart,
  sourcePart;

  const Templates();

  @override
  TemplateSource get source {
    switch (this) {
      case Templates.screenPart:
        return TemplateSource(name: this,  source: templateGenerateTemplateSourceScreen);
      case Templates.enumPart:
        return TemplateSource(name: this,  source: templateGenerateTemplateSourceEnum);
      case Templates.sourcePart:
        return TemplateSource(name: this,  source: templateGenerateTemplateSourceSource);
    }
  }


}

enum Params with ParamsFormat {
  templateName(type: ParamType.input, ),
  lowerTemplateName(type: ParamType.transfer,),
  language(type: ParamType.condition,),
  fileName(type: ParamType.input,);

  const Params({ required this.type});
  @override
  final ParamType type;

}

enum Results implements ResultsFormat {
  screenPart(name: "页面部分"),
  enumPart(name: "枚举部分"),
  sourcePart(name: "源部分");

  const Results({required this.name});

  @override
  final String name;

  @override
  Mode get language {
    switch (this) {
      case Results.screenPart:
        return dart;
      case Results.enumPart:
        return dart;
      case Results.sourcePart:
        return dart;
    }
  }
}
