import 'package:fangmou_app/screens/function_template_screen/function_template_sql/table_create_template/table_create_template_screen.dart';

import '../../model/template_common_state.dart';
import './table_create_template_enum.dart';

mixin SourceMysql on TemplateCommonState<TableCreateTemplateScreen, Params, Results> {
  String get sourceMysql => '''
CREATE TABLE IF NOT EXISTS `${paramMap[Params.tableName]}` (
${paramMap[Params.tableFieldsAndIndex]}
) ENGINE=InnoDB  -- 默认事务引擎（支持ACID）
DEFAULT CHARSET=utf8mb4  -- 字符集（兼容emoji）
COLLATE=utf8mb4_0900_ai_ci  -- 排序规则（Unicode 14.0）
AUTO_INCREMENT=10001  -- 自增起始值
COMMENT='${paramMap[Params.tableComment]}';''';
}
