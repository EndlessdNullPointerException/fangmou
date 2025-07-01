import 'package:flutter/material.dart';
import '../../../utils/constants/constants.dart';

class PasswordItemWidget extends StatefulWidget {
  final void Function(TextEditingController) deleteCallBack;
  final List<TextEditingController> passwordControllerList;
  const PasswordItemWidget({super.key, required this.deleteCallBack, required this.passwordControllerList});

  @override
  State<PasswordItemWidget> createState() => _PasswordItemWidgetState();
}

class _PasswordItemWidgetState extends State<PasswordItemWidget> {
  @override
  Widget build(BuildContext context) {
    logger.d("PasswordItemWidget = ${widget.passwordControllerList.length}");
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder:
          (ctx, i) => Row(
            children: [
              // 使用Expanded包裹TextField确保宽度约束
              Expanded(child: TextField(controller: widget.passwordControllerList[i])),
              const SizedBox(width: 10),
              IconButton(onPressed: () => widget.deleteCallBack(widget.passwordControllerList[i]), icon: const Icon(Icons.delete)),
            ],
          ),
      itemCount: widget.passwordControllerList.length,
    );
  }
}
