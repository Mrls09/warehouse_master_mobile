import 'package:flutter/material.dart';

class PaginatedList<T> extends StatelessWidget {
  final List<T> items;
  final int currentPage;
  final int itemsPerPage;
  final Widget Function(T item) itemBuilder;
  final bool isLoading;
  final Widget? emptyWidget;

  const PaginatedList({
    Key? key,
    required this.items,
    required this.currentPage,
    required this.itemsPerPage,
    required this.itemBuilder,
    this.isLoading = false,
    this.emptyWidget,
  }) : super(key: key);

  // Obtener elementos paginados
  List<T> get paginatedItems {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return items.length > endIndex
        ? items.sublist(startIndex, endIndex)
        : items.sublist(startIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Condición de carga
    if (isLoading) {
      return ListView.builder(
        itemCount: itemsPerPage,
        itemBuilder: (context, index) => const SizedBox(), // Puedes usar un skeleton loader
      );
    }

    // Condición de lista vacía
    if (items.isEmpty) {
      return emptyWidget ?? const Center(
        child: Text('No hay elementos disponibles'),
      );
    }

    // Lista paginada
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.builder(
        itemCount: paginatedItems.length,
        itemBuilder: (context, index) {
          final item = paginatedItems[index];
          return itemBuilder(item);
        },
      ),
    );
  }
}

// Control de paginación
class PaginationControl extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;
  final Function(int) onPageChanged;
  final Function(int) onItemsPerPageChanged;

  const PaginationControl({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.itemsPerPageOptions,
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Selector de elementos por página
          GestureDetector(
            onTap: () => _showItemsPerPageDialog(context),
            child: Text('$itemsPerPage elementos por página'),
          ),
          // Controles de navegación de página
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
              ),
              Text('$currentPage de $totalPages'),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Diálogo para seleccionar elementos por página
  void _showItemsPerPageDialog(BuildContext context) {
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
                  onItemsPerPageChanged(option);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}