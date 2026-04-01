import 'package:flutter/material.dart';
import '../models/book.dart';

class CartItem{
  final Book book;
  int quantity;

  CartItem({
    required this.book,
    this.quantity = 1,
  });

  double get totalPrice => book.price * quantity;
}

class CartService extends ChangeNotifier{
 final List<CartItem> _items = [];

 List<CartItem> get items => _items;

 int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

 double get total => _items.fold(0, (sum, item) => sum + item.totalPrice);

 void addToCart(Book book){
  final existingIndex = _items.indexWhere((item) => item.book.slug == book.slug);

  if (existingIndex != -1){
    _items[existingIndex].quantity++;
  } else{
    _items.add(CartItem(book: book));
  }
  notifyListeners();
 }

 void removeFromCart(Book book){
  _items.removeWhere((item) => item.book.slug == book.slug);
  notifyListeners();
 }

 void increaseQuantity(Book book){
  final index = _items.indexWhere((item) => item.book.slug == book.slug);
  if (index != -1){
    _items[index]. quantity++;
    notifyListeners();
  }
 }

 void decreaseQuantity(Book book){
  final index = _items.indexWhere((item) => item.book.slug == book.slug);
  if (index != -1){
    if (_items[index].quantity > 1){
    _items[index]. quantity--;
    notifyListeners();
  } else {
    removeFromCart(book);
  }
 }
}

void clearCart(){
  _items.clear();
  notifyListeners();
}

bool isInCart(Book book){
  return _items.any((item) => item.book.slug == book.slug);
}

int getQuantity(Book book){
  final index = _items.indexWhere((item) => item.book.slug == book.slug);
  if (index != -1){
    return _items[index].quantity;
  }
  return 0;
}
}