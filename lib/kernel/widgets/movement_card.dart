import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/models/movements/movement.dart';
import 'package:warehouse_master_mobile/modules/movements/screens/movements_details_scree.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';
import 'package:intl/intl.dart';

class MovementCard extends StatelessWidget {
  final Movement movement;

  const MovementCard({super.key, required this.movement});

  @override
  Widget build(BuildContext context) {
    // Descripciones de los estados de los movimientos
    String getStatusDescription(String status) {
      return statusDescriptions[status] ?? 'Estado desconocido';
    }

    // Calcular el total de productos
    final totalProducts = movement.products.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );
    // Identificar almacenes de origen y destino
    final sourceWarehouse = movement.products.isNotEmpty
        ? movement.products.first.product.rack.warehouse.name
        : 'Desconocido';
    final destinationWarehouse = movement.products.isNotEmpty
        ? movement.products.first.destinationRack?.warehouse.name
        : 'Desconocido';

    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovementDetailsScreen(movement: movement),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 4,
        color: AppColors.softPinkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UID y cantidad total de productos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UID: ${movement.uid}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: AppColors.deepMaroon,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: $totalProducts productos',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.lightGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Almacenes: De y A
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_circle_left_outlined,
                          size: 18, color: AppColors.rosePrimary),
                      const SizedBox(width: 8),
                      Text(
                        'De: $sourceWarehouse',
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.deepMaroon,
                            fontWeight: FontWeight.bold
                            ),
                          
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.arrow_circle_right_outlined,
                          size: 18, color: AppColors.deepRedAccent),
                      const SizedBox(width: 8),
                      Text(
                        'A: $destinationWarehouse',
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.deepMaroon),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Estado
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 18, color: AppColors.deepMaroon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Estado: ${getStatusDescription(movement.status)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.deepMaroon,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Observaciones (si existen)
              Row(
                children: [
                  const Icon(Icons.notes,
                      size: 18, color: AppColors.deepMaroon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      movement.observations?.isNotEmpty ?? false
                          ? 'Observaciones: ${movement.observations}'
                          : 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.deepMaroon,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.date_range,
                      size: 18, color: AppColors.deepMaroon),
                  const SizedBox(width: 8),
                  Text(
                    'Última modificación: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(movement.lastModified))}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.lightGray),
                  ),
                ],
              )
              // Última modificación
            ],
          ),
        ),
      ),
    );
  }
}
