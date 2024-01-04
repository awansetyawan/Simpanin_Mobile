import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:simpanin/models/mailbox.dart';

class MaintenanceModel {
  String id;
  Timestamp startDate;
  Timestamp endDate;
  String note;
  MailboxModel mailbox;

  MaintenanceModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.note,
    required this.mailbox,
  });

  static Future<MaintenanceModel> fromFirestore(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DocumentSnapshot mailbox = await data['mailbox'].get();
    return MaintenanceModel(
      id: doc.id,
      startDate: data['start_date'],
      endDate: data['end_date'],
      note: data['note'],
      mailbox: MailboxModel.fromFirestore(mailbox)
    );
  }

  factory MaintenanceModel.fromFuture(DocumentSnapshot doc, DocumentSnapshot mailbox) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MaintenanceModel(
      id: doc.id,
      startDate: data['start_date'],
      endDate: data['end_date'],
      note: data['note'],
      mailbox: MailboxModel.fromFirestore(mailbox)
    );
  }

  String get formattedStartDate {
    return DateFormat('d MMM').format(startDate.toDate());
  }

  String get formattedEndDate {
    return DateFormat('d MMM').format(endDate.toDate());
  }

  bool get isDone {
    return DateTime.now().isAfter(endDate.toDate());
  }
}
