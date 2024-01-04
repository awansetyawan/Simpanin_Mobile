import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/models/user.dart';
import 'package:simpanin/pages/user/user_main.dart';
import 'package:simpanin/providers/mailbox_book_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserMailboxBookScreen extends StatefulWidget {
  UserMailboxBookScreen({super.key});

  @override
  State<UserMailboxBookScreen> createState() => _UserMailboxBookScreenState();
}

class _UserMailboxBookScreenState extends State<UserMailboxBookScreen> {
  bool loading = false;
  final _months = [1, 3, 6, 9, 12];
  final _discount = 2000;
  int _selectedMonth = 1;
  static final db = FirebaseFirestore.instance;

  void _handleSubmit() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Sudah benar semua, kan?',
        title: 'Konfirmasi...',
        confirmBtnText: 'Ya',
        cancelBtnText: 'Nggak',
        confirmBtnColor: Theme.of(context).colorScheme.primary,
        onConfirmBtnTap: () async {
          setState(() {
            loading = true;
          });
          try {
            MailboxModel mailbox =
                Provider.of<MailboxBookProvider>(context, listen: false)
                    .mailbox;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String encodedAuth = prefs.getString('auth') ?? "{}";
            UserModel auth = UserModel.fromJson(json.decode(encodedAuth));
            DocumentReference userRef = db.collection('users').doc(auth.id);
            DocumentReference mailboxRef =
                db.collection('mailboxes').doc(mailbox.id);

            db.collection("agreements").add({
              "access_code": "",
              "start_date": FieldValue.serverTimestamp(),
              "end_date":
                  DateTime.now().add(Duration(days: 30 * _selectedMonth)),
              "note": "-",
              "initial_cost":
                  _selectedMonth * mailbox.price - (_selectedMonth * _discount),
              "initial_month": _selectedMonth,
              "monthly_cost": mailbox.price,
              "status": "pending",
              "user": userRef,
              "mailbox": mailboxRef
            }).then((agreementRef) async {
              await db
                  .collection("mailboxes")
                  .doc(mailbox.id)
                  .update({"availability": false});
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.success(
                  message: "Booking Berhasil, Segera Lakukan Pembayaran, ya!",
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserMainScreen()),
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
    return Consumer<MailboxBookProvider>(
        builder: (context, mailboxData, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            scrolledUnderElevation: 0,
            leading: const BackButton(
              color: Colors.white,
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking\nMailbox-mu",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32)),
                  color: Theme.of(context).colorScheme.background,
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
                      leading: Text('Kode',
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text(mailboxData.mailbox.code,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('Harga',
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text(
                          "${mailboxData.mailbox.formattedPrice}/bln",
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('Lama Berlangganan',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _months
                            .map((month) => Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: Card(
                                          color: _selectedMonth == month
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedMonth = month;
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                              child: Text("$month Bulan",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          color: _selectedMonth ==
                                                                  month
                                                              ? Colors.white
                                                              : Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary)),
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
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
                              .format(
                                  _selectedMonth * mailboxData.mailbox.price),
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('Diskon',
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text(
                          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                              .format(_selectedMonth * _discount),
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
                              .format(
                                  _selectedMonth * mailboxData.mailbox.price -
                                      (_selectedMonth * _discount)),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              ButtonComponent(
                loading: loading,
                buttontext: "Konfirmasi",
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      );
    });
  }
}
