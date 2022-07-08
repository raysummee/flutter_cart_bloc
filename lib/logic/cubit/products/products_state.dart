part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductEmpty extends ProductsState {}

class ProductError extends ProductsState {}

class ProductLoaded extends ProductsState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}


