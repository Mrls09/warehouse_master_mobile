import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_master_mobile/kernel/shared/snackbar_alert.dart';
import 'package:warehouse_master_mobile/kernel/utils/dio_client.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card_skeleton.dart';
import 'package:warehouse_master_mobile/models/movements/movement.dart';

class MovementScreen extends StatefulWidget {
  const MovementScreen({super.key});

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  List<Movement> movements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransfers();
  }


  // Método para realizar la solicitud HTTP a la API
  Future<void> _fetchTransfers() async {
    try {
      Dio dio = DioClient(baseUrl: 'https://az3dtour.online:8443').dio;
      final response = await dio
          .get('/warehouse-master-api/movements/');
        

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        //print(data);

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
      SnackbarAlert(context).show(
        message: 'Error al obtener los datos: $e',
      );
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
      body: Scrollbar(
        thumbVisibility: true,
        child: isLoading
            ? ListView.builder(
                itemCount: 5, // Número de skeletons visibles durante la carga
                itemBuilder: (context, index) {
                  return const MovementCardSkeleton();
                },
              )
            : ListView.builder(
                itemCount: movements.length,
                itemBuilder: (context, index) {
                  final movement = movements[index];
                  return MovementCard(movement: movement);
                },
              ),
      ),
    );
  }
}
