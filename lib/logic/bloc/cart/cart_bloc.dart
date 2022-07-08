import 'package:bloc/bloc.dart';
import 'package:cart_bloc/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {

    on<CartStarted>((event, emit) {
      emit(CartLoading());
      emit(CartLoaded());
    });

    on<ItemAdded>((event, emit) {
      final state = this.state;
      if(state is CartLoaded){
        emit(CartLoading());
        List<ProductModel> newItems = [...state.items];
        if (state.items.any((element) => element == event.item)) {
          var changedItemIndex =
              newItems.indexWhere((element) => element == event.item);
          debugPrint(changedItemIndex.toString());
          newItems[changedItemIndex] = ProductModel(
              itemName: newItems[changedItemIndex].itemName,
              price: newItems[changedItemIndex].price,
              quantity: newItems[changedItemIndex].quantity + 1,
              image: newItems[changedItemIndex].image);
          emit(CartLoaded(newItems, true, false, event.item));
        } else {
          newItems.add(event.item);
          emit(CartLoaded(newItems, true, false, event.item));
        }
      }
    });

    on<ItemRemoved>((event, emit) {
      final state = this.state;
      if(state is CartLoaded){
        emit(CartLoading());
        var newItems = [...state.items];
        var itemRequestForRemoveIndex =
            newItems.indexWhere((element) => element == event.item);
        debugPrint(newItems.toString());
        if (itemRequestForRemoveIndex!=-1 && newItems[itemRequestForRemoveIndex].quantity > 1) {
          newItems[itemRequestForRemoveIndex] = ProductModel(
              itemName: newItems[itemRequestForRemoveIndex].itemName,
              price: newItems[itemRequestForRemoveIndex].price,
              quantity: newItems[itemRequestForRemoveIndex].quantity - 1,
              image: newItems[itemRequestForRemoveIndex].image);
          emit(CartLoaded(newItems, false, true, event.item));
        } else {
          newItems.remove(event.item);
          emit(CartLoaded(newItems, false, true, event.item));
        }
      }
    });
  }
}
