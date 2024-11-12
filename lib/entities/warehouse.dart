class Warehouse {
  final String _uid;
  final String _name;
  final String _location;
  final int _capacity;
  final bool _active;
  final String _lastModified;

  Warehouse(this._uid, this._name, this._location, this._capacity, this._active,
      this._lastModified);

  String get uid => _uid;
  String get name => _name;
  String get location => _location;
  int get capacity => _capacity;
  bool get active => _active;
  String get lastModified => _lastModified;
}