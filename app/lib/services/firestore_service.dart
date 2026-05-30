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

  Future<void> saveTransaction({
    required String uid,
    required TransactionModel transaction,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add({
      'title': transaction.title,
      'amount': transaction.amount,
      'type': transaction.type.name,
      'category': transaction.category,
      'date': Timestamp.fromDate(transaction.date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}