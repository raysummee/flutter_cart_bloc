import 'package:badges/badges.dart';
import 'package:cart_bloc/logic/bloc/cart/cart_bloc.dart';
import 'package:cart_bloc/logic/cubit/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  @override
  void initState() {
    context.read<ProductsCubit>().productRequested();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 1,
      lowerBound: 0,
    );
    super.initState();
  }

  late AnimationController animationController;

  void animateCartAdd(BuildContext contextRenderBox, ImageProvider image){
    var overlayEntry = OverlayEntry(
      builder: (context) {
        RenderBox? box = contextRenderBox.findRenderObject() as RenderBox?;
        if(box!=null){
          var startOffset = box.localToGlobal(Offset(-60+ MediaQuery.of(context).size.width/4, 60- MediaQuery.of(context).size.width/4));
          var endOffset = Offset(MediaQuery.of(context).size.width, 0);

          CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeInCubic);

          var animatedOffset = Tween<Offset>(begin:startOffset, end: endOffset).animate(curvedAnimation);
          animationController.reset();
          animationController.animateTo(1);
          return AnimatedBuilder(
            animation: animationController,
            builder: (_, child){
              return Positioned(
                top: animatedOffset.value.dy,
                left: animatedOffset.value.dx,
                child: child!
              );
            },
            child: SizedBox(
              width: -120 + MediaQuery.of(context).size.width/2,
              height: -120 + MediaQuery.of(context).size.width/2,
              child: Card(
                elevation: 2,
                color: Colors.grey.shade200,
                child: Image(
                  image: image,
                ),
              ),
            )
          );
        }
        return const SizedBox();
      },
    );
    Overlay.of(contextRenderBox)?.insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 500), () {
      overlayEntry.remove();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0,
          actions: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed("/cart");
            }, 
            icon: Badge(
              badgeContent: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if(state is CartLoaded){
                    return Text(state.items.length.toString());
                  }
                  return const Text("");
                },
              ),
              child: const Icon(Icons.shopping_bag))
            )
          ],
          title: const Text("Cart App Using BLOC"),
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductLoaded) {
              return BlocListener<CartBloc, CartState>(
                listenWhen: (previous, current) {
                  if(current is CartLoaded && (current.isAdded || current.isRemoved)){
                    return true;
                  }
                  return false;
                },
                listener: (context, state) {
                  String msg = "";

                  if (state is CartLoaded && state.isAdded) {
                    msg = "${state.product?.itemName} is added to cart";
                  }else if (state is CartLoaded && state.isRemoved) {
                    msg = "${state.product?.itemName} is removed to cart";
                  }

                  Fluttertoast.cancel();
                  Fluttertoast.showToast(msg: msg, gravity: ToastGravity.SNACKBAR,);
                },
                child: GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                state.products[index].image,
                                width: -120 +
                                    MediaQuery.of(context).size.width / 2,
                                height: -120 +
                                    MediaQuery.of(context).size.width / 2,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                state.products[index].itemName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.purple),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              BlocBuilder<CartBloc, CartState>(
                                buildWhen: (previous, current) {
                                  if(current is CartLoaded){
                                    return previous != current; 
                                  }
                                  return false;
                                },
                                builder: (context, cartState) {
                                  bool itemAddedToCart = false;
                                  if(cartState is CartLoaded){
                                    itemAddedToCart = cartState.items.contains(state.products[index]);
                                  }else{
                                    itemAddedToCart = false;
                                  }
                                  return Builder(
                                    builder: (contextRenderBox) {
                                      return OutlinedButton(
                                        onPressed: () {
                                          if(itemAddedToCart){
                                            context
                                                .read<CartBloc>()
                                                .add(ItemRemoved(state.products[index]));
                                          }else{
                                            context
                                                .read<CartBloc>()
                                                .add(ItemAdded(state.products[index]));
                                            
                                            animateCartAdd(contextRenderBox,  NetworkImage(state.products[index].image,),);
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          fixedSize: const Size.fromWidth(200),
                                        ),
                                        child: Text(
                                          itemAddedToCart? "Remove": "Add",
                                          style: const TextStyle(color: Colors.purple),
                                        ));
                                    }
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
            return const SizedBox();
          },
        ));
  }
}
