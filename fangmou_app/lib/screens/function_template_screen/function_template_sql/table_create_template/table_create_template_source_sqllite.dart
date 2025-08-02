import 'package:fangmou_app/screens/function_template_screen/function_template_sql/table_create_template/table_create_template_screen.dart';

import '../../model/template_common_state.dart';
import './table_create_template_enum.dart';

mixin SourceSqllite on TemplateCommonState<TableCreateTemplateScreen, Params, Results> {
  String get sourceSqllite => '''
CREATE TABLE ${paramMap[Params.tableName]} (
${paramMap[Params.tableFieldsAndIndex]}
);''';
}
