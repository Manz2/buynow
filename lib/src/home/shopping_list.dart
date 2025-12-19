import 'item.dart';

class ShoppingList {
  final String id;
  final String name;
  final List<Item> items;

  ShoppingList({
    required this.id,
    required this.name,
    List<Item>? items,
  }) : items = items ?? [];

  factory ShoppingList.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ShoppingList(
      id: id,
      name: data['name'] as String,
    );
  }
}
