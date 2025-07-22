import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableUpdateTemplate extends ConsumerStatefulWidget {
  const TableUpdateTemplate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableUpdateTemplateState();
}

class _TableUpdateTemplateState extends ConsumerState<TableUpdateTemplate> {
  @override
  Widget build(BuildContext context) {

    return layout();
  }

  Widget layout() {
    return Container();
  }
}
