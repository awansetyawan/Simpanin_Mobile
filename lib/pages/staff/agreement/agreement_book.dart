import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/agreement.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/pages/staff/staff_main.dart';
import 'package:simpanin/pages/user/mailbox/mailbox_book.dart';
import 'package:simpanin/providers/mailbox_book_provider.dart';
import 'package:simpanin/providers/page_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StaffAgreementBookScreen extends StatefulWidget {
  final AgreementModel agreement;
  StaffAgreementBookScreen({super.key, required this.agreement});

  @override
  State<StaffAgreementBookScreen> createState() =>
      _StaffAgreementBookScreenState();
}

class _StaffAgreementBookScreenState extends State<StaffAgreementBookScreen> {
  bool loading = false;
  final _discount = 2000;
  static final db = FirebaseFirestore.instance;

  void _handleSubmit() async {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Ingin Ubah Status Mailbox?',
        title: 'Yakin?',
        confirmBtnText: 'Ya',
        cancelBtnText: 'Nggak',
        confirmBtnColor: Theme.of(context).colorScheme.primary,
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          setState(() {
            loading = true;
          });
          try {
            DocumentReference agreementRef =
                db.collection('agreements').doc(widget.agreement.id);
            DocumentReference mailboxRef =
                db.collection('mailboxes').doc(widget.agreement.mailbox.id);
            db.collection("payments").add({
              'amount': widget.agreement.initialCost,
              'agreement': agreementRef,
              'mailbox': mailboxRef,
              'is_booking': true,
              'date': DateTime.now()
            }).then((mailboxRef) async {
              String accessCode = (1000 + Random().nextInt(9000)).toString();
              await db
                  .collection("agreements")
                  .doc(widget.agreement.id)
                  .update({
                'status': 'active',
                'access_code': accessCode,
              });
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(
                  message:
                      "Langgan ${widget.agreement.mailbox.code} Berhasil Diaktifkan!",
                ),
              );
              Provider.of<PageProvider>(context, listen: false).changePage(0);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StaffMainScreen()),
              );
            });
          } catch (e) {
            print(e);
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: "Terjadi Kesalahan!",
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          leading: BackButton(
            color: Theme.of(context).colorScheme.primary,
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Booking - ${widget.agreement.mailbox.code}",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Informasi Mailbox",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Harga',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(
                        "${widget.agreement.mailbox.formattedPrice}/bln",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Ukuran',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.agreement.mailbox.size,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Informasi Pemilik',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Nama',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.agreement.user!.name ?? '',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('No. HP',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.agreement.user!.phone ?? '',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Tgl. Pembayaran',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.agreement.formattedEndDate ?? '',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rincian Pembayaran",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Total Harga',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                            .format(widget.agreement.initialMonth *
                                widget.agreement.monthlyCost),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Diskon',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                            .format(_discount),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.green)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Total Pembayaran',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    trailing: Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                            .format(widget.agreement.initialMonth *
                                    widget.agreement.monthlyCost -
                                (widget.agreement.initialMonth * _discount)),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 40),
                  ButtonComponent(
                    loading: loading,
                    buttontext: "Terima Pembayaran",
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
