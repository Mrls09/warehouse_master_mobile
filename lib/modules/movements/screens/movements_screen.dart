import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_master_mobile/kernel/shared/snackbar_alert.dart';
import 'package:warehouse_master_mobile/kernel/utils/dio_client.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card_skeleton.dart';
import 'package:warehouse_master_mobile/models/movements/movement.dart';

const Map<String, String> statusDescriptions = {
  'PENDING': 'Pendiente',
  'IN_PROGRESS': 'En Progreso',
  'COMPLETED': 'Completado',
  'CANCELLED': 'Cancelado'
};

class MovementScreen extends StatefulWidget {
  const MovementScreen({super.key});

  @override
  State<MovementScreen> createState() => _MovementScreenState();
}

class _MovementScreenState extends State<MovementScreen> {
  List<Movement> allMovements = [];
  List<Movement> filteredMovements = [];
  bool isLoading = true;
  bool isRefreshing = false;
  
  String currentFilter = 'All';
  DateTime? selectedDate;
  String? selectedStatus;

  int currentPage = 1;
  int itemsPerPage = 5;
  final List<int> itemsPerPageOptions = [5, 10, 15, 20, 25];

  @override
  void initState() {
    super.initState();
    _fetchTransfers();
  }

  Future<void> _fetchTransfers({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        setState(() {
          isRefreshing = true;
        });
      }

      Dio dio = DioClient(baseUrl: 'https://az3dtour.online:8443').dio;
      final response = await dio.get('/warehouse-master-api/movements/');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        setState(() {
          allMovements = data.map((item) => Movement.fromJson(item)).toList();
          filteredMovements = List.from(allMovements);
          isLoading = false;
          isRefreshing = false;
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        setState(() {
          isLoading = false;
          isRefreshing = false;
        });
      }
    } catch (e) {
      SnackbarAlert(context).show(
        message: 'Error al obtener los datos: $e',
      );
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      currentFilter = filter;
      currentPage = 1;
      
      switch (filter) {
        case 'All':
          filteredMovements = List.from(allMovements);
          break;
        case 'LastHour':
          final now = DateTime.now();
          filteredMovements = allMovements.where((movement) {
            final lastModified = DateTime.parse(movement.lastModified);
            return now.difference(lastModified).inHours < 1;
          }).toList();
          break;
        case 'Date':
          _showDatePicker();
          break;
        case 'Status':
          _showStatusFilterDialog();
          break;
      }
    });
  }

  List<Movement> get paginatedMovements {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredMovements.length > endIndex
        ? filteredMovements.sublist(startIndex, endIndex)
        : filteredMovements.sublist(startIndex);
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        currentPage = 1;
        filteredMovements = allMovements.where((movement) {
          final lastModified = DateTime.parse(movement.lastModified);
          return lastModified.year == picked.year &&
              lastModified.month == picked.month &&
              lastModified.day == picked.day;
        }).toList();
      });
    }
  }

  void _showStatusFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Estado'),
          content: SingleChildScrollView(
            child: Column(
              children: statusDescriptions.keys.map((status) {
                return ListTile(
                  title: Text(statusDescriptions[status] ?? status),
                  onTap: () {
                    setState(() {
                      selectedStatus = status;
                      currentPage = 1;
                      filteredMovements = allMovements.where((movement) {
                        return movement.status == status;
                      }).toList();
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showItemsPerPageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elementos por Página'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: itemsPerPageOptions.map((option) {
              return ListTile(
                title: Text('$option elementos'),
                onTap: () {
                  setState(() {
                    itemsPerPage = option;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (filteredMovements.length / itemsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showItemsPerPageDialog(),
            tooltip: 'Elementos por página',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('LastHour'),
                    _buildFilterChip('Date'),
                    _buildFilterChip('Status'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$itemsPerPage elementos por página'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () => setState(() => currentPage--)
                              : null,
                        ),
                        Text('$currentPage de $totalPages'),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < totalPages
                              ? () => setState(() => currentPage++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchTransfers(isRefresh: true);
        },
        child: Column(
          children: [
            if (currentFilter == 'Date' && selectedDate != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (currentFilter == 'Status' && selectedStatus != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Estado: ${statusDescriptions[selectedStatus] ?? selectedStatus}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: isLoading
                    ? ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const MovementCardSkeleton();
                        },
                      )
                    : filteredMovements.isEmpty
                        ? const Center(
                            child: Text('No hay movimientos para mostrar'),
                          )
                        : ListView.builder(
                            itemCount: paginatedMovements.length,
                            itemBuilder: (context, index) {
                              final movement = paginatedMovements[index];
                              return MovementCard(movement: movement);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(
          label == 'All' ? 'Todos' : 
          label == 'LastHour' ? 'Última Hora' : 
          label == 'Date' ? 'Fecha' : 
          'Estado',
        ),
        selected: currentFilter == label,
        onSelected: (_) => _applyFilter(label),
        selectedColor: Colors.blue[100],
      ),
    );
  }
}