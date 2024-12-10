import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/modules/entry/screens/entry_screen.dart';
import 'package:warehouse_master_mobile/modules/movements/screens/movements_screen.dart';
import 'package:warehouse_master_mobile/modules/output/screens/output_screen.dart';
import 'package:warehouse_master_mobile/modules/profile/screens/profile_screen.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class AppBarNavigation extends StatefulWidget {
  const AppBarNavigation({super.key});

  @override
  State<AppBarNavigation> createState() => _AppBarNavigationState();
}

class _AppBarNavigationState extends State<AppBarNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MovementScreen(),
    const EntryScreen(),
    const OutputScreen(),
    const ProfileScreen(),

  ];

  final List<String> _titles = [
    'Inicio',
    'Entradas',
    'Salidas',
    'Perfil',

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Entradas',
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: 3.1416, // Rotación de 180 grados en radianes
              child: const Icon(Icons.logout),
            ),
            label: 'Salidas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deepMaroon,
        unselectedItemColor: AppColors.rosePrimary,
        backgroundColor: AppColors.errorColor,
        onTap: _onItemTapped,
      ),
    );
  }
}