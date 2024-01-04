import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpanin/pages/user/mailbox/mailbox_detail.dart';

class UserMailboxListScreen extends StatefulWidget {
  const UserMailboxListScreen({super.key});

  @override
  State<UserMailboxListScreen> createState() => _UserMailboxListScreenState();
}

class _UserMailboxListScreenState extends State<UserMailboxListScreen> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('mailboxes')
            .where("availability", isEqualTo: true)
            .where("is_active", isEqualTo: true)
            .orderBy("code")
            .snapshots(),
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 60.0, left: 30.0, right: 30.0, bottom: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Mailbox',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 30,
                    ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32)),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: snapshot.hasData
                      ? ListView(
                          children: snapshot.data!.docs.map((doc) {
                            MailboxModel mailbox =
                                MailboxModel.fromFirestore(doc);
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserMailboxDetailScreen(
                                                  mailbox: mailbox)),
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 28,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      : (const Center(
                          child: CircularProgressIndicator(),
                        )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
