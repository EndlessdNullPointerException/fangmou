import 'package:flutter/material.dart';

/// 用于when之后加载或者错误状态的通用控件
///
Widget whenLoading() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.grey.withAlpha(33),
      valueColor: const AlwaysStoppedAnimation(Colors.blue),
      strokeWidth: 5,
    ),
  );
}
Widget whenError(Object error) {
  return Center(
    child: Column(children: [
      Icon(Icons.error,size: 40,color: Colors.red,),
      Text(error.toString())
    ],),
  );
}