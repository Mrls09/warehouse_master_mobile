import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Map<String, dynamic>> userData = [];
  bool isLoading = true;
  String errorMessage = '';
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch all users from the API
  Future<void> _fetchUserData() async {
    try {
      String apiUrl =
          'http://192.168.109.162:8080/warehouse-master-api/users/get-all';
      final response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          userData = List<Map<String, dynamic>>.from(response.data['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al cargar los usuarios';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error de conexión';
      });
    }
  }

  // Create a new user via API
  Future<void> _createUser(Map<String, dynamic> userData) async {
    try {
      String apiUrl =
          'http://192.168.109.162:8080/warehouse-master-api/users/create';
      final response = await dio.post(apiUrl, data: userData);
      if (response.statusCode == 200) {
        _fetchUserData(); // Refresh the user list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el usuario')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  // Update a user's name via API
  Future<void> _updateUser(
      Map<String, dynamic> updatedUserData, String uid) async {
    try {
      String apiUrl =
          'http://192.168.109.162:8080/warehouse-master-api/users/update';
      final response = await dio.put(apiUrl, data: updatedUserData);
      if (response.statusCode == 200) {
        _fetchUserData(); // Refresh the user list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el usuario')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  // Delete a user via API
  Future<void> _deleteUser(String uid) async {
    try {
      String apiUrl =
          'http://192.168.109.162:8080/warehouse-master-api/users/delete/$uid';
      final response = await dio.delete(apiUrl);
      if (response.statusCode == 200) {
        _fetchUserData(); // Refresh the user list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario eliminado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el usuario')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  // Show modal to create a new user
  void _showCreateUserModal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Map<String, dynamic> newUser = {
                'name': nameController.text,
                'email': emailController.text,
                'password': passwordController.text,
                'role': 'SUPER_ADMIN',
                'active': true,
                'mfaEnabled': false,
                'lastModified': DateTime.now().toIso8601String(),
              };
              _createUser(newUser);
              Navigator.pop(context);
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  // Show modal to update user name
  void _showUpdateUserModal(String uid, String currentName) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar Nombre'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nuevo Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Map<String, dynamic> updatedUserData = {
                'uid': uid,
                'name': nameController.text,
                'email': 'jhsgusg',
                'active': true
              };
              _updateUser(updatedUserData, uid);
              Navigator.pop(context);
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // Error message
              : ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(userData[index]['uid'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteUser(userData[index]['uid']);
                      },
                      child: GestureDetector(
                        onTap: () {
                          _showUpdateUserModal(
                              userData[index]['uid'], userData[index]['name']);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://placehold.co/50x50.jpg'),
                          ),
                          title: Text(userData[index]['name'] ?? 'No Name'),
                          subtitle:
                              Text(userData[index]['email'] ?? 'No Email'),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepMaroon,
        foregroundColor: AppColors.lightGray,
        onPressed: _showCreateUserModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
