import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/kernel/widgets/list_view.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Map<String, dynamic>> userData = [
    {
      'imageUrl': 'https://placehold.co/50x50.jpg',
      'title': 'User 1',
      'description': 'Description for user 1',
    },
    {
      'imageUrl': 'https://placehold.co/50x50.jpg',
      'title': 'User 2',
      'description': 'Description for user 2',
    },
    {
      'imageUrl': 'https://placehold.co/50x50.jpg',
      'title': 'User 3',
      'description': 'Description for user 3',
    },
    {
      'imageUrl': 'https://placehold.co/50x50.jpg',
      'title': 'User 4',
      'description': 'Description for user 4',
    },
  ];

  Future<void> _deleteUser(int index) async {
    setState(() {
      userData.removeAt(index);
    });

    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario eliminado exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(userData[index]['title'] ?? 'user-$index'), // Clave única
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteUser(index);
            },
            child: GestureDetector(
              onTap: () {
                print('Tapped on ${userData[index]['title']}');
                // Aquí puedes añadir navegación a una pantalla de detalles si es necesario
              },
              child: GenericListItem(data: userData[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepMaroon,
        foregroundColor: AppColors.lightGray,
        onPressed: () => Navigator.pushNamed(context, '/created'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
