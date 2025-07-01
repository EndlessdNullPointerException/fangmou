import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpiderFunctionScreen extends StatelessWidget {
  const SpiderFunctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10000,
      child: Center(child: Column(children: [Text("爬虫功能"), Text("1.根据序号从指定网页获取对应的名字"), Text("2.获取仓库指定的用户从某个日期开始的所有的网盘链接、提取码以及解压密码")])),
    );
  }
}
