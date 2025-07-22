import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableCreateTemplate extends ConsumerStatefulWidget {
  const TableCreateTemplate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableCreateTemplateState();
}

class _TableCreateTemplateState extends ConsumerState<TableCreateTemplate> {
  @override
  Widget build(BuildContext context) {
    return layout();
  }

  Widget layout() {
    return Container();
  }
}
