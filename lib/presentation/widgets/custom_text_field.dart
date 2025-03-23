import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      readOnly: widget.readOnly,
      obscureText: widget.isPassword == true ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: widget.label,
        border: const OutlineInputBorder(),
        filled: true,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
                : null,
      ),
      validator: widget.validator,
    );
  }
}
