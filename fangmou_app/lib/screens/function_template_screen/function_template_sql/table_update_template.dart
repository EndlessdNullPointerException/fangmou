import 'package:fangmou_app/utils/extensions/go_router_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableUpdateTemplateScreen extends ConsumerStatefulWidget {
  final FangMouGoRoute route;
  const TableUpdateTemplateScreen({super.key, required this.route});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableUpdateTemplateScreenState();
}

class _TableUpdateTemplateScreenState extends ConsumerState<TableUpdateTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return layout();
  }

  Widget layout() {
    return Container();
  }
}
