import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/models/movement_item.dart';
import 'package:warehouse_master_mobile/modules/movements/screens/details_screen.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';
class ListViewExample extends StatelessWidget {
  final List<MovementItem> movements;

  const ListViewExample({
    super.key,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movements.length,
      itemBuilder: (context, index) {
        final movement = movements[index];

        return GestureDetector(
          onTap: () {
            // Navegar a la pantalla de detalles pasando el objeto completo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedMovementScreen(movement: movement),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            elevation: 3,
            color: AppColors.softPinkBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título: Almacén de destino
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movement.destinationWarehouse.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.deepMaroon,
                        ),
                      ),
                      Text(
                        movement.uid,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.rosePrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Mostrar la cantidad total de productos en el movimiento
                  Row(
                    children: [
                      const Icon(Icons.inventory, size: 18, color: AppColors.deepRedAccent),
                      const SizedBox(width: 8),
                      Text(
                        'Cantidad Total: ${movement.totalQuantity}',  // Acceder al total de cantidad
                        style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // De y A
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.arrow_circle_left_outlined, size: 18, color: AppColors.rosePrimary),
                          const SizedBox(width: 8),
                          Text(
                            'De: ${movement.sourceWarehouse.name}',
                            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_circle_right_outlined, size: 18, color: AppColors.deepRedAccent),
                          const SizedBox(width: 8),
                          Text(
                            'A: ${movement.destinationWarehouse.name}',
                            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon,),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Estado y Última Modificación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: AppColors.deepMaroon),
                          const SizedBox(width: 8),
                          Text(
                            'Estado: ${movement.status}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.deepMaroon,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Última modificación
                  Text(
                    'Última modificación: ${movement.lastModified.toLocal()}',
                    style: const TextStyle(fontSize: 12, color: AppColors.lightGray),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

extension on String {
  toLocal() {}
}