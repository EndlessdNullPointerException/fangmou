import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:highlight/highlight.dart';

import '../../../common_widgets/gadget_widget.dart';
import '../../../utils/constants/constants.dart';

class CopyableFieldParams {
  final CodeController controller;
  final String name;
  bool expand = false;
  CopyableFieldParams({required this.name, required Mode language}) : controller = CodeController(language: language);
}

class CopyableField extends StatefulWidget {
  final CopyableFieldParams copyableFieldParams;

  const CopyableField({super.key, required this.copyableFieldParams});

  @override
  State<StatefulWidget> createState() => CopyableFieldState();
}

class CopyableFieldState extends State<CopyableField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.copyableFieldParams.expand = !widget.copyableFieldParams.expand;
                      });
                    },
                    icon: widget.copyableFieldParams.expand ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_drop_up),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.all(5),
                    child: Text(widget.copyableFieldParams.name, style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ],
              ),
              Visibility(
                visible: widget.copyableFieldParams.expand,
                child: CodeTheme(
                  data: CodeThemeData(styles: solarizedLightTheme),
                  child: CodeField(
                    controller: widget.copyableFieldParams.controller,
                    textStyle: const TextStyle(fontFamily: 'FiraCode'),
                    maxLines: null,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () async {
                try {
                  if (widget.copyableFieldParams.controller.text.isNotEmpty) {
                    await Clipboard.setData(ClipboardData(text: widget.copyableFieldParams.controller.text));
                    showCustomToast("复制成功");
                  } else {
                    showCustomToast("无可复制内容");
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
      ),
    );
  }
}
