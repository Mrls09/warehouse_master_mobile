import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class TextFieldEmail extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;

  const TextFieldEmail({
    super.key,
    required this.controller,
    this.hintText = 'Correo electrónico',
    this.labelText = 'Correo electrónico',
  });

  @override
  // ignore: library_private_types_in_public_api
  _TextFieldEmailState createState() => _TextFieldEmailState();
}

class _TextFieldEmailState extends State<TextFieldEmail> {

  final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // Validación para el campo de correo electrónico
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Introduce un correo válido';
    }
    return null; // Correo válido
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: AppColors.rosePrimary),
        hintStyle: const TextStyle(color: AppColors.lightGray),
        errorStyle: const TextStyle(color: AppColors.errorColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.deepMaroon),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.rosePrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.rosePrimary),
        ),
      ),
      style: const TextStyle(color: AppColors.deepMaroon),
      onChanged: (value) {
        setState(() {
        });
      },
    );
  }
}