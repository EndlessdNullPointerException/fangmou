import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionScheduleDetailScreen extends ConsumerWidget {
  final String id;
  const FunctionScheduleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: Text("待办详情页$id"));
  }
}
