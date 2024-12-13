import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_master_mobile/kernel/shared/snackbar_alert.dart';
import 'package:warehouse_master_mobile/kernel/utils/dio_client.dart';
import 'package:warehouse_master_mobile/kernel/widgets/filter_chips.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card.dart';
import 'package:warehouse_master_mobile/kernel/widgets/movement_card_skeleton.dart';
import 'package:warehouse_master_mobile/kernel/widgets/paginated_list.dart';
import 'package:warehouse_master_mobile/models/movements/movement.dart';

class OutputScreen extends StatefulWidget {
  const OutputScreen({super.key});

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  // Listas de movimientos
  List<Movement> allMovements = [];
  List<Movement> filteredMovements = [];

  // Estado de carga
  bool isLoading = true;
  bool isLoadingMore = false;  // Indicador para más carga al hacer scroll

  // Filtros
  String currentFilter = FilterType.all.name;
  DateTime? selectedDate;
  String? selectedStatus;

  // Paginación
  int currentPage = 1;
  int itemsPerPage = 5;
  final List<int> itemsPerPageOptions = [5, 10, 15, 20, 25];

  // Filtros definidos
  late final List<GenericFilter<Movement>> _filters;

  // Controlador de scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Inicializar filtros
    _filters = [
      GenericFilter(label: 'Todos', type: FilterType.all),
      GenericFilter(label: 'Última Hora', type: FilterType.lastHour),
      GenericFilter(label: 'Fecha', type: FilterType.date),
      GenericFilter(label: 'Estado', type: FilterType.status),
    ];

    _fetchMovements();

    // Detectar cuando el usuario llega al final de la lista para cargar más datos
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreMovements();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Método para obtener movimientos de salida
  Future<void> _fetchMovements() async {
    try {
      Dio dio = DioClient(baseUrl: 'https://az3dtour.online:8443').dio;
      final response = await dio.get('/warehouse-master-api/movements/');
        
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        // Filtrar solo movimientos de salida
        final List<Movement> outputMovements = data
            .map((item) => Movement.fromJson(item))
            .where((movement) => movement.status.contains('EXIT'))
            .toList();

        setState(() {
          allMovements = outputMovements;
          filteredMovements = List.from(allMovements);
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

  // Método para cargar más movimientos al hacer scroll
  Future<void> _loadMoreMovements() async {
    if (isLoadingMore || isLoading) return;  // Si ya estamos cargando, no hacer nada

    setState(() {
      isLoadingMore = true;  // Mostrar el loader de más datos
    });

    // Lógica para cargar más movimientos
    await Future.delayed(const Duration(seconds: 2));  // Simular la carga de más datos

    final newMovements = allMovements.sublist(
      currentPage * itemsPerPage, 
      (currentPage + 1) * itemsPerPage,
    );
    
    setState(() {
      filteredMovements.addAll(newMovements);  // Agregar nuevos datos
      isLoadingMore = false;  // Detener el loader
      currentPage++;  // Incrementar la página
    });
  }

  // Método para aplicar los filtros
  void _applyFilter(String filterType) {
    setState(() {
      currentFilter = filterType;
      currentPage = 1; // Reiniciar la página

      switch (filterType) {
        case 'all':
          filteredMovements = List.from(allMovements);
          break;
        case 'lastHour':
          final now = DateTime.now();
          filteredMovements = allMovements.where((movement) {
            final lastModified = DateTime.parse(movement.lastModified);
            return now.difference(lastModified).inHours < 1;
          }).toList();
          break;
        case 'date':
          _showDatePicker();
          break;
        case 'status':
          _showStatusFilterDialog();
          break;
      }
    });
  }

  // Mostrar selector de fecha
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
        currentPage = 1; // Reiniciar la página
        filteredMovements = allMovements.where((movement) {
          final lastModified = DateTime.parse(movement.lastModified);
          return lastModified.year == picked.year &&
              lastModified.month == picked.month &&
              lastModified.day == picked.day;
        }).toList();
      });
    }
  }

  // Mostrar diálogo de filtro por estado
  void _showStatusFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Estado'),
          content: SingleChildScrollView(
            child: Column(
              children: statusDescriptions.keys
                  .where((status) => status.contains('EXIT'))
                  .map((status) {
                return ListTile(
                  title: Text(statusDescriptions[status] ?? status),
                  onTap: () {
                    setState(() {
                      selectedStatus = status;
                      currentPage = 1; // Reiniciar la página
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

  @override
  Widget build(BuildContext context) {
    final totalPages = (filteredMovements.length / itemsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos de Salida'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Barra de filtros
              FilterChipBar<Movement>(
                filters: _filters,
                currentFilter: currentFilter,
                onFilterChanged: _applyFilter,
                selectedDate: selectedDate,
                selectedStatus: selectedStatus,
                statusDescriptions: statusDescriptions,
              ),
              // Control de paginación
              PaginationControl(
                currentPage: currentPage,
                totalPages: totalPages,
                itemsPerPage: itemsPerPage,
                itemsPerPageOptions: itemsPerPageOptions,
                onPageChanged: (page) => setState(() => currentPage = page),
                onItemsPerPageChanged: (items) => setState(() {
                  itemsPerPage = items;
                  currentPage = 1;
                }),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        
        onRefresh: _fetchMovements,
        
        child: isLoading
            ? ListView.builder(
                controller: _scrollController,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const MovementCardSkeleton();
                },
              )
            : PaginatedList<Movement>(
                items: filteredMovements,
                currentPage: currentPage,
                itemsPerPage: itemsPerPage,
                isLoading: isLoading,
                itemBuilder: (movement) => MovementCard(movement: movement),
                emptyWidget: const Center(
                  child: Text('No hay movimientos de salida disponibles'),
                ),
              ),
      ),
    );
  }
}