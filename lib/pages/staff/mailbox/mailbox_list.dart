import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpanin/pages/staff/mailbox/mailbox_create.dart';
import 'package:simpanin/pages/staff/mailbox/mailbox_detail.dart';
import 'package:simpanin/pages/staff/mailbox/mailbox_edit.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StaffMailboxListScreen extends StatefulWidget {
  const StaffMailboxListScreen({super.key});

  @override
  State<StaffMailboxListScreen> createState() => _StaffMailboxListScreenState();
}

class _StaffMailboxListScreenState extends State<StaffMailboxListScreen> {
  final db = FirebaseFirestore.instance;

  final StreamController<void> _refreshController = StreamController<void>();

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _refreshController.close();
    super.dispose();
  }

  void _handleActive(MailboxModel mailbox) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Ingin Ubah Status Mailbox?',
        title: 'Yakin?',
        confirmBtnText: 'Ya',
        cancelBtnText: 'Nggak',
        confirmBtnColor: Theme.of(context).colorScheme.primary,
        onConfirmBtnTap: () async {

          db.collection("mailboxes").doc(mailbox.id).update({
            'is_active': !mailbox.isActive,
          }).then((mailboxesRef) async {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: "Status Mailbox Berhasil Diubah!",
              ),
            );
            _refreshController.add(null);
          });

          Navigator.pop(context);
        });
  }

  void _clickBottomSheet(MailboxModel mailbox) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Container(
            height: mailbox.isActive && mailbox.availability ? 200 : 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              color: Theme.of(context).colorScheme.background
            ),
            child: Column(children: [
              if (mailbox.isActive && mailbox.availability)
                Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: const Icon(Iconsax.edit),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StaffMailboxEditScreen(mailbox: mailbox)),
                        );
                      },
                      title:
                          Text("Ubah", style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const Divider(height: 2),
                  ],
                ),
              ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: const Icon(Iconsax.status),
                title: mailbox.isActive ? (Text("Nonaktif", style: Theme.of(context).textTheme.titleLarge)) : (Text("Aktif", style: Theme.of(context).textTheme.titleLarge)),
                onTap: () {
                  Navigator.pop(context);
                  _handleActive(mailbox);
                },
              ),
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('mailboxes').orderBy("code").snapshots(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              controller: _scrollController,
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 100),
                    child: Text("Mailbox",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 255),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(32),
                          topLeft: Radius.circular(32)),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: snapshot.hasData
                        ? SizedBox(
                            height: 100,
                            child: ListView(
                              children: snapshot.data!.docs.map((doc) {
                                MailboxModel mailbox =
                                    MailboxModel.fromFirestore(doc);
                                return Column(
                                  children: [
                                    ListTile(
                                      onLongPress: () {
                                        _clickBottomSheet(mailbox);
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StaffMailboxDetailScreen(
                                                      mailbox: mailbox)),
                                        );
                                      },
                                      leading: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: mailbox.isActive
                                              ? (mailbox.availability
                                                  ? Colors.green
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .tertiary)
                                              : Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Text(mailbox.code,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                      color: mailbox
                                                              .availability
                                                          ? Colors.white
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .primary)),
                                        ),
                                      ),
                                      title: Text(mailbox.formattedPrice,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      subtitle: Text("Ukuran ${mailbox.size}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.grey)),
                                      trailing: Icon(
                                        Iconsax.arrow_right,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        : (const Center(
                            child: CircularProgressIndicator(),
                          )),
                  ),
                ],
              ),
            );
          }),
      // FloatingActionButton dengan label "Tambah"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const StaffMailboxCreateScreen()),
          );
        },
        tooltip: 'Tambah',
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
