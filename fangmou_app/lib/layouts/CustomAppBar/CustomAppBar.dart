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
          CustomAppbarPopupMenuButton(
            icon: Icon(Icons.reorder),
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(children: const [Icon(Icons.settings, size: 20), SizedBox(width: 8), Text('设置')]),
                  ),
                  PopupMenuItem<String>(
                    value: 'help',
                    child: Row(children: const [Icon(Icons.help_outline, size: 20), SizedBox(width: 8), Text('帮助中心')]),
                  ),
                ],
            onSelected: (value) {
              switch (value) {
                case "settings":
                  context.go('/setting');
                case "help":
                  context.go('/home');
              }
            },
          ),
          CustomAppbarPopupMenuButton(
            icon: Icon(Icons.event_note),
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(children: const [Icon(Icons.view_list, size: 20), SizedBox(width: 8), Text('查看')]),
                  ),
                  PopupMenuItem<String>(value: 'help', child: Row(children: const [Icon(Icons.add_alert, size: 20), SizedBox(width: 8), Text('新建')])),
                ],
            onSelected: (value) {},
          ),
          CustomAppbarPopupMenuButton(
            icon: Icon(Icons.create),
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(children: const [Icon(Icons.view_agenda, size: 20), SizedBox(width: 8), Text('查看')]),
                  ),
                  PopupMenuItem<String>(
                    value: 'help',
                    child: Row(children: const [Icon(Icons.add_circle, size: 20), SizedBox(width: 8), Text('新建')]),
                  ),
                ],
            onSelected: (value) {},
          ),
          CustomAppbarPopupMenuButton(
            icon: Icon(Icons.design_services),
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(children: const [Icon(Icons.design_services_outlined, size: 20), SizedBox(width: 8), Text('模板一览')]),
                  ),
                  PopupMenuItem<String>(value: 'help', child: Row(children: const [Icon(Icons.add_box, size: 20), SizedBox(width: 8), Text('模板新增')])),
                ],
            onSelected: (value) {},
          ),
          CustomAppbarIconButton(icon: Icon(Icons.calculate), onPressed: () => {context.go('/function_calculator')}),
          CustomAppbarIconButton(icon: Icon(IconData(0xf53f, fontFamily: 'CustomIcon')), onPressed: () => {context.go('/function_spider')}),
          CustomAppbarIconButton(icon: Icon(Icons.folder), onPressed: () => {context.go('/function_directory')}),
          CustomAppbarIconButton(icon: Icon(Icons.unarchive), onPressed: () => {context.go('/function_decompress')}),
          CustomAppbarIconButton(
            onPressed: () => {logger.d("yes"), ref.read(isExpandedProvider.notifier).state = false},
            icon: Icon(Icons.expand_less),
          ),
          CustomAppbarPopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(children: const [Icon(Icons.settings, size: 20), SizedBox(width: 8), Text('设置')]),
                  ),
                  PopupMenuItem<String>(
                    value: 'help',
                    child: Row(children: const [Icon(Icons.help_outline, size: 20), SizedBox(width: 8), Text('帮助中心')]),
                  ),
                ],
            onSelected: (value) {
              switch (value) {
                case "settings":
                  context.go('/setting');
                case "help":
                  context.go('/home');
              }
            },
          ),
        ],
      ),
    );
  }
}
