import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/components/empty_component.dart';
import 'package:simpanin/models/payment.dart';
import 'package:simpanin/models/user.dart';
import 'package:simpanin/pages/profile/profile.dart';
import 'package:simpanin/pages/staff/maintenance/maintenance_create.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpanin/models/maintenance.dart';
import 'package:simpanin/pages/staff/maintenance/maintenance_mailbox_list.dart';
import 'package:simpanin/pages/staff/payment/payment_create.dart';
import 'package:simpanin/providers/user_provider.dart';

class StaffPaymentListScreen extends StatefulWidget {
  const StaffPaymentListScreen({super.key});

  @override
  State<StaffPaymentListScreen> createState() => _StaffPaymentListScreenState();
}

// class task
class _StaffPaymentListScreenState extends State<StaffPaymentListScreen> {
  final _scrollController = ScrollController();
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  void _clickBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: const Icon(Iconsax.edit),
                title:
                    Text("Ubah", style: Theme.of(context).textTheme.titleLarge),
              ),
              Divider(height: 2),
              ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: const Icon(Iconsax.trash),
                title: Text("Hapus",
                    style: Theme.of(context).textTheme.titleLarge),
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
      body: SingleChildScrollView(
        controller: _scrollController,
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 100),
              child: Text("Pembayaran",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('payments')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? snapshot.data!.docs.isEmpty
                                    ? const EmptyComponent(
                                        icon: Iconsax.box,
                                        title: "Kosong, ya...",
                                        subtitle:
                                            "Jangan lupa untuk selalu bayar mailboxmu") : SizedBox(
                          height: 100,
                          child: ListView(
                            children: snapshot.data!.docs.map((doc) {
                              return FutureBuilder(
                                  future: Future.wait<dynamic>([
                                    doc['agreement'].get(),
                                    doc['mailbox'].get()
                                  ]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('');
                                    }
                                    final payment = PaymentModel.fromFuture(doc,
                                        snapshot.data![0], snapshot.data![1]);
                                    return FutureBuilder(
                                        future: Future.wait<dynamic>([
                                          snapshot.data![0]['user'].get(),
                                        ]),
                                        builder: (BuildContext ctx,
                                            AsyncSnapshot<List<dynamic>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Text('');
                                          }
                                          final user = UserModel.fromFirestore(
                                              snapshot.data![0]);
                                          return ListTile(
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
                                                child: Text(
                                                    payment.mailbox.code,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium
                                                        ?.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary)),
                                              ),
                                            ),
                                            title: Text(user.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            subtitle: Text(
                                                payment.formattedDate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Colors.grey)),
                                          );
                                        });
                                  });
                            }).toList(),
                          ),
                        )
                      : (const Center(
                          child: CircularProgressIndicator(),
                        ));
                },
              ),
            ),
          ],
        ),
      ),
      // FloatingActionButton dengan label "Tambah"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const StaffPaymentCreateScreen()),
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
