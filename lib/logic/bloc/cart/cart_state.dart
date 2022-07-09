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
  final double totalPrice;
  CartLoaded([this.items = const [], this.isAdded=false, this.isRemoved = false, this.product, this.totalPrice=0]);
  
  @override
  List<Object?> get props => [items, product, isAdded, isRemoved];


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((e) => e.toMap()).toList(),
      'product': product?.toMap(),
      'isAdded': isAdded,
      'isRemoved': isRemoved,
    };
  }

  factory CartLoaded.fromMap(Map<String, dynamic> map) {
    return CartLoaded(
      (map['items'] as List).map((e) => ProductModel.fromMap(e)).toList(),
      map['isAdded'],
      map['isRemoved'],
      ProductModel.fromMap(map['product'])
    );
  }
}

