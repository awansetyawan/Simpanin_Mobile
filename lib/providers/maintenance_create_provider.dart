import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/models/maintenance.dart';

class MaintenanceCreateProvider extends ChangeNotifier {
  MaintenanceModel _maintenance = MaintenanceModel(
    id: '',
    startDate: Timestamp.now(),
    endDate: Timestamp.now(),
    note: '',
    mailbox: MailboxModel(
      availability: false,
      code: '',
      id: '',
      price: 0,
      size: '',
      isActive: false
    ),
  );

  MaintenanceModel get maintenance => _maintenance;

  void setMaintenance(MaintenanceModel maintenance) {
    _maintenance = maintenance;
    notifyListeners();
  }

  void setMailbox(MailboxModel mailbox){
    _maintenance.mailbox = mailbox;
  }
}
