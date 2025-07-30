import './template_generate_template_enum.dart';

final String templateGenerateTemplateSourceSource = '''
import './${Params.fileName.token}_enum.dart';

final String ${Params.lowerTemplateName.token}Source = \'\'\'
\${Params.example.token}
\'\'\';''';
