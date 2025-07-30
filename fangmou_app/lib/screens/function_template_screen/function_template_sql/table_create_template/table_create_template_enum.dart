import 'package:fangmou_app/screens/function_template_screen/model/param_type.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/sql.dart';

import '../../model/template_source.dart';

enum Templates implements TemplatesFormat {
  mySqlCreateTable,
  sqlLiteCreateTable,
  sqlServerCreateTable;

  const Templates();

  @override
  TemplateSource get source {
    switch (this) {
      case Templates.mySqlCreateTable:
        return TemplateSource(
          name: this,
          source: '''
CREATE TABLE IF NOT EXISTS `${Params.tableName.token}` (
${Params.tableFieldsAndIndex.token}
) ENGINE=InnoDB  -- 默认事务引擎（支持ACID）
DEFAULT CHARSET=utf8mb4  -- 字符集（兼容emoji）
COLLATE=utf8mb4_0900_ai_ci  -- 排序规则（Unicode 14.0）
AUTO_INCREMENT=10001  -- 自增起始值
COMMENT='${Params.tableComment.token}';''',
        );
      case Templates.sqlLiteCreateTable:
        return TemplateSource(
          name: this,
          source: '''
CREATE TABLE ${Params.tableName.token} (
${Params.tableFieldsAndIndex.token}
);''',
        );
      case Templates.sqlServerCreateTable:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

enum Params with ParamsFormat {
  tableName(type: ParamType.input),
  tableFieldsAndIndex(type: ParamType.input),
  tableComment(type: ParamType.input),
  fileName(type: ParamType.input);

  const Params({required this.type});

  @override
  final ParamType type;
}

enum Results implements ResultsFormat {
  sqlResult(name: "SQL建表语句");

  const Results({required this.name});

  @override
  final String name;

  @override
  Mode get language => sql;
}
