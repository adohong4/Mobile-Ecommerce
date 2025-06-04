import 'dart:convert';

class Order {
  final String? id;
  final List<OrderItem> items;
  final double amount;
  final Address address;
  final String date;
  final String paymentMethod;
  final String status;
  final bool payment;

  Order({
    this.id,
    required this.items,
    required this.amount,
    required this.address,
    required this.date,
    required this.paymentMethod,
    required this.status,
    required this.payment,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'amount': amount,
      'address': address.toJson(),
      'date': date,
      'paymentMethod': paymentMethod,
      'status': status,
      'payment': payment,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String?,
      items:
          (json['items'] as List<dynamic>)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList(),
      amount: json['amount'] as double,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      date: json['date'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      payment: json['payment'] as bool,
    );
  }
}

class OrderItem {
  final String id; // Product ID
  final int quantity;
  final double price;

  OrderItem({required this.id, required this.quantity, required this.price});

  Map<String, dynamic> toJson() {
    return {'id': id, 'quantity': quantity, 'price': price};
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(), // ✅ ép an toàn từ int hoặc double
    );
  }

}

class Address {
  final String fullname;
  final String street;
  final String? precinct;
  final String city;
  final String province;

  Address({
    required this.fullname,
    required this.street,
    this.precinct,
    required this.city,
    required this.province,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'street': street,
      'precinct': precinct,
      'city': city,
      'province': province,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fullname: json['fullname'] as String,
      street: json['street'] as String,
      precinct: json['precinct'] as String?,
      city: json['city'] as String,
      province: json['province'] as String,
    );
  }
}
