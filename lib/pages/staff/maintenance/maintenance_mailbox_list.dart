import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpanin/pages/staff/mailbox/mailbox_create.dart';
import 'package:simpanin/pages/staff/maintenance/maintenance_create.dart';
import 'package:simpanin/pages/user/mailbox/mailbox_detail.dart';
import 'package:simpanin/providers/mailbox_book_provider.dart';
import 'package:simpanin/providers/maintenance_create_provider.dart';

class MaintenanceMailboxListScreen extends StatefulWidget {
  const MaintenanceMailboxListScreen({super.key});

  @override
  State<MaintenanceMailboxListScreen> createState() =>
      _MaintenanceMailboxListScreenState();
}

class _MaintenanceMailboxListScreenState
    extends State<MaintenanceMailboxListScreen> {
  final db = FirebaseFirestore.instance;

  final _scrollController = ScrollController();

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
      resizeToAvoidBottomInset: false,
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
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text("Pilih Mailbox",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 185),
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
                                      onTap: () {
                                        Provider.of<MaintenanceCreateProvider>(
                                                context,
                                                listen: false)
                                            .setMailbox(mailbox);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StaffMaintenanceCreateScreen()),
                                        );
                                      },
                                      leading: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Text(mailbox.code,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                      color: Theme.of(context)
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
    );
  }
}
