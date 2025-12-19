import 'package:cloud_firestore/cloud_firestore.dart';

class DbServiceFirebase {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createUserData(String uid) async {
    await db.collection('users').doc(uid).set({
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getListsStream(String uid) {
    return db
        .collection('users')
        .doc(uid)
        .collection('lists')
        .orderBy('createdAt')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItemsStream(
    String uid,
    String listId,
  ) {
    return db
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listId)
        .collection('items')
        .orderBy('createdAt')
        .snapshots();
  }

  Future<DocumentReference<Map<String, dynamic>>> createShoppingList(
    String uid,
    String listName,
  ) {
    return db.collection('users').doc(uid).collection('lists').add({
      'name': listName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addItemToList({
    required String uid,
    required String icon,
    required String listId,
    required String id,
    required String name,
    required String category,
    required String additionalInfo,
  }) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listId)
        .collection('items')
        .doc(id)
        .set({
          'name': name,
          'category': category,
          'additionalInfo': additionalInfo,
          'completed': false,
          'createdAt': FieldValue.serverTimestamp(),
          'icon': icon,
        });
  }

  Future<String> upsertProduct({
    required String uid,
    required String name,
    required String category,
    required String icon,
  }) async {
    final productsRef = db.collection('users').doc(uid).collection('products');

    final query = await productsRef
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      final docRef = productsRef.doc();

      await docRef.set({
        'name': name,
        'category': category,
        'useCount': 1,
        'lastUsedAt': FieldValue.serverTimestamp(),
        'icon': icon,
      });

      return docRef.id;
    } else {
      await query.docs.first.reference.update({
        'useCount': FieldValue.increment(1),
        'lastUsedAt': FieldValue.serverTimestamp(),
      });

      return query.docs.first.id;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsStream(String uid) {
    return db
        .collection('users')
        .doc(uid)
        .collection('products')
        .orderBy('useCount', descending: true)
        .snapshots();
  }

  Future<void> removeItemFromList({
    required String uid,
    required String listId,
    required String itemId,
  }) {
    return db
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  void updateLastUse({required String uid, required String id}) {
    final productsRef = db.collection('users').doc(uid).collection('products');
    productsRef.doc(id).update({
      'useCount': FieldValue.increment(1),
      'lastUsedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> productExists({
    required String uid,
    required String name,
  }) async {
    final query = await db
        .collection('users')
        .doc(uid)
        .collection('products')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }
}
