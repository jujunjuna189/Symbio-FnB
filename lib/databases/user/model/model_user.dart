class ModelUser {
  final int? id;
  final String? name;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  ModelUser({this.id, this.name, this.email, this.createdAt, this.updatedAt});

  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'created_at': createdAt, 'updated_at': updatedAt};
  }
}
