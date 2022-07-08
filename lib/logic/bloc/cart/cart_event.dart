part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class CartStarted extends CartEvent{}

class ItemAdded extends CartEvent {
  final ProductModel item;
  ItemAdded(this.item);
}

class ItemRemoved extends CartEvent {
  final ProductModel item;
  ItemRemoved(this.item);
}
