import 'package:flutter/material.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _warehouseName = '';
  String _warehouseLocation = '';

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí puedes agregar la lógica para guardar el usuario en la base de datos
      // y luego regresar a la pantalla de administración con la información del usuario
      Navigator.pop(context, {
        'uid': 'some-uid',
        'name': _name,
        'email': _email,
        'password': _password,
        'lastModified': DateTime.now().toIso8601String(),
        'role': 'SUPER_ADMIN',
        'warehouse': {
          'uid': 'some-warehouse-uid',
          'name': _warehouseName,
          'location': _warehouseLocation,
          'capacity': 0,
          'active': true,
          'lastModified': DateTime.now().toIso8601String(),
        },
        'active': true,
        'mfaEnabled': true,
        'mfaDevice': {
          'uid': 'some-mfa-device-uid',
          'secretKey': 'some-secret-key',
          'user': {
            'uid': 'some-uid',
            'name': _name,
            'email': _email,
            'password': _password,
            'lastModified': DateTime.now().toIso8601String(),
            'role': 'SUPER_ADMIN',
            'warehouse': {
              'uid': 'some-warehouse-uid',
              'name': _warehouseName,
              'location': _warehouseLocation,
              'capacity': 0,
              'active': true,
              'lastModified': DateTime.now().toIso8601String(),
            },
            'active': true,
            'mfaEnabled': true,
          }
        },
        'user': {
          'uid': 'some-uid',
          'name': _name,
          'email': _email,
          'password': _password,
          'lastModified': DateTime.now().toIso8601String(),
          'role': 'SUPER_ADMIN',
          'warehouse': {
            'uid': 'some-warehouse-uid',
            'name': _warehouseName,
            'location': _warehouseLocation,
            'capacity': 0,
            'active': true,
            'lastModified': DateTime.now().toIso8601String(),
          },
          'active': true,
          'mfaEnabled': true,
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo electrónico';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del almacén'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del almacén';
                  }
                  return null;
                },
                onSaved: (value) {
                  _warehouseName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ubicación del almacén'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la ubicación del almacén';
                  }
                  return null;
                },
                onSaved: (value) {
                  _warehouseLocation = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
