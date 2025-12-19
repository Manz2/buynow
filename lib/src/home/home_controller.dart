import 'package:buynow/src/db_service_firebase.dart';
import 'package:buynow/src/home/home_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  final HomeModel model;
  final DbServiceFirebase db;

  HomeController()
    : db = DbServiceFirebase(),
      model = HomeModel(uid: FirebaseAuth.instance.currentUser!.uid);

  Stream<QuerySnapshot<Map<String, dynamic>>> get lists {
    return db.getListsStream(model.uid);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> items(String listId) {
    return db.getItemsStream(model.uid, listId);
  }

  Future<void> createList(String name) {
    return db.createShoppingList(model.uid, name);
  }

  Future<void> loadLastActiveList() async {
    final prefs = await SharedPreferences.getInstance();
    model.activeListId = prefs.getString('activeListId');
    model.activeListName = prefs.getString('activeListName');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get products {
    return db.getProductsStream(model.uid);
  }

  Future<void> setActiveList(String listId, String name) async {
    model.activeListId = listId;
    model.activeListName = name;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? get activeItems {
    if (model.activeListId == null) return null;
    return db.getItemsStream(model.uid, model.activeListId!);
  }

  Future<void> createAndSelectList(String name) async {
    final doc = await db.createShoppingList(model.uid, name);
    model.activeListId = doc.id;
    model.activeListName = name;
  }

  Future<void> addItemToProducts({
    required String listId,
    required String icon,
    required String name,
    required String category,
  }) async {
    final id = await db.upsertProduct(
      uid: model.uid,
      name: name,
      category: category,
      icon: icon,
    );
    await db.addItemToList(
      uid: model.uid,
      listId: listId,
      id: id,
      name: name,
      category: category,
      icon: icon,
      additionalInfo: '',
    );
  }

  Future<void> addItemToList({
    required String listId,
    required String itemId,
    required String name,
    required String category,
    required String icon,
    required String additionalInfo,
  }) {
    // Update timestamp
    db.upsertProduct(
      uid: model.uid,
      name: name,
      category: category,
      icon: icon,
    );

    // add item to list
    return db.addItemToList(
      uid: model.uid,
      listId: listId,
      id: itemId,
      name: name,
      category: category,
      additionalInfo: additionalInfo,
      icon: icon,
    );
  }

  Future<void> removeItemFromList({
    required String listId,
    required String itemId,
  }) {
    return db.removeItemFromList(
      uid: model.uid,
      listId: listId,
      itemId: itemId,
    );
  }
}
