import 'package:fangmou_app/screens/function_decompress_screen/widget/password_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/DirectoryPathSelector.dart';
import 'function_decompress_screen_viewmodel.dart';

class FunctionDecompressScreen extends ConsumerWidget {
  const FunctionDecompressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenState = ref.watch(functionDecompressScreenViewModelProvider);
    var screenViewmodel = ref.watch(functionDecompressScreenViewModelProvider.notifier);
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

  Widget staticWidget(FunctionDecompressScreenViewModel screenViewmodel, List<Widget> dynamicWidgets) {
    return Column(
      children: [
        dynamicWidgets[0],
        SizedBox(height: 20),
        Row(
          children: [
            Text("解压密码："),
            Spacer(),
            ElevatedButton(onPressed: screenViewmodel.addPasswordItem, child: Text("新增密码项")),
            SizedBox(width: 10),
            ElevatedButton(onPressed: screenViewmodel.saveDecompressPasswordLocal, child: Text("保存密码")),
            SizedBox(width: 10),
            ElevatedButton(onPressed: screenViewmodel.getDecompressPasswordLocal, child: Text("从本地重新获取密码")),
          ],
        ),
        dynamicWidgets[1],
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dynamicWidgets[2],
            Text("是否解压后代文件夹中的压缩文件"),
            SizedBox(width: 10),

          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: screenViewmodel.decompress, child: Text("解压")),
        SizedBox(height: 20),
      ],
    );
  }
}
