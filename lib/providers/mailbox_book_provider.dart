import 'package:flutter/material.dart';
import 'package:simpanin/models/mailbox.dart';

class MailboxBookProvider extends ChangeNotifier {
  MailboxModel _mailbox = MailboxModel(
    availability: false,
    code: '',
    id: '',
    price: 0,
    size: '',
    isActive: false,
  );

  MailboxModel get mailbox {
    return _mailbox;
  }

  changeMailbox({ required MailboxModel mailbox }) {
    _mailbox = mailbox;
  }
}
