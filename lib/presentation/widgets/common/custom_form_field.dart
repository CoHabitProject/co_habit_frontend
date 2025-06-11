import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final bool readOnly;
  final Widget? suffixIcon;
  final int? maxLength;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.suffixIcon,
    this.maxLength = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, // Your label text here
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              suffixIcon: suffixIcon,
              counterText: ''),
          keyboardType: inputType,
          readOnly: readOnly,
          validator: validator,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
