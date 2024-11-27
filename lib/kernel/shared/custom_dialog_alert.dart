import 'package:flutter/material.dart';

class CustomDialogAlert {
  final BuildContext context;

  CustomDialogAlert(this.context);

  Future<void> show({
    required Widget content,
    String? title,
    List<Widget>? actions,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: content,
          actions: actions,
        );
      },
    );
  }
}