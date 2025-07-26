import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../model/sql/sql.dart';
import '../../../../utils/common.dart';
import '../model/sql_column_viewmodel.dart';

typedef DataBaseNotifier = void Function(DataBase);

class EditableTable extends StatefulWidget {
  final List<SqlColumnViewmodel> items;
  final DataBaseNotifier dataBaseNotifier;

  const EditableTable({super.key, required this.items, required this.dataBaseNotifier});

  @override
  State<EditableTable> createState() => _EditableTableScreenState();
}

// 单元格 flex 值
final Map<String, int> _flexMap = {
  "deleteButton": 1,
  "checkBox": 1,
  "no": 1,
  "columnName": 3,
  "dataType": 3,
  "long": 2,
  "defaultValue": 2,
  "notNull": 2,
  "index": 2,
  "comment": 6,
};

class _EditableTableScreenState extends State<EditableTable> {
  // 表格数据源

  bool get allChecked => widget.items.every((item) => item.checked == true);

  // 默认数据库
  // TODO 这个属性应该可以在设置中修改
  DataBase currentDataBase = DataBase.sqlLite;

  @override
  void initState() {
    super.initState();
    initiateTable();
  }

  void initiateTable() {
    setState(() {
      widget.items.clear();
      widget.items.addAll(SqlColumnViewmodel.baseColumns(currentDataBase));
    });
  }

  // 增加一行的逻辑
  void _addRow() {
    setState(() {
      widget.items.add(SqlColumnViewmodel.initiate(currentDataBase));
    });
  }

  // 删除一行的逻辑
  void _removeRow(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.add), onPressed: _addRow),
              IconButton(icon: const Icon(Icons.arrow_drop_up), onPressed: () => moveSelected(true)),
              IconButton(icon: const Icon(Icons.arrow_drop_down), onPressed: () => moveSelected(false)),
              Spacer(),
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
                        widget.dataBaseNotifier(value!);
                      },
                    ),
                    Text(textAlign: TextAlign.center, dataBase.name),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          Divider(height: 0),
          // 表头
          _buildHeader(),
          Divider(height: 0),
          SizedBox(
            height: 540,
            child: //表格内容
                ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return _buildEditableRow(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 构建表头
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Spacer(flex: _flexMap['deleteButton']!),
            const VerticalDivider(),
            Expanded(
              flex: _flexMap['checkBox']!,
              child: Padding(
                padding: const EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Checkbox(
                  value: allChecked,
                  onChanged: (value) {
                    setState(() {
                      for (var item in widget.items) {
                        item.checked = value ?? false;
                      }
                    });
                  },
                ),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: _flexMap['no']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('序号', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: _flexMap['columnName']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('列名', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              flex: _flexMap['dataType']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('数据类型', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),

            Expanded(
              flex: _flexMap['long']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('长度', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),

            Expanded(
              flex: _flexMap['defaultValue']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('NOT NULL', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),

            Expanded(
              flex: _flexMap['notNull']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('默认值', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),

            Expanded(
              flex: _flexMap['index']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('键', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const VerticalDivider(),

            Expanded(
              flex: _flexMap['comment']!,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 10, bottom: 10),
                child: Text('注释', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建可编辑的行
  Widget _buildEditableRow(int index) {
    final item = widget.items[index];
    return Container(
      color: index % 2 == 0 ? Color.fromRGBO(240, 248, 255, 1) : Colors.white,
      child: Column(
        key: ObjectKey(item),
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: _flexMap['deleteButton']!,
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
                  flex: _flexMap['checkBox']!,
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
                  flex: _flexMap['no']!,
                  child: Padding(padding: EdgeInsetsGeometry.only(left: 5, right: 5), child: Text("${index + 1}")),
                ),
                VerticalDivider(),

                Expanded(
                  flex: _flexMap['columnName']!,
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
                  flex: _flexMap['dataType']!,
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
                  flex: _flexMap['long']!,
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
                  flex: _flexMap['defaultValue']!,
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
                  flex: _flexMap['notNull']!,
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
                  flex: _flexMap['index']!,
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
                  flex: _flexMap['comment']!,
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
      ),
    );
  }

  void moveSelected(bool moveUp) {
    final item = widget.items.where((item) => item.checked).toList();

    if (item.isEmpty || item.length > 1) {
      showToast(
        '请选择一项进行移动',
        position: ToastPosition.top,
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        radius: 10.0,
        textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
      );
      return;
    }

    final index = widget.items.indexOf(item.first);
    setState(() {
      moveElement(widget.items, index, moveUp: moveUp, modifyInPlace: true);
    });
  }
}
