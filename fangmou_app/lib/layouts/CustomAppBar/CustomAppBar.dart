// 自定义应用栏
import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route_item.dart';
import 'CustomAppbarIconButton.dart';
import 'CustomAppbarPopupMenuButton.dart';
import 'CustomAppbarStyle.dart';

class CustomAppBar extends ConsumerWidget {
  final isExpandedProvider = StateProvider<bool>((ref) => true);

  final Widget body;

  final List<RouteItem> routeItemList;

  CustomAppBar({super.key, required this.body, required this.routeItemList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedProvider); // 监听状态变化
    return Stack(
      children: [
        // 主页面内容（添加顶部边距避免遮挡）
        Padding(
          padding: EdgeInsets.only(top: isExpanded ? CustomAppbarStyle.appbarHeight : CustomAppbarStyle.appbarPinHeight), // 动态调整边距
          child: Container(child: body),
        ),
        // 顶部边缘可展开面板
        Positioned(
          top: 0, // 定位到顶部
          left: 0,
          right: 0, // 横向铺满
          child: MouseRegion(
            onEnter: (_) => ref.read(isExpandedProvider.notifier).state = true,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded ? CustomAppbarStyle.appbarHeight : CustomAppbarStyle.appbarPinHeight, // 控制高度变化（原宽度改为高度）
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(CustomAppbarStyle.appbarPinHeight), // 底部圆角
                  bottomRight: Radius.circular(CustomAppbarStyle.appbarPinHeight),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3), // 阴影向下
                  ),
                ],
              ),
              child: _buildAppbarContent(context, ref),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppbarContent(BuildContext context, WidgetRef ref) {

    final isExpanded = ref.watch(isExpandedProvider); // 监听状态变化
    if (!isExpanded) return Container(); // 收起时仅显示线条
    return Container(
      height: CustomAppbarStyle.appbarHeight,
      color: Colors.black12,
      child: Row(
        children: [
          for (var item in routeItemList)
            if (item.subMenu.isEmpty)
              CustomAppbarIconButton(icon: item.icon, onPressed: () => {context.go(item.path)})
            else
              CustomAppbarPopupMenuButton(
                icon: item.icon,
                itemBuilder:
                    (context) => [
                      for(var subItem in item.subMenu)
                        PopupMenuItem<String>(
                          value: subItem.path,
                          child: Row(children:  [subItem.icon, SizedBox(width: 8), Text(subItem.name)]),
                        ),
                    ],
                onSelected: (value) {
                  context.go(value);
                },
              ),
        ],
      ),
    );
  }
}
