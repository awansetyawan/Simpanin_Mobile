import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/agreement.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/pages/user/mailbox/mailbox_book.dart';
import 'package:simpanin/pages/user/user_main.dart';
import 'package:simpanin/providers/mailbox_book_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserAgreementDetailScreen extends StatefulWidget {
  final AgreementModel agreement;
  UserAgreementDetailScreen({super.key, required this.agreement});

  @override
  State<UserAgreementDetailScreen> createState() =>
      _UserAgreementDetailScreenState();
}

class _UserAgreementDetailScreenState extends State<UserAgreementDetailScreen> {
  bool loading = false;

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.agreement.mailbox.code,
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Chip(
                    padding: const EdgeInsets.all(5),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    label: Text(
                      widget.agreement.status,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(20),
                    child: widget.agreement.status == 'active'
                        ? Column(
                            children: [
                              Text("Kode PIN",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Text(widget.agreement.accessCode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))
                            ],
                          )
                        : Text(
                            "Lakukan pembayaran awal terlebih dahulu ke lokasi simpanin baru kamu bisa akses mailboxmu",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 18),
                          ),
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
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Informasi Langganan",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Tgl. Mulai',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.agreement.formattedEndDate,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Tgl. Pemb. Selanjutnya',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.agreement.formattedStartDate,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 40),
                  ButtonComponent(
                    loading: loading,
                    buttontext: "Cancel Langganan",
                    onPressed: () {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Ingin Batal Langganan?',
                          title: 'Yakin?',
                          confirmBtnText: 'Ya',
                          cancelBtnText: 'Nggak',
                          confirmBtnColor:
                              Theme.of(context).colorScheme.primary,
                          onConfirmBtnTap: () async {
                            db
                                .collection("agreements")
                                .doc(widget.agreement.id)
                                .update({
                              'status': 'cancel',
                            }).then((mailboxesRef) async {
                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.success(
                                  message: "Langganan Berhasil Dibatalkan!",
                                ),
                              );
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserMainScreen()),
                            );
                          });
                    },
                    // onPressed: _handleUbah,
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
