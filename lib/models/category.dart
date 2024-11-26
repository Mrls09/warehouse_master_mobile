class Category {
  final String uid;
  final String name;
  final String description;
  final bool active;
  final String lastModified;

  Category({
    required this.uid,
    required this.name,
    required this.description,
    required this.active,
    required this.lastModified,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      active: json['active'],
      lastModified: json['lastModified'],
    );
  }
}