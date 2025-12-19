import 'shopping_list.dart';

class HomeModel {
  final String uid;
  bool isLoading;
  List<ShoppingList> lists;
  String? activeListName;
  String? activeListId;


  HomeModel({
    required this.uid,
    this.isLoading = true,
    List<ShoppingList>? lists,
    this.activeListName,
    this.activeListId,
  }) : lists = lists ?? [];
}
