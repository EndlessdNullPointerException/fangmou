import 'dart:io';

import 'package:fangmou_app/common_widgets/fangmou_standard_text_field.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_sql/table_create_template/sql_column_viewmodel.dart';
import 'package:fangmou_app/screens/function_template_screen/function_template_sql/table_create_template/editable_table.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_screen.dart';
import 'package:fangmou_app/screens/function_template_screen/model/template_common_state.dart';
import 'package:fangmou_app/screens/function_template_screen/widget/copyable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/sql/sql.dart';
import '../../../../utils/constants/constants.dart';

import './table_create_template_enum.dart';

class TableCreateTemplateScreen extends TemplateCommonScreen {
  const TableCreateTemplateScreen({super.key, required super.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableCreateTemplateScreenState();
}

class _TableCreateTemplateScreenState
    extends TemplateCommonState<TableCreateTemplateScreen, Templates, Params, Results> {
  // 默认数据库
  // TODO 这个属性应该可以在设置中修改
  DataBase currentDataBase = DataBase.sqlLite;
  List<SqlColumnModel> sqlColumnModelList = [];

  @override
  void paramMapInitiate() {
    paramMap = {for (Params param in Params.values) param: TextEditingController()};
  }

  @override
  void resultMapInitiate() {
    resultMap = {
      for (Results result in Results.values) result: CopyableFieldParams(name: result.name, language: result.language),
    };
  }

  @override
  Widget paramField(bool fileGenerate) {
    return Column(
      children: [
        EditableTable(
          items: sqlColumnModelList,
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
              controller: paramMap[Params.fileName]!,
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
              controller: paramMap[Params.tableName]!,
              labelText: "表名",
              validator: (value) {
                if (value != null && value != "") return null;
                return "表名不能为空";
              },
            ),
            Spacer(flex: 10),
            fangmouStandardTextFormField(
              flex: 30,
              controller: paramMap[Params.tableComment]!,
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

  // region <- Functions:代码生成方法 ->
  @override
  Future<void> generate(fileGenerate, directory) async {
    String result = "";
    // region <- Logic: 生成可复制文本 ->
    result = templatesGenerator();
    resultMap[Results.sqlResult]!.controller.text = result;
    // endregion <- Logic: 生成可复制文本->

    // region <- Logic: 生成文件->

    try {
      var file = File("$directory/${paramMap[Params.fileName]}.sql");
      await file.writeAsString(result);
    } catch (e) {
      logger.e(e);
    }
    // endregion <- Logic:生成文件 ->
  }

  String templatesGenerator() {
    String result = "";

    switch (currentDataBase) {
      case DataBase.mySql:
        result = Templates.mySqlCreateTable.source.replaceAll({
          Params.tableName.token: paramMap[Params.tableName]!.text,
          Params.tableFieldsAndIndex.token: fieldsAndIndex(),
          Params.tableComment.token: paramMap[Params.tableComment]!.text,
        });
        break;
      case DataBase.sqlServer:
        result = Templates.sqlServerCreateTable.source.replaceAll({
          Params.tableName.token: paramMap[Params.tableName]!.text,
          Params.tableFieldsAndIndex.token: fieldsAndIndex(),
          Params.tableComment.token: paramMap[Params.tableComment]!.text,
        });
        break;
      case DataBase.sqlLite:
        result = Templates.sqlLiteCreateTable.source.replaceAll({
          Params.tableName.token: paramMap[Params.tableName]!.text,
          Params.tableFieldsAndIndex.token: fieldsAndIndex(),
        });
        break;
    }

    return result;
  }

  String fieldsAndIndex() {
    StringBuffer sb = StringBuffer();

    for (final sqlColumnModel in sqlColumnModelList) {
      final column = sqlColumnModel.sqlColumn;
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
        sqlColumnModelList.map((item) => item.sqlColumn).where((item) => item.index != Index.none).toList();

    if (indexList.isNotEmpty) {}

    String result = sb.toString();
    if (result.endsWith(",\n")) {
      result = result.substring(0, result.lastIndexOf(",\n"));
    }

    return result;
  }

  // endregion <- Functions:代码生成方法 ->
}
