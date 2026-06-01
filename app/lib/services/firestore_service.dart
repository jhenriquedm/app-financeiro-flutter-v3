import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveUser({
    required String uid,
    required UserModel user,
  }) {
    return _firestore.collection('users').doc(uid).set({
      'name': user.name,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUser({
    required String uid,
  }) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final data = doc.data()!;

    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: '',
    );
  }

  Future<void> saveTransaction({
    required String uid,
    required TransactionModel transaction,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transaction.id.toString())
        .set({
      'localId': transaction.id,
      'title': transaction.title,
      'amount': transaction.amount,
      'type': transaction.type.name,
      'category': transaction.category,
      'date': Timestamp.fromDate(transaction.date),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<TransactionModel>> getTransactions({
    required String uid,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      final timestamp = data['date'];

      return TransactionModel(
        id: data['localId'] as int?,
        userId: uid,
        title: data['title'] ?? '',
        amount: (data['amount'] as num).toDouble(),
        date: timestamp is Timestamp
            ? timestamp.toDate()
            : DateTime.now(),
        type: data['type'] == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        category: data['category'] ?? 'Outros',
      );
    }).toList();
  }

  Future<void> deleteTransaction({
    required String uid,
    required int transactionId,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transactionId.toString())
        .delete();
  }
}