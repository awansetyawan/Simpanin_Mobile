import 'dart:async';
import 'package:simpanin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  static get genre => null;

  static Future<void> updateUser(UserModel user) async {
    _userCollection.doc(user.id).set({
      'email': user.email,
      'name': user.name,
      'address': user.address,
      'role': user.role,
      'phone': user.phone,
    });
  }

  static Future<UserModel> getUser(String id) async {
    DocumentSnapshot snapshot = await _userCollection.doc(id).get();
    UserModel user = UserModel(
        id: id,
        email: snapshot['email'],
        name: snapshot['name'],
        address: snapshot['address'],
        role: snapshot['role'],
        phone: snapshot['phone']);
    return user;
  }
}
