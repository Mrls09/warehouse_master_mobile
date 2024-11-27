import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card.dart';
import 'package:warehouse_master_mobile/models/movements/movement.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  List<Movement> movements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransfers();  // Llamada a la API
  }

  // Método para realizar la solicitud HTTP a la API
  Future<void> _fetchTransfers() async {
    try {
      Dio dio = Dio();
      final response = await dio.get('http://localhost:8080/warehouse-master-api/movements/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          movements = data.map((item) => Movement.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al obtener los datos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movements.length,
              itemBuilder: (context, index) {
                final movement = movements[index];
                return MovementCard(movement: movement);
              },
            ),
    );
  }
}
