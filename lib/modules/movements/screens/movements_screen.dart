import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/kernel/widgets/list_view.dart';
import 'package:warehouse_master_mobile/models/movement_item.dart';
import 'package:warehouse_master_mobile/models/product.dart';
import 'package:warehouse_master_mobile/models/warehouse.dart';
import 'package:warehouse_master_mobile/models/rack.dart';  // Asegúrate de importar el modelo Rack

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    // Movimientos simulados
    final List<MovementItem> exampleMovements = [
      MovementItem(
        uid: '12399999999',
        products: [
          Product(
            uid: 'prod123',
            name: 'Producto A',
            description: 'Descripción del Producto A',
            price: 100.0,
            quantity: 10,
            qrCode: 'QR123',
            expirationDate: '2025-01-01',
            active: true,
            lastModified: '2024-11-24T10:00:00',
          ),
        ],
        sourceWarehouse: Warehouse(
          uid: 'wh1',
          name: 'Almacén Central',
          location: 'Ciudad A',
          capacity: 1000,
          active: true,
          lastModified: '2024-11-24T10:00:00',
        ),
        sourceRack: Rack(  // Agregamos el rack de origen
          uid: 'rack123',
          warehouse: Warehouse(
            uid: 'wh1',
            name: 'Almacén Central',
            location: 'Ciudad A',
            capacity: 1000,
            active: true,
            lastModified: '2024-11-24T10:00:00',
          ),
          rackNumber: 'R1',
          capacity: 100,
          description: 'Rack principal',
          maxFloor: 5,
          active: true,
          lastModified: '2024-11-24T10:00:00',
        ),
        destinationWarehouse: Warehouse(
          uid: 'wh2',
          name: 'Sucursal Norte',
          location: 'Ciudad B',
          capacity: 500,
          active: true,
          lastModified: '2024-11-24T10:00:00',
        ),
        status: 'PENDIENTE',
        lastModified: '2024-11-24T10:00:00',
        photo: '',
        observations: 'Sin observaciones',
      ),
      MovementItem(
        uid: '1276756554',
        products: [
          Product(
            uid: 'prod001',
            name: 'iPhone 15 Pro',
            description: 'Smartphone de última generación con pantalla OLED, procesador A17 Pro, y cámaras avanzadas.',
            price: 999.0,
            quantity: 3,
            qrCode: 'QR001',
            expirationDate: '2025-01-01',
            active: true,
            lastModified: '2024-11-24T10:00:00',
          ),
          Product(
            uid: 'prod002',
            name: 'MacBook Air M2',
            description: 'Computadora portátil ultradelgada con chip M2, pantalla Retina de 13.3 pulgadas y batería de larga duración.',
            price: 1199.0,
            quantity: 4,
            qrCode: 'QR002',
            expirationDate: '2025-01-01',
            active: true,
            lastModified: '2024-11-24T10:00:00',
          ),
        ],
        sourceWarehouse: Warehouse(
          uid: 'wh3',
          name: 'Sucursal Sur',
          location: 'Ciudad C',
          capacity: 300,
          active: true,
          lastModified: '2024-11-24T10:00:00',
        ),
        sourceRack: Rack(
          uid: 'rack456',
          warehouse: Warehouse(
            uid: 'wh3',
            name: 'Sucursal Sur',
            location: 'Ciudad C',
            capacity: 300,
            active: true,
            lastModified: '2024-11-24T10:00:00',
          ),
          rackNumber: 'R2',
          capacity: 100,
          description: 'Rack Sur',
          maxFloor: 5,
          active: true,
          lastModified: '2024-11-24T10:00:00',
        ),
        destinationWarehouse: Warehouse(
          uid: 'wh1',
          name: 'Almacén Central',
          location: 'Ciudad A',
          capacity: 1000,
          active: true,
          lastModified: '2024-11-24T10:00:00',
        ),
        status: 'COMPLETADO',
        lastModified: '2024-11-23T10:00:00',
        photo: '',
        observations: 'Movimiento completado.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListViewExample(movements: exampleMovements),
          ),
        ],
      ),
    );
  }
}