import 'package:flutter/material.dart';

class TextFormFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String hintText;
  final bool isPassword;
  final int maxLine;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;

  const TextFormFieldInput({
    Key? key,
    required this.textEditingController,
    required this.textInputType,
    required this.hintText,
    this.isPassword = false,
    this.maxLine = 1,
    this.validator,
    this.onChanged,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(18.0),
    );

    return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPassword,
      maxLines: maxLine,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        fillColor: Colors.white12,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        hintText: hintText,
        border: textFieldBorder,
        focusedBorder: textFieldBorder,
        enabledBorder: textFieldBorder,
        filled: true,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
