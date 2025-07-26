import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constants/constants.dart';

class DraggableFabScreen extends ConsumerStatefulWidget {
  const DraggableFabScreen({super.key});

  @override
  ConsumerState<DraggableFabScreen> createState() => _DraggableFabScreenState();
}

class _DraggableFabScreenState extends ConsumerState<DraggableFabScreen> {
  // 定义悬浮按钮的位置状态
  // 你可以设置一个更合理的初始位置，例如屏幕右下角
  late double _top;
  late double _left;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 延迟初始化位置，以确保可以获取到屏幕尺寸
    if (!_isInitialized) {
      final size = MediaQuery.of(context).size;
      // 初始位置设置在右下角，并留出一些边距
      _top = size.height - 100;
      _left = size.width - 100;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 这里可以放置你的主要内容
        const Center(child: Text('在屏幕上任意拖动右下角的按钮', style: TextStyle(fontSize: 18))),
        // 使用 Positioned 来定位可拖动的按钮
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            // 当拖动更新时
            onPanUpdate: (details) {
              // details.delta 包含了从上次更新到本次更新的拖动距离 (dx, dy)
              // 我们通过更新 _top 和 _left 的值来改变按钮的位置
              setState(() {
                _top += details.delta.dy;
                _left += details.delta.dx;
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                // 按钮的点击事件
                logger.d('FAB Tapped!');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('按钮被点击了！')));
              },
              child: const Icon(Icons.drag_handle),
            ),
          ),
        ),
      ],
    );
  }
}
