import 'package:flutter/material.dart';

import '../../../model/sql/sql.dart';
import '../../function_template_screen/function_template_sql/table_create_template/sql_column_viewmodel.dart';

class EditableTableScreen extends StatefulWidget {
  const EditableTableScreen({super.key});

  @override
  State<EditableTableScreen> createState() => _EditableTableScreenState();
}

class _EditableTableScreenState extends State<EditableTableScreen> {
  // 表格数据源
  final List<SqlColumnModel> _items = [];

  bool get allChecked => _items.every((item) => item.checked == true);

  // 单元格 flex 值
  final List<int> _flexList = [1, 1, 1, 3, 3, 2, 2, 2, 2, 6];

  // 默认数据库
  DataBase currentDataBase = DataBase.sqlLite;

  @override
  void initState() {
    super.initState();
    initiateTable();
  }

  void initiateTable() {
    setState(() {
      _items.clear();
      _items.addAll(SqlColumnModel.baseColumns(currentDataBase));
    });
  }

  // 增加一行的逻辑
  void _addRow() {
    setState(() {
      _items.add(SqlColumnModel.initiate(currentDataBase));
    });
  }

  // 删除一行的逻辑
  void _removeRow(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          Row(
            children: [
              ...DataBase.values.map(
                (dataBase) => Row(
                  children: [
                    Radio(
                      value: dataBase,
                      groupValue: currentDataBase,
                      onChanged: (value) {
                        setState(() {
                          currentDataBase = value!;
                        });
                        initiateTable();
                      },
                    ),
                    Text(textAlign: TextAlign.center, dataBase.name),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              Spacer(),
              IconButton(icon: const Icon(Icons.add), onPressed: _addRow),
            ],
          ),
          Divider(height: 0),
          // 表头
          _buildHeader(),
          Divider(height: 0),
          // 表格内容
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _buildEditableRow(index);
              },
            ),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }

  // 构建表头
  Widget _buildHeader() {
    return IntrinsicHeight(
      child: Row(
        children: [
          // 为删除按钮留出空间
          Spacer(flex: _flexList[0]),
          const VerticalDivider(),
          Expanded(
            flex: _flexList[1],
            child: Padding(
              padding: const EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Checkbox(
                value: allChecked,
                onChanged: (value) {
                  setState(() {
                    for (var item in _items) {
                      item.checked = value ?? false;
                    }
                  });
                },
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: _flexList[2],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('序号', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: _flexList[3],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('列名', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: _flexList[4],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('数据类型', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),

          Expanded(
            flex: _flexList[5],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('长度', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),

          Expanded(
            flex: _flexList[6],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('NOT NULL', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),

          Expanded(
            flex: _flexList[7],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('默认值', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),

          Expanded(
            flex: _flexList[8],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('键', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const VerticalDivider(),

          Expanded(
            flex: _flexList[9],
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
              child: Text('注释', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // 构建可编辑的行
  Widget _buildEditableRow(int index) {
    final item = _items[index];
    return Column(
      key: ObjectKey(item),
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: _flexList[0],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeRow(index),
                  ),
                ),
              ),
              VerticalDivider(),
              Expanded(
                flex: _flexList[1],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: Checkbox(
                    value: item.checked,
                    onChanged: (value) {
                      setState(() {
                        item.checked = value ?? false;
                      });
                    },
                  ),
                ),
              ),
              VerticalDivider(),
              Expanded(
                flex: _flexList[2],
                child: Padding(padding: EdgeInsetsGeometry.only(left: 5, right: 5), child: Text("${index + 1}")),
              ),
              VerticalDivider(),

              Expanded(
                flex: _flexList[3],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: TextFormField(
                    initialValue: item.sqlColumn.columnName,
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      item.sqlColumn.columnName = value;
                    },
                  ),
                ),
              ),
              VerticalDivider(),

              Expanded(
                flex: _flexList[4],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: DropdownButtonFormField<DataType>(
                    value: item.sqlColumn.dataType,
                    decoration: const InputDecoration(
                      // 移除默认状态下的下划线
                      enabledBorder: InputBorder.none,
                      // 移除获得焦点时的下划线
                      focusedBorder: InputBorder.none,
                      // 你也可以设置其他边框样式，例如
                      // 如果想让内容更紧凑，可以设置 contentPadding
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    items:
                        currentDataBase.dataBaseTypeList.map((value) {
                          return DropdownMenuItem<DataType>(value: value, child: Text(value.name));
                        }).toList(),
                    onChanged:
                        (v) => setState(() {
                          // 重新设置数据类型后，长度和默认值也需要重新设置
                          item.sqlColumn.dataType = v!;
                          item.sqlColumn.long = 0;
                          item.sqlColumn.defaultValue = "";
                        }),
                  ),
                ),
              ),

              VerticalDivider(),
              Expanded(
                flex: _flexList[5],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: TextFormField(
                    initialValue: item.sqlColumn.long.toString(),
                    decoration: const InputDecoration(border: InputBorder.none),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      item.sqlColumn.long = int.tryParse(value)!;
                    },
                  ),
                ),
              ),
              VerticalDivider(),

              Expanded(
                flex: _flexList[6],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: DropdownButtonFormField<bool>(
                    value: item.sqlColumn.notNull,
                    decoration: const InputDecoration(
                      // 移除默认状态下的下划线
                      enabledBorder: InputBorder.none,
                      // 移除获得焦点时的下划线
                      focusedBorder: InputBorder.none,
                      // 你也可以设置其他边框样式，例如
                      // 如果想让内容更紧凑，可以设置 contentPadding
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    items: [
                      DropdownMenuItem<bool>(value: true, child: Text("NOT NULL")),
                      DropdownMenuItem<bool>(value: false, child: Text("NULL")),
                    ],
                    onChanged: (v) => setState(() => item.sqlColumn.notNull = v ?? true),
                  ),
                ),
              ),
              VerticalDivider(),
              Expanded(
                flex: _flexList[7],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: TextFormField(
                    initialValue: item.sqlColumn.defaultValue,
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      item.sqlColumn.defaultValue = value;
                    },
                  ),
                ),
              ),
              VerticalDivider(),

              Expanded(
                flex: _flexList[8],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: DropdownButtonFormField<Index>(
                    value: item.sqlColumn.index,
                    decoration: const InputDecoration(
                      // 移除默认状态下的下划线
                      enabledBorder: InputBorder.none,
                      // 移除获得焦点时的下划线
                      focusedBorder: InputBorder.none,
                      // 你也可以设置其他边框样式，例如
                      // 如果想让内容更紧凑，可以设置 contentPadding
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    items:
                        Index.values.map((value) {
                          return DropdownMenuItem<Index>(value: value, child: Text(value.name));
                        }).toList(),
                    onChanged: (v) => setState(() => item.sqlColumn.index = v ?? Index.none),
                  ),
                ),
              ),

              VerticalDivider(),
              Expanded(
                flex: _flexList[9],
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 5, right: 5),
                  child: TextFormField(
                    initialValue: item.sqlColumn.comment,
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      item.sqlColumn.comment = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 0),
      ],
    );
  }
}
