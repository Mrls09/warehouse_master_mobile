import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_master_mobile/kernel/shared/custom_dialog_alert.dart';
import 'package:warehouse_master_mobile/kernel/shared/snackbar_alert.dart';
import 'package:warehouse_master_mobile/kernel/widgets/camera_component.dart';
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
  String? _base64Image;
  bool isLoading = false;

  String getStatusDescription(String status) {
    return statusDescriptions[status] ?? 'Estado desconocido';
  }

  Map<String, bool> createProductMap(List<dynamic> products) {
    return {
      for (var product in products) product.product.uid: false,
    };
  }

  late Map<String, bool> items;

  @override
  void initState() {
    super.initState();
    items = createProductMap(widget.movement.products);
    print(widget.movement.products[0].product.uid);
  }

  Future<void> _updateTransferStatus() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://az3dtour.online:8443',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      ),
    );

    // Validación: asegurarse de que todos los productos hayan sido escaneados
    if (!items.values.every((value) => value == true)) {
      CustomDialogAlert(context).show(
        title: 'Acción requerida',
        content: const Text(
            'Todos los productos deben ser escaneados antes de continuar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Validación: asegurarse de que la imagen está seleccionada
    if (_base64Image == null || _base64Image!.isEmpty) {
      CustomDialogAlert(context).show(
        title: 'Imagen requerida',
        content: const Text('Por favor, seleccione una imagen antes de continuar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final Map<String, dynamic> body = {
        "uid": widget.movement.uid,
        "photo": "data:image/png;base64,$_base64Image",
      };
      final Response response = await dio.put(
        '/warehouse-master-api/movements/pending/',
        data: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        SnackbarAlert(context).show(
          message: 'Movimiento actualizado exitosamente',
          backgroundColor: Colors.green,
        );
      } else {
        SnackbarAlert(context).show(
          message: 'Error en la solicitud',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (e is DioException) {
        SnackbarAlert(context).show(message: 'Dio Error Response: ${e.response?.data}');
      }
      SnackbarAlert(context).show(
        message: 'Error en la solicitud',
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToChild() async {
    final updatedItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          items: items,
          onQRScanned: (String) {},
        ),
      ),
    );

    print(updatedItems.toString());

    if (updatedItems != null && updatedItems is Map<String, bool>) {
      setState(() {
        items = {...updatedItems};
      });
    } else {
      setState(() {
        items = {...items};
      });
    }
  }

  int? selectedProductIndex;

  @override
  Widget build(BuildContext context) {
    final transfer = widget.movement;
    final isPendingEntry = transfer.status == 'PENDING_ENTRY';
    final isEntry = transfer.status == 'ENTRY';
    final isDeparture = transfer.status == 'EXIT';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Movimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: _buildProductList(items),
            ),
            if (isPendingEntry)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Este movimiento está en proceso de ingreso al almacén.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isEntry)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Este movimiento ya ha sido ingresado y colocado en el almacén.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isDeparture)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Este movimiento ya ha sido retirado del almacén.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ),
            
            
          ],
        ),
      ),
      bottomNavigationBar: !isPendingEntry && !isEntry && !isDeparture
          ? _buildBottomButton(items)
          : null,
      floatingActionButton:
          !isPendingEntry && !isEntry && !isDeparture
              ? FloatingActionButton(
                  onPressed: () async {
                    final base64Image = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImagePickerComponent(),
                      ),
                    );

                    if (base64Image != null) {
                      setState(() {
                        _base64Image = base64Image;
                        print('Imagen desde details screen: $_base64Image');
                      });
                    }
                  },
                  backgroundColor: AppColors.rosePrimary,
                  foregroundColor: AppColors.lightGray,
                  child: const Icon(Icons.camera_alt),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

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
                'Estado: ${getStatusDescription(transfer.status)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.deepMaroon,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.check_circle,
              color:
                  transfer.status == 'Completado' ? Colors.green : Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 8),
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
                'Observaciones: ${transfer.observations ?? 'Ninguna'}',
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

  Widget _buildProductList(Map<String, bool> items) {
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: items[product.uid] == true
                      ? AppColors.deepMaroon
                      : const Color.fromARGB(255, 152, 131, 138),
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
                    icon: const Icon(Icons.qr_code_scanner,
                        color: AppColors.deepMaroon),
                    onPressed: _navigateToChild,
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

  Widget _buildBottomButton(Map<String, bool> items) {
    final allTrue = items.values.every((value) => value == true);
    final isPendingEntry = widget.movement.status == 'PENDING_ENTRY';

    String buttonText = widget.movement.status == 'ASSIGNED_ENTRY'
        ? 'Iniciar Entrada'
        : 'Iniciar Salida';

    if (isPendingEntry) {
      return const SizedBox.shrink(); // No se muestra el botón
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: isLoading || !allTrue
            ? null  // Deshabilitar el botón mientras está cargando
            : _updateTransferStatus, // Ejecutar la petición si no está cargando
        style: ElevatedButton.styleFrom(
          backgroundColor: allTrue ? AppColors.rosePrimary : Colors.grey,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ) // Mostrar el loader cuando está cargando
            : Text(
                buttonText,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }
}
