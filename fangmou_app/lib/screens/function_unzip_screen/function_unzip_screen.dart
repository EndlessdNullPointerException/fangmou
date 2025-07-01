import 'package:fangmou_app/screens/function_unzip_screen/widget/password_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/DirectoryPathSelector.dart';
import 'function_unzip_screen_viewmodel.dart';

class FunctionUnzipScreen extends ConsumerWidget {
  const FunctionUnzipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(functionUnzipScreenViewModelProvider);
    var screenViewmodel = ref.watch(functionUnzipScreenViewModelProvider.notifier);
    return switch (screenState) {
      // 数据加载成功
      AsyncData(value: final state) => staticWidget(screenViewmodel, [
        DirectoryPathSelector(controller: state.pathController),
        PasswordItemWidget(deleteCallBack: screenViewmodel.deletePasswordItem, passwordControllerList: state.passwordControllerList),
        Checkbox(
          value: state.decompressDescendantFolder,
          onChanged: (bool? value) {
            screenViewmodel.changeDecompressDescendantFolder(value);
          },
        ),
      ]),
      _ => staticWidget(screenViewmodel, [
        DirectoryPathSelector(controller: TextEditingController()),
        Text("获取数据中"),
        Checkbox(value: false, onChanged: (bool? value) {}),
      ]),
    };
  }

  Widget staticWidget(screenViewmodel, List<Widget> dynamicWidgets) {
    return Column(
      children: [
        dynamicWidgets[0],
        SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(children: [Text("解压密码："), ElevatedButton(onPressed: screenViewmodel.addPasswordItem, child: Text("新增密码项"))]),
        ),
        dynamicWidgets[1],
        dynamicWidgets[2],
        SizedBox(height: 20),
        ElevatedButton(onPressed: screenViewmodel.decompress, child: Text("解压")),
        SizedBox(height: 20),
        ElevatedButton(onPressed: screenViewmodel.saveUnzipPasswordLocal, child: Text("保存")),
        SizedBox(height: 20),
        ElevatedButton(onPressed: screenViewmodel.unzipTest, child: Text("解压文件测试")),
        SizedBox(height: 20),
        ElevatedButton(onPressed: screenViewmodel.getZipFileTest, child: Text("获取指定路径下的压缩文件测试")),
        SizedBox(height: 20),
        Text("1.解压当前文件夹下的所有文件"),
        Text("2.解压当前文件夹下的所有文件(包括子文件夹)"),
        Text("3.解压文件时进行检查，并且根据需要创建新文件夹"),
        Text("4.保存解压密码，并且可以新增解压密码"),
      ],
    );
  }
}
