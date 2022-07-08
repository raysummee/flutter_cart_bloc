part of 'cart_bloc.dart';

@immutable
abstract class CartState extends Equatable{
}

class CartInitial extends CartState {
  @override
  List<Object?> get props => [];

}

class CartLoading extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  final List<ProductModel> items;
  final ProductModel? product;
  final bool isAdded;
  final bool isRemoved;
  CartLoaded([this.items = const [], this.isAdded=false, this.isRemoved = false, this.product]);
  
  @override
  List<Object?> get props => [items, product, isAdded, isRemoved];
}
