import 'dart:io';

import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_sql/model/sql_column_viewmodel.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_sql/widget/editable_table.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../model/sql/sql.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../model/template.dart';
import '../widget/template_base_layout.dart';

enum TableCreateTemplates {
  mySqlCreateTable,
  sqlLiteCreateTable,
  sqlServerCreateTable;

  const TableCreateTemplates();

  Template get template {
    switch (this) {
      case TableCreateTemplates.mySqlCreateTable:
        return Template(
          placeholders: TableCreateTemplates.mySqlCreateTable.tokens,
          template: '''
CREATE TABLE IF NOT EXISTS `${TableCreateTokens.tableName.token}` (
${TableCreateTokens.tableFieldsAndIndex.token}
) ENGINE=InnoDB  -- 默认事务引擎（支持ACID）
DEFAULT CHARSET=utf8mb4  -- 字符集（兼容emoji）
COLLATE=utf8mb4_0900_ai_ci  -- 排序规则（Unicode 14.0）
AUTO_INCREMENT=10001  -- 自增起始值
COMMENT='${TableCreateTokens.tableComment.token}';''',
        );
      case TableCreateTemplates.sqlLiteCreateTable:
        return Template(
          placeholders: TableCreateTemplates.sqlLiteCreateTable.tokens,
          template: '''
CREATE TABLE ${TableCreateTokens.tableName.token} (
${TableCreateTokens.tableFieldsAndIndex.token}
);''',
        );
      case TableCreateTemplates.sqlServerCreateTable:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  List<String> get tokens =>
      TableCreateTokens.values.where((item) => item.templates.contains(this)).map((item) => item.token).toList();
}

enum TableCreateTokens {
  tableName(
    token: "{{TABLE_NAME}}",
    templates: [TableCreateTemplates.mySqlCreateTable, TableCreateTemplates.sqlLiteCreateTable],
  ),
  tableFieldsAndIndex(
    token: "{{TABLE_FIELDS_AND_INDEX}}",
    templates: [TableCreateTemplates.mySqlCreateTable, TableCreateTemplates.sqlLiteCreateTable],
  ),
  tableComment(token: "{{TABLE_COMMENT}}", templates: [TableCreateTemplates.mySqlCreateTable]);

  const TableCreateTokens({required this.token, required this.templates});
  final String token;
  final List<TableCreateTemplates> templates;
}

class TableCreateTemplateScreen extends ConsumerStatefulWidget {
  final FangMouGoRoute route;
  const TableCreateTemplateScreen({super.key, required this.route});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableCreateTemplateScreenState();
}

class _TableCreateTemplateScreenState extends ConsumerState<TableCreateTemplateScreen> {
  // 默认数据库
  // TODO 这个属性应该可以在设置中修改
  DataBase currentDataBase = DataBase.sqlLite;

  final Map<String, dynamic> paramMap = {
    "tableName": TextEditingController(),
    "tableComment": TextEditingController(),
    "fileName": TextEditingController(),
  };
  final Map<String, TextEditingController> resultMap = {"mySqlCreateTableResult": TextEditingController()};

  List<SqlColumnViewmodel> sqlColumnViewmodelList = [];

  @override
  Widget build(BuildContext context) {
    return TemplateBaseLayout(
      name: widget.route.name!,
      paramField: paramField,
      resultField: resultField(),
      resetParams: resetParams,
      clearAll: clearAll,
      generate: generate,
    );
  }

  // region <- Functions:布局方法 ->
  Widget paramField(bool fileGenerate) {
    return Column(
      children: [
        EditableTable(
          items: sqlColumnViewmodelList,
          dataBaseNotifier:
              (dataBase) => setState(() {
                currentDataBase = dataBase;
              }),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Spacer(flex: 15),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap['fileName']!,
              labelText: "文件名",
              validator: (value) {
                if (!fileGenerate) return null;
                if (value != null && value != "") return null;
                return "文件名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap['tableName']!,
              labelText: "表名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "表名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap['tableComment']!,
              labelText: "表注释",
              validator: (value) {
                return null;
              },
            ),
            Spacer(flex: 15),
          ],
        ),
      ],
    );
  }

  Widget resultField() {
    return Column(children: [CopyableField(controller: resultMap["mySqlCreateTableResult"]!)]);
  }
  // endregion <- Functions:布局方法 ->

  // region <- Functions:基本方法 ->
  void resetParams(formKey) {
    formKey.currentState!.reset();
    for (var item in paramMap.values) {
      item.text = "";
    }

    setState(() {
      sqlColumnViewmodelList.clear();
    });
  }

  void clearAll(formKey) {
    resetParams(formKey);
    for (var item in resultMap.values) {
      item.text = "";
    }
  }

  Future<void> generate(formKey, fileGenerate, directory) async {
    try {
      // region <- Logic:参数校验 ->
      if (formKey.currentState == null) return;
      if (!formKey.currentState!.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        return;
      }
      if (fileGenerate) {
        if (directory.isEmpty) {
          showCustomDialog("请选择路径");
          return;
        }
      }
      // endregion <- Logic:参数校验 ->

      String result = "";

      // region <- Logic: 生成可复制文本 ->
      result = tableCreateTemplatesGenerator();
      resultMap["mySqlCreateTableResult"]!.text = result;
      // endregion <- Logic: 生成可复制文本->

      // region <- Logic: 生成文件->


      try {
        var file = File("$directory/${paramMap["fileName"].text}.sql");
        await file.writeAsString(result);
      } catch (e) {
        logger.e(e);
      }
      // endregion <- Logic:生成文件 ->
    } catch (e) {
      showCustomDialog(e.toString());
      rethrow;
    }
  }
  // endregion <- Functions:基本方法 ->

  // region <- Functions: 生成代码方法 ->
  String tableCreateTemplatesGenerator() {
    String result = "";

    switch (currentDataBase) {
      case DataBase.mySql:
        result = TableCreateTemplates.mySqlCreateTable.template.replaceAll({
          TableCreateTokens.tableName.token: paramMap["tableName"]!.text,
          TableCreateTokens.tableFieldsAndIndex.token: fieldsAndIndex(),
          TableCreateTokens.tableComment.token: paramMap["tableComment"]!.text,
        });
        break;
      case DataBase.sqlServer:
        result = TableCreateTemplates.sqlServerCreateTable.template.replaceAll({
          TableCreateTokens.tableName.token: paramMap["tableName"]!.text,
          TableCreateTokens.tableFieldsAndIndex.token: fieldsAndIndex(),
          TableCreateTokens.tableComment.token: paramMap["tableComment"]!.text,
        });
        break;
      case DataBase.sqlLite:
        result = TableCreateTemplates.sqlLiteCreateTable.template.replaceAll({
          TableCreateTokens.tableName.token: paramMap["tableName"]!.text,
          TableCreateTokens.tableFieldsAndIndex.token: fieldsAndIndex(),
        });
        break;
    }

    return result;
  }

  String fieldsAndIndex() {
    StringBuffer sb = StringBuffer();

    for (final sqlColumnViewmodel in sqlColumnViewmodelList) {
      final column = sqlColumnViewmodel.sqlColumn;
      String columnName = column.columnName;
      String dataType = column.dataType.name;
      String long = column.long > 0 ? "(${column.long})" : "";
      String notNull = column.notNull ? "NOT NULL" : "";
      String defaultValue = column.defaultValue.isNotEmpty ? "DEFAULT ${column.defaultValue}" : "";
      String comment =
          column.comment.isNotEmpty && currentDataBase != DataBase.sqlLite ? "COMMENT `${column.comment}`" : "";

      sb.write("  $columnName $dataType$long $notNull $defaultValue $comment,\n");
    }

    final indexList =
        sqlColumnViewmodelList.map((item) => item.sqlColumn).where((item) => item.index != Index.none).toList();

    if (indexList.isNotEmpty) {}

    String result = sb.toString();
    if (result.endsWith(",\n")) {
      result = result.substring(0, result.lastIndexOf(",\n"));
    }

    return result;
  }

  // endregion <- Functions: 生成代码方法 ->
}
