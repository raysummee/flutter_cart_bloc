import 'package:bloc/bloc.dart';
import 'package:cart_bloc/data/models/product_model.dart';
import 'package:cart_bloc/data/repository/product_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._productRepository) : super(ProductsLoading());
  final ProductRepository _productRepository;

  Future<void> productRequested() async {
    emit(ProductsLoading());
    List<ProductModel> products = await _productRepository.getProducts();
    if (products.isEmpty) {
      emit(ProductEmpty());
    }
    emit(ProductLoaded(products));
  }
}
