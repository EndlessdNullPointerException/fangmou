import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DirectoryPathSelector extends StatefulWidget {
  final TextEditingController controller;

  const DirectoryPathSelector({super.key, required this.controller});

  @override
  State<DirectoryPathSelector> createState() => _DirectoryPathSelectorState();
}

class _DirectoryPathSelectorState extends State<DirectoryPathSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: "选择或输入路径",
                    border: InputBorder.none, // 隐藏TextField原生边框
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 4), // 微调按钮右间距
                child: IconButton(
                  icon: Icon(Icons.folder_open, size: 24),
                  padding: EdgeInsets.all(8), // 紧凑点击区域
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    // 通过文件选择器获取
                    String? directoryPath = await FilePicker.platform.getDirectoryPath();
                    logger.d('搜索内容: $directoryPath');
                    widget.controller.text = directoryPath!;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
