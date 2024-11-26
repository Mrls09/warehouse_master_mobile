import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/models/movement_item.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class DetailedMovementScreen extends StatelessWidget {
  final MovementItem movement;

  const DetailedMovementScreen({super.key, required this.movement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Movimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información general del movimiento
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Para: ${movement.destinationWarehouse.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.deepMaroon,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  movement.status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.rosePrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Observaciones del movimiento
            Row(
              children: [
                const Icon(Icons.comment, size: 18, color: AppColors.deepRedAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Observaciones: ${movement.observations}',
                    style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Última modificación
            Row(
              children: [
                const Icon(Icons.date_range, size: 18, color: AppColors.deepMaroon),
                const SizedBox(width: 8),
                Text(
                  'Última modificación: ${movement.lastModified}',
                  style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Detalles de los productos
            const Divider(color: AppColors.softPinkBackground, thickness: 2),
            const SizedBox(height: 8),
            const Text(
              'Detalles de los productos:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepMaroon,
              ),
            ),
            const SizedBox(height: 8),

            // Lista de productos con scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var product in movement.products) ...[
                      ListTile(
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepMaroon),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          product.description,
                          style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          'Cantidad: ${product.quantity}',
                          style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                        ),
                      ),
                      const Divider(color: AppColors.softPinkBackground, thickness: 1),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Información sobre el almacén de origen
            Row(
              children: [
                const Icon(Icons.arrow_circle_left_outlined, size: 18, color: AppColors.rosePrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Almacén de origen: ${movement.sourceWarehouse.name} - ${movement.sourceWarehouse.location}',
                    style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Información sobre el rack de origen
            if (movement.sourceRack != null) ...[
              const Divider(color: AppColors.softPinkBackground, thickness: 2),
              const SizedBox(height: 8),
              const Text(
                'Rack de origen:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepMaroon,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.archive_outlined, size: 18, color: AppColors.deepRedAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Número de Rack: ${movement.sourceRack.rackNumber}, Capacidad: ${movement.sourceRack!.capacity}',
                      style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.description, size: 18, color: AppColors.deepRedAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Descripción: ${movement.sourceRack.description}',
                      style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: AppColors.deepRedAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nivel máximo: ${movement.sourceRack.maxFloor}',
                      style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),

            // Información sobre el almacén de destino
            Row(
              children: [
                const Icon(Icons.arrow_circle_right_outlined, size: 18, color: AppColors.rosePrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Almacén de destino: ${movement.destinationWarehouse.name} - ${movement.destinationWarehouse.location}',
                    style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ElevatedButton(
          onPressed: () {
            print('Iniciar entrada');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepMaroon,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: const Text(
            'Iniciar Entrada',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}