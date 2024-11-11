import 'package:warehouse_master_mobile/entities/warehouse.dart';

class User {
  final String _uid;
  final String _name;
  final String _email;
  final String _password;
  final String _lastModified;
  final String _role;
  final Warehouse _warehouse;
  final bool _active;
  final bool _mfaEnabled;

  User(this._uid, this._name, this._email, this._password, this._lastModified,
      this._role, this._warehouse, this._active, this._mfaEnabled);
}
