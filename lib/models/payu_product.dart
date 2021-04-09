class PayUProduct {
  final String name;
  final int unitPrice;
  final int quantity;

  PayUProduct({
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };
}
