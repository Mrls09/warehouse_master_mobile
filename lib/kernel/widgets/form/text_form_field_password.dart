import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class TextFieldPassword extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;

  const TextFieldPassword({
    super.key,
    required this.controller,
    this.hintText = 'Contraseña',
    this.labelText = 'Contraseña',
  });

  @override
  _TextFieldPasswordState createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool _isObscure = true;

  // Función de validación para el campo de contraseña
  String? _validatePassword(String? value) {
    /*
     if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 5) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'La contraseña debe tener al menos una letra mayúscula';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'La contraseña debe tener al menos un número';
    }
    return null; // Contraseña válida
    */
   
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      validator: _validatePassword, //Función de validación
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: AppColors.rosePrimary),
        hintStyle: const TextStyle(color: AppColors.lightGray),
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
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: AppColors.deepRedAccent,
          ),
        ),
      ),
      style: const TextStyle(color: AppColors.deepMaroon),
    );
  }
}
