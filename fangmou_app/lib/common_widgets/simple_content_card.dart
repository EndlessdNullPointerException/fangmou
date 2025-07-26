import 'package:flutter/material.dart';

class SimpleContentCard extends StatelessWidget {
  const SimpleContentCard({super.key, required this.content, this.hasSingleChildScrollView = false});

  final Widget content;
  final bool hasSingleChildScrollView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(5),
      child: Card(
        color: Colors.white,
        elevation: 10.0,
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 10, top: 10, bottom: 10, right: hasSingleChildScrollView ? 0 : 10),
          child: content,
        ),
      ),
    );
  }
}
