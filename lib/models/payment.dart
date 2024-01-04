import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:simpanin/models/agreement.dart';
import 'package:simpanin/models/mailbox.dart';

class PaymentModel {
  String id;
  Timestamp date;
  int amount;
  AgreementModel agreement;
  MailboxModel mailbox;

  PaymentModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.agreement,
    required this.mailbox,
  });

  static Future<PaymentModel> fromFirestore(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DocumentSnapshot agreementSnapshot = await data['agreement'].get();
    AgreementModel agreement = await AgreementModel.fromFirestore(agreementSnapshot);
    return PaymentModel(
      id: doc.id,
      date: data['date'],
      amount: data['amount'],
      agreement: agreement,
      mailbox: agreement.mailbox
    );
  }

  factory PaymentModel.fromFuture(QueryDocumentSnapshot doc, DocumentSnapshot agreementDoc, DocumentSnapshot mailbox) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    AgreementModel agreement = AgreementModel.fromFuture(agreementDoc, mailbox);
    return PaymentModel(
      id: doc.id,
      date: data['date'],
      amount: data['amount'],
      agreement: agreement,
      mailbox: agreement.mailbox
    );
  }

  String get formattedDate {
    return DateFormat('d MMM').format(date.toDate());
  }

  String get formattedAmount {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return currencyFormat.format(amount);
  }
}
