import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../routes/app_router.dart';

class DirectoryPathSelector extends StatefulWidget {
  final TextEditingController controller;

  const DirectoryPathSelector({super.key, required this.controller});

  @override
  State<DirectoryPathSelector> createState() => _DirectoryPathSelectorState();
}

class _DirectoryPathSelectorState extends State<DirectoryPathSelector> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: "选择或输入路径",
        fillColor: Colors.transparent,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.folder_open, size: 24),
          constraints: BoxConstraints(),
          onPressed: () async {
            // 选择路径时，添加遮罩层
            showDialog(context: context, barrierDismissible: false, builder: (ctx) => Container());
            // 通过文件选择器获取
            String? directoryPath = await FilePicker.platform.getDirectoryPath();
            widget.controller.text = directoryPath ?? "";
            Navigator.pop(AppRouter.context!);
          },
        ),
      ),
    );
  }
}
