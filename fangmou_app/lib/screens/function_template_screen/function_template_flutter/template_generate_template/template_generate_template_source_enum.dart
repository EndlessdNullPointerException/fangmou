import './template_generate_template_enum.dart';

final String templateGenerateTemplateSourceEnum = '''
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/${Params.language.token}.dart';

import '../../model/param_type.dart';
import '../../model/template_source.dart';
import '../../model/template_common_enum.dart';
import './${Params.fileName.token}_source.dart';

enum Templates implements TemplatesFormat{

  example;

  const Templates();

  @override
  TemplateSource get source {
    switch (this) {
      case Templates.example:
        return TemplateSource(
          name: this,
          placeholders: tokens,
          source: ${Params.lowerTemplateName.token}Source,
        );
    }
  }

  @override
  List<String> get tokens =>
      Params.values.where((item) => item.templates.contains(this)).map((item) => item.token).toList();
}

enum Params with ParamsFormat{
  fileName( type: ParamType.input, templates: []),
  example( type: ParamType.input, templates: [Templates.example]);
 
  const Params({ required this.templates, required this.type});

  @override
  final ParamType type;
  @override
  final List<Templates> templates;
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
        return ${Params.language.token};
    }
  }
}''';
