import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Tipos de filtro genéricos
enum FilterType {
  all,
  lastHour,
  date,
  status
}

// Definición de un filtro genérico
class GenericFilter<T> {
  final String label;
  final FilterType type;
  final bool Function(T item)? filterCondition;

  GenericFilter({
    required this.label, 
    required this.type, 
    this.filterCondition
  });
}

class FilterChipBar<T> extends StatelessWidget {
  final List<GenericFilter<T>> filters;
  final String currentFilter;
  final Function(String) onFilterChanged;
  final DateTime? selectedDate;
  final String? selectedStatus;
  final Map<String, String>? statusDescriptions;

  const FilterChipBar({
    super.key,
    required this.filters,
    required this.currentFilter,
    required this.onFilterChanged,
    this.selectedDate,
    this.selectedStatus,
    this.statusDescriptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) => _buildFilterChip(filter)).toList(),
          ),
        ),
        // Mostrar detalles del filtro seleccionado
        if (currentFilter == FilterType.date.name && selectedDate != null)
          Text(
            'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        if (currentFilter == FilterType.status.name && selectedStatus != null)
          Text(
            'Estado: ${statusDescriptions?[selectedStatus] ?? selectedStatus}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  Widget _buildFilterChip(GenericFilter<T> filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(filter.label),
        selected: currentFilter == filter.type.name,
        onSelected: (_) => onFilterChanged(filter.type.name),
        selectedColor: Colors.blue[100],
      ),
    );
  }
}