class Movement {
  final int id;
  final int productId;
  final String type;
  final int quantity;
  final int? userId;
  final DateTime date;
  final String status;
  final String? motif;
  final DateTime createdAt;

  Movement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    this.userId,
    required this.date,
    required this.status,
    this.motif,
    required this.createdAt,
  });
  Movement copyWith({
    int? id,
    int? productId,
    String? type,
    int? quantity,
    int? userId,
    DateTime? date,
    String? status,
    String? motif,
    DateTime? createdAt,
  }) {
    return Movement(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      status: status ?? this.status,
      motif: motif ?? this.motif,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'],
      productId: json['productId'],
      type: json['type'],
      quantity: json['quantity'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      motif: json['motif'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'type': type,
      'quantity': quantity,
      'userId': userId,
      'date': date.toIso8601String(),
      'status': status,
      'motif': motif,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isEntry => type == 'entry';
  bool get isPending => status == 'pending';
}