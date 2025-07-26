import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';

class CopyableField extends StatelessWidget {
  const CopyableField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          maxLines: null, // 设置为 null 可以使得 TextField 高度等于文本高度
          readOnly: true,
          decoration: InputDecoration(
            fillColor: Color(0x110099ee),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () async {
              try {
                if (controller.text.isNotEmpty) {
                  await Clipboard.setData(ClipboardData(text: controller.text));
                  showCustomDialog("复制成功");
                }
              } catch (e) {
                logger.e(e.toString());
              }
            },
            style: ButtonStyle(
              // 1. 彻底移除涟漪效果
              splashFactory: NoSplash.splashFactory,
              // 2. 移除鼠标悬停、聚焦、点击时的背景色（遮罩层）
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            icon: Icon(Icons.copy),
          ),
        ),
      ],
    );
  }
}
