// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String itemName;
  final int quantity;
  final double price;
  final String image;

  const ProductModel(
      {required this.itemName,
      required this.price,
      required this.quantity,
      required this.image});

  @override
  List<Object?> get props => [itemName, quantity, price];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': itemName,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      itemName: map['title'] as String,
      quantity: ((map['quantity'] ?? 0) as num).toInt(),
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
