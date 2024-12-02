import 'package:flutter/material.dart';

class DialogAlert {
  final BuildContext context;

  DialogAlert(this.context);

  Future<void> showDialogBox({
    required String title,
    required String content,
    String confirmText = "OK",
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  // Si no se proporciona una acción de cancelar, imprimir un mensaje predeterminado
                  if (onCancel != null) {
                    onCancel();
                  } else {
                    print("Se canceló la acción.");
                  }
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: () {
                if (onConfirm != null) onConfirm();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}