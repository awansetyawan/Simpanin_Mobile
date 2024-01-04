import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/agreement.dart';
import 'package:simpanin/models/mailbox.dart';

class StaffMailboxDetailScreen extends StatefulWidget {
  final MailboxModel mailbox;
  const StaffMailboxDetailScreen({super.key, required this.mailbox});

  @override
  State<StaffMailboxDetailScreen> createState() =>
      _StaffMailboxDetailScreenState();
}

class _StaffMailboxDetailScreenState extends State<StaffMailboxDetailScreen> {
  final db = FirebaseFirestore.instance;

  bool loading = false;
  AgreementModel? _agreement;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    try {
      DocumentReference mailboxRef =
          db.collection('mailboxes').doc(widget.mailbox.id);

      QuerySnapshot agreementsQuery = await db
          .collection('agreements')
          .where('mailbox', isEqualTo: mailboxRef)
          .where('status', whereIn: ['active', 'pending']).get();

      if (agreementsQuery.docs.isNotEmpty) {
        AgreementModel agreement =
            await AgreementModel.fromFirestore(agreementsQuery.docs[0]);
        print(agreement.monthlyCost);
        setState(() {
          _agreement = agreement;
        });
        var firstAgreementData = agreementsQuery.docs[0].data();
        print('Data Agreement: $firstAgreementData');
      } else {
        print('Tidak ada data Agreement yang sesuai.');
      }
    } catch (e) {
      print('Error fetching mailboxes: $e');
    }
  }

  void _handleUbah() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        leading: BackButton(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 25.0, right: 30.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.mailbox.code,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                  ListTile(
                    dense: true,
                    leading: Text('Informasi Mailbox',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Harga',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text("${widget.mailbox.formattedPrice}/bln",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Ukuran',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.mailbox.size,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (_agreement != null) ...[
                    ListTile(
                      dense: true,
                      leading: Text('Informasi Pemilik',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('Nama',
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text(_agreement?.user!.name ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('No. HP',
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text(_agreement?.user!.phone ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ListTile(
                      dense: true,
                      leading: Text('Tgl. Pembayaran',
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text(_agreement?.formattedEndDate ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
