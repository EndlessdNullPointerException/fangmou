import 'package:fangmou_app/screens/function_template_screen/function_template_flutter/template_generate_template/template_generate_template_screen.dart';

import '../../model/template_common_state.dart';
import './template_generate_template_enum.dart';

mixin SourceSource on TemplateCommonState<TemplateGenerateTemplateScreen, Params, Results> {
  String get sourceSource => '''
import './${paramMap[Params.fileName]}_enum.dart';
import './${paramMap[Params.fileName]}_screen.dart';

mixin Source on TemplateCommonState<${paramMap[Params.templateName]}Screen,Templates,Params,Results> {
  String get ${paramMap[Params.lowerTemplateName]}Source => \'\'\'
  \${paramMap[Params.example]}
\'\'\';
}''';
}
