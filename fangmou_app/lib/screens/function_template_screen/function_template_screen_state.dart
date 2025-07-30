import 'package:fangmou_app/screens/function_template_screen/model/function_template_screen_item.dart';
import 'package:flutter/material.dart';

class FunctionTemplateScreenState {
  final List<FunctionTemplateScreenItem> items;
  final TextEditingController search;

  FunctionTemplateScreenState({required this.search, required this.items});

  FunctionTemplateScreenState.initiate(this.items) : search = TextEditingController();

  FunctionTemplateScreenState copyWith({TextEditingController? search, List<FunctionTemplateScreenItem>? items}) {
    return FunctionTemplateScreenState(search: search ?? this.search, items: items ?? this.items);
  }
}
