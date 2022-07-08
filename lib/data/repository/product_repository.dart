import 'dart:convert';
import 'dart:math';

import 'package:cart_bloc/data/models/product_model.dart';
import 'package:cart_bloc/data/provider/product_provider.dart';
import 'package:flutter/material.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    String? productsRaw = await ProductProvider().getProducts();

    if (productsRaw == null) {
      return [];
    }
    try {
      List<ProductModel> products = (json.decode(productsRaw) as List)
          .map((data) => ProductModel.fromMap(data))
          .toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
