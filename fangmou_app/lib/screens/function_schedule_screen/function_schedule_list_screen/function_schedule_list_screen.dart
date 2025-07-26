import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants/constants.dart';

class FunctionScheduleListScreen extends ConsumerWidget {
  const FunctionScheduleListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Divider(height: 1),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 20,
          itemBuilder:
              (ctx, i) => GestureDetector(
                onTap: () {
                  // 点击事件处理逻辑
                  logger.d('第 $i Row 被点击了!');
                  context.go('/function_schedule_detail/$i');
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Checkbox(value: true, onChanged: null),
                      Flexible(
                        flex: 98,
                        child: FractionallySizedBox(
                          widthFactor: 1.0, // 占满 Flexible 分配的空间
                          child: Text(
                            returnTextData(i),
                            overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                      Text("待办"),
                      Spacer(flex: 1),
                      Text("${DateTime.now()}"),
                    ],
                  ),
                ),
              ),
          separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
        ),
        Divider(indent: 0, height: 1),
      ],
    );
  }

  String returnTextData(int i) {
    if (i % 2 == 0) {
      return "这是一个非常长的文本，需要被限制在60%宽度内并在超出时显示省略号"
          "---------------------------------------------------"
          "2222222222222222222222222222222222222222112q31234e311111111111111111111111"
          "这是一个非常长的文本，需要被限制在60%宽度内并在超出时显示省略号"
          "---------------------------------------------------"
          "2222222222222222222222222222222222222222112q31234e311111111111111111111111"; // 单行显示
    } else {
      return "这是一个非常长的文本，需要被限制在60%宽度内并在超出时显示省略号";
    }
  }
}
