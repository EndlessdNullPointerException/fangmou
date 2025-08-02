import 'package:fangmou_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget fangmouStandardTextField({
  required int flex,
  required TextEditingController controller,
  String? hintText,
  String? labelText,
  IconButton? suffixIcon,
  List<TextInputFormatter>? inputFormatters,
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
          inputFormatters: inputFormatters,
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
            suffixIcon: suffixIcon,
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
  String helperText = " ",
  List<TextInputFormatter>? inputFormatters,
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
          inputFormatters: inputFormatters,
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

Widget fangmouStandardDropdownMenu<T>({
  required List<DropdownMenuEntry<T>> dropdownMenuEntries,
  ValueChanged<T?>? onSelected,
  T? initialSelection
}) {
  return DropdownMenu<T>(dropdownMenuEntries: dropdownMenuEntries, onSelected: onSelected,initialSelection: initialSelection,);
}
