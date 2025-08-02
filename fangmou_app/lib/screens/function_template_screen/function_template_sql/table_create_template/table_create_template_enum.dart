import 'package:fangmou_app/screens/function_template_screen/model/param_type.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_enum.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/sql.dart';

enum Params with ParamsFormat {
  tableName(type: ParamType.input),
  tableFieldsAndIndex(type: ParamType.condition),
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
