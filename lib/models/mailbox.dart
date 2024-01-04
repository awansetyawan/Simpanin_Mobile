import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MailboxModel {
  String id;
  String code;
  int price;
  String size;
  bool availability;
  bool isActive;

  MailboxModel({
    required this.id,
    required this.code,
    required this.price,
    required this.size,
    required this.availability,
    required this.isActive,
  });

  factory MailboxModel.fromJson(Map<String, dynamic> _json) {
    return MailboxModel(
      id: _json['id'],
      code: _json['code'],
      price: _json['price'],
      size: _json['size'],
      availability: _json['availability'],
      isActive: _json['is_active'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'price': price,
      'size': size,
      'is_active': isActive,
    };
  }

  factory MailboxModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MailboxModel(
      id: doc.id,
      code: data['code'],
      price: data['price'],
      size: data['size'],
      availability: data['availability'] ?? false,
      isActive: data['is_active'] ?? false,
    );
  }

  String get formattedPrice {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return currencyFormat.format(price);
  }
}
