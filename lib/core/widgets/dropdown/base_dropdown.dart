import 'package:flutter/material.dart';

class BaseDropdown<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final String hintText;
  final Icon prefixIcon;
  final Widget? suffix;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Color? dropdownColor;

  const BaseDropdown({
    super.key,
    required this.value,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffix,
    required this.items,
    required this.onChanged,
    this.validator,
    this.dropdownColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        suffix: suffix,
      ),
      dropdownColor: dropdownColor,
      validator: validator,
      items: items,
      onChanged: onChanged,
    );
  }
}
