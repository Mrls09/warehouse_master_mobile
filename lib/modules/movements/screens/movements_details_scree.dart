import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_master_mobile/kernel/widgets/qr_screen.dart';
import 'package:warehouse_master_mobile/models/movements/movement.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class MovementDetailsScreen extends StatefulWidget {
  final Movement movement;

  const MovementDetailsScreen({super.key, required this.movement});

  @override
  State<MovementDetailsScreen> createState() => _MovementDetailsScreenState();
}

class _MovementDetailsScreenState extends State<MovementDetailsScreen> {
  int? selectedProductIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Movimient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información general del movimiento (usuario, estado, total de productos)
            _buildTransferGeneralInfo(),
            const SizedBox(height: 16),
            const Divider(color: AppColors.softPinkBackground, thickness: 2),
            const Text(
              'Productos:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepMaroon,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: widget.movement.products.length == 1
                  ? _buildProductDetails(
                      0)
                  : _buildProductList(),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrScannerScreen()),
          );
        },
        backgroundColor: AppColors.rosePrimary,
        foregroundColor:  AppColors.lightGray,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    
    );
  }

  // Información general del movimiento
  Widget _buildTransferGeneralInfo() {
    final transfer = widget.movement;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Estado: ${transfer.status}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.deepMaroon,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons
                  .check_circle,
              color:
                  transfer.status == 'Completado' ? Colors.green : Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Información del usuario que realizó el movimiento
        Row(
          children: [
            const Icon(Icons.person, size: 18, color: AppColors.deepRedAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Nombre: ${transfer.assignedUser.name}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.deepMaroon,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.add_shopping_cart,
                size: 18, color: AppColors.deepMaroon),
            const SizedBox(width: 8),
            Text(
              'Total productos: ${transfer.products.fold(0, (sum, productDetail) => sum + productDetail.quantity)}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.deepMaroon,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.comment, size: 18, color: AppColors.deepRedAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Observaciones: ${transfer.observations}',
                style:
                    const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.date_range, size: 18, color: AppColors.deepMaroon),
            const SizedBox(width: 8),
            Text(
              'Última modificación: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(transfer.lastModified))}',
              style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
            ),
          ],
        ),
      ],
    );
  }

  // Lista de productos
Widget _buildProductList() {
  return ListView.builder(
    itemCount: widget.movement.products.length,
    itemBuilder: (context, index) {
      final productDetail = widget.movement.products[index];
      final product = productDetail.product;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.deepMaroon,
              ),
            ),
            subtitle: Text(
              '${product.description} - ${productDetail.quantity} unidades',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.deepMaroon,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: AppColors.deepMaroon),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrScannerScreen(),
                      ),
                    );
                  },
                ),
                Icon(
                  selectedProductIndex == index
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: AppColors.deepMaroon,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                selectedProductIndex =
                    selectedProductIndex == index ? null : index;
              });
            },
          ),
          if (selectedProductIndex == index) _buildProductDetails(index),
          const Divider(color: AppColors.softPinkBackground, thickness: 1),
        ],
      );
    },
  );
}
  // Detalles del producto seleccionado
  Widget _buildProductDetails(int index) {
    final productDetail = widget.movement.products[index];
    final product = productDetail.product;
    final destinationRack = productDetail.destinationRack;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proveedor:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepMaroon,
            ),
          ),
          Text(
            'Nombre: ${product.supplier.name}',
            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
          ),
          Text(
            'Contacto: ${product.supplier.contact}',
            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
          ),
          const SizedBox(height: 8),
          const Text(
            'Categoría:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepMaroon,
            ),
          ),
          Text(
            'Nombre: ${product.category.name}',
            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
          ),
          Text(
            'Descripción: ${product.category.description}',
            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rack de Destino:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepMaroon,
            ),
          ),
          Text(
            'Rack UID: ${destinationRack?.uid}, Número: ${destinationRack?.rackNumber}',
            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
          ),
          Text(
            'Capacidad: ${destinationRack?.capacity}',
            style: const TextStyle(fontSize: 14, color: AppColors.deepMaroon),
          ),
        ],
      ),
    );
  }

  // Botón en la parte inferior
  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: () {
          print('Acción: Iniciar Entrada');
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
    );
  }
}
