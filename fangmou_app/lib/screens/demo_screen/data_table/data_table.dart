import 'package:flutter/material.dart';

class MyTable extends StatelessWidget {
  const MyTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        // 設定表格框線
        border: TableBorder(
          // 設定水平內部分隔線
          horizontalInside: const BorderSide(color: Colors.blue, width: 2.0, style: BorderStyle.solid),
          // 設定垂直內部分隔線
          verticalInside: const BorderSide(color: Colors.green, width: 1.0, style: BorderStyle.solid),
          // 您也可以設定外框線
          // top: BorderSide(color: Colors.red, width: 3),
          // bottom: BorderSide(color: Colors.red, width: 3),
        ),

        // 設定每一列的內容
        children: const <TableRow>[
          TableRow(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8.0), child: Text('標題 1', style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8.0), child: Text('標題 2', style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8.0), child: Text('標題 3', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          TableRow(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8.0), child: Text('A1')),
              Padding(padding: EdgeInsets.all(8.0), child: Text('B1')),
              Padding(padding: EdgeInsets.all(8.0), child: Text('C1')),
            ],
          ),
          TableRow(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8.0), child: Text('A2')),
              Padding(padding: EdgeInsets.all(8.0), child: Text('B2')),
              Padding(padding: EdgeInsets.all(8.0), child: Text('C2')),
            ],
          ),
        ],
      ),
    );
  }
}
