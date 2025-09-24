import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem { final String id; final String name; final double price; final String img; int qty;
  CartItem({required this.id, required this.name, required this.price, required this.img, this.qty=1});
  double get total => price * qty;
}
class CartModel {
  final List<CartItem> items; CartModel(this.items);
  int get totalItems => items.fold(0,(a,b)=> a+b.qty);
  double get subtotal => items.fold(0.0,(a,b)=> a+b.total);
  double get taxes => subtotal * 0.1;
  double get delivery => 2.0;
  double get total => subtotal + taxes + delivery;
}
class CartController extends StateNotifier<CartModel> {
  CartController(): super(CartModel([]));
  void add(Map<String,dynamic> raw){ final id='${raw['id']}', name='${raw['name']}', price=(raw['price'] as num).toDouble(), img=(raw['img'] as String?) ?? '';
    final list=[...state.items]; final i=list.indexWhere((e)=>e.id==id); if (i==-1) list.add(CartItem(id:id,name:name,price:price,img:img)); else list[i].qty++; state=CartModel(list); }
  void inc(String id){ final l=[...state.items]; final i=l.indexWhere((e)=>e.id==id); if (i!=-1){ l[i].qty++; state=CartModel(l);} }
  void dec(String id){ final l=[...state.items]; final i=l.indexWhere((e)=>e.id==id); if (i!=-1){ l[i].qty--; if (l[i].qty<=0) l.removeAt(i); state=CartModel(l);} }
  void remove(String id){ state=CartModel(state.items.where((e)=>e.id!=id).toList()); }
  void clear(){ state=CartModel([]); }
}
final cartProvider = StateNotifierProvider<CartController, CartModel>((ref)=> CartController());
