import 'package:fangmou_app/routes/app_router.dart';
import 'package:flutter/material.dart';

Widget fangmouStandardTextField({
  required int flex,
  required TextEditingController controller,
  String? hintText,
  String? labelText,
}) {
  return Flexible(
    flex: flex,
    child: FractionallySizedBox(
      widthFactor: 1.0, // 占满 Flexible 分配的空间
      child: Theme(
        data: Theme.of(AppRouter.context!).copyWith(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent, // 获得焦点后的高亮
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
            ),
            fillColor: Colors.transparent,
            isDense: true,
            hintText: hintText,
            labelText: labelText,
          ),
        ),
      ),
    ),
  );
}

Widget fangmouStandardTextFormField({
  required int flex,
  required TextEditingController controller,
  String? hintText,
  String? labelText,
  String helperText=" ",
  required FormFieldValidator validator,
}) {
  return Flexible(
    flex: flex,
    child: FractionallySizedBox(
      widthFactor: 1.0, // 占满 Flexible 分配的空间
      child: Theme(
        data: Theme.of(AppRouter.context!).copyWith(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent, // 获得焦点后的高亮
        ),
        child: TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            fillColor: Colors.transparent,
            isDense: true,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
          ),
        ),
      ),
    ),
  );
}
