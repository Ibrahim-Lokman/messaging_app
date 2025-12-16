import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }
}
