import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class SnackbarAlert {
  final BuildContext context;

  SnackbarAlert(this.context);

  void show({
    required String message,
    Color backgroundColor =AppColors.softPinkBackground,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }
}