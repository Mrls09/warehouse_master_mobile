import 'package:flutter/material.dart';

class GenericListItem extends StatelessWidget {
  const GenericListItem({
    super.key,
    required this.data,
    this.onTap,
  });

  final Map<String, dynamic> data; // Datos de entrada
  final VoidCallback? onTap; // Acción al hacer clic en el ítem, opcional

  @override
  Widget build(BuildContext context) {
    // Extraer valores si están presentes
    final String? imageUrl = data['imageUrl'] as String?;
    final String? title = data['title'] as String?;
    final String? description = data['description'] as String?;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              width: 70,
              height: 70,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            )
          else
            const Icon(Icons.image_not_supported),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (description != null)
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
        
      ),
    );
  }
}
