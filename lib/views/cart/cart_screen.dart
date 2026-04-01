import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/navigation_service.dart';
import '../../core/di/service_locator.dart';
import '../../shared/services/cart_service.dart';
import 'widget/cart_item_card.dart';

class CartScreen extends StatelessWidget{
  const CartScreen({super.key});

  @override  
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 12, 78, 132),
          foregroundColor: Colors.white,
          leading: IconButton(  
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              locator<NavigationService>().goBack();
            },
          ),
      ),
      body:  Consumer<CartService>(
        builder: (context, cartService, child){
          if (cartService.items.isEmpty){
            return const Center(
              child: Text(
                'No Books in your Cart',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: cartService.items.length,
            itemBuilder: (context, index){
              final cartItem = cartService.items[index];
              return CartItemCard(
                cartItem: cartItem,
                onIncrease:(){
                  cartService.increaseQuantity(cartItem.book);
                },
                onDecrease: (){
                  cartService.decreaseQuantity(cartItem.book);
                },
                onRemove: (){
                  cartService.removeFromCart(cartItem.book);
                },
              );
            },
          );
        },
        ),
      );
  }
}