import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/models/agreement.dart';
import 'package:simpanin/models/user.dart';
import 'package:simpanin/pages/staff/agreement/agreement_book.dart';
import 'package:simpanin/providers/theme_mode_provider.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(builder: (context, themeData, child) {
      return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        scrolledUnderElevation: 0,
        title: Image.asset(themeData.isDarkModeActive ? 'assets/img/logo_full_putih.png' : 'assets/img/logo_full.png', height: 60),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Booking",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection("agreements")
                  .where("status", isEqualTo: "pending")
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          children: snapshot.data!.docs.map((doc) {
                            return FutureBuilder(
                                future: Future.wait<dynamic>([
                                  doc['mailbox'].get(),
                                ]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('');
                                  }
                                  final agreement = AgreementModel.fromFuture(
                                      doc, snapshot.data![0]);
                                  return FutureBuilder(
                                      future: Future.wait<dynamic>([
                                        doc['user'].get(),
                                      ]),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<List<dynamic>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text('');
                                        }
                                        agreement.user = UserModel.fromFirestore(
                                            snapshot.data![0]);
                                        
                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffAgreementBookScreen(
                                                          agreement: agreement)),
                                            );
                                          },
                                          leading: Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Text(
                                                  agreement.mailbox.code,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium
                                                      ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary)),
                                            ),
                                          ),
                                          title: Text(agreement.user!.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge),
                                          subtitle: Text(
                                              agreement.formattedStartDate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          trailing: Icon(
                                            Iconsax.arrow_right,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 22,
                                          ),
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
          ],
        ),
      ),
    );
    });
  }
}
