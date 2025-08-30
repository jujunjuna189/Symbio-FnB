class ModelOutlet {
  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  ModelOutlet({this.id, this.name, this.phone, this.address, this.createdAt, this.updatedAt});

  factory ModelOutlet.fromMap(Map<String, dynamic> map) {
    return ModelOutlet(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
