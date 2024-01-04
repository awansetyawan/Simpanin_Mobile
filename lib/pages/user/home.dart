import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/components/empty_component.dart';
import 'package:simpanin/models/agreement.dart';
import 'package:simpanin/models/maintenance.dart';
import 'package:simpanin/models/user.dart';
import 'package:simpanin/pages/user/agreement/agreement_detail.dart';
import 'package:simpanin/pages/user/maintenance/maintenance_list.dart';
import 'package:simpanin/providers/theme_mode_provider.dart';
import 'package:simpanin/providers/user_provider.dart';

class MailboxTile extends StatelessWidget {
  AgreementModel agreement;
  MailboxTile({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 190,
      margin: const EdgeInsets.only(right: 20),
      child: Card(
          color: Theme.of(context).colorScheme.tertiary,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.background,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserAgreementDetailScreen(agreement: agreement,)),
              );
            },
            child: SizedBox(
              width: 260,
              height: 190,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agreement.mailbox.code,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(
                      '${agreement.mailbox.formattedPrice}/bln',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(.7),
                              fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ukuran",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(.6)),
                            ),
                            Text(
                              agreement.mailbox.size,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Tgl. Pemb.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(.6)),
                            ),
                            Text(
                              agreement.formattedEndDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final db = FirebaseFirestore.instance;
  bool _loading = true;
  final List<DocumentReference> _mailboxes = [];
  List<MaintenanceModel> _maintenances = [];
  List<AgreementModel> _agreements = [];
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    List<AgreementModel> agreements = await fetchAgreements();
    List<MaintenanceModel> maintenances = await fetchMaintenances();
    setState(() {
      _loading = false;
      _agreements = agreements;
      _maintenances = maintenances;
    });
  }

  Future<List<AgreementModel>> fetchAgreements() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      DocumentReference<Map<String, dynamic>> userRef =
          db.collection('users').doc(user.id);
      QuerySnapshot mailboxQuery = await db
          .collection('agreements')
          .where('user', isEqualTo: userRef)
          .where('status', whereIn: ['active', 'pending']).get();
      List<AgreementModel> mailboxes =
          await Future.wait(mailboxQuery.docs.map((doc) async {
        _mailboxes.add(doc['mailbox']);
        AgreementModel agreement = await AgreementModel.fromFirestore(doc);
        return agreement;
      }));
      return mailboxes;
    } catch (e) {
      print('Error fetching mailboxes: $e');
      return [];
    }
  }

  Future<List<MaintenanceModel>> fetchMaintenances() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      DocumentReference<Map<String, dynamic>> userRef =
          db.collection('users').doc(user.id);
      QuerySnapshot maintenanceQuery = await db
          .collection('maintenance')
          .where('mailbox', whereIn: _mailboxes)
          .limit(6)
          .get();
      List<MaintenanceModel> maintenances =
          await Future.wait(maintenanceQuery.docs.map((doc) async {
        MaintenanceModel maintenanance =
            await MaintenanceModel.fromFirestore(doc);
        return maintenanance;
      }));
      return maintenances;
    } catch (e) {
      print('Error fetching maintenances: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ThemeModeProvider>(builder: (context, userData, themeData, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Image.asset(themeData.isDarkModeActive ? 'assets/img/logo_full_putih.png' : 'assets/img/logo_full.png', height: 60),
          actions: [
            Chip(
              padding: const EdgeInsets.all(5),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              label: Text("Hi, ${userData.user.name}",
                  style: const TextStyle(color: Colors.white)), //Text
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: SingleChildScrollView(
          child: _loading
              ? Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            "Mailboxmu",
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 190,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _agreements.isNotEmpty
                          ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: _agreements
                                  .map((agreement) => MailboxTile(
                                        agreement: agreement,
                                      ))
                                  .toList(),
                            )
                          : (Container(
                              width: 260,
                              height: 190,
                              margin: const EdgeInsets.only(right: 20),
                              child: Card(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: SizedBox(
                                    width: 260,
                                    height: 190,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.box,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Kuy, temukan mailbox yang cocok dengan kebutuhanmu",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(fontSize: 14),
                                            )
                                          ]),
                                    ),
                                  )),
                            )),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Maintenance",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              if (_agreements.isNotEmpty) ...[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserMaintenanceListScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Lihat Semua",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_agreements.isNotEmpty && _maintenances.isNotEmpty) ...[
                      ..._maintenances.map((maintenance) => ListTile(
                            leading: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Iconsax.like_1,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                            ),
                            isThreeLine: true,
                            title: Text(maintenance.mailbox.code,
                                style: Theme.of(context).textTheme.titleLarge),
                            subtitle: Text(maintenance.note,
                                style: Theme.of(context).textTheme.bodyLarge),
                            trailing: Text(
                                "${maintenance.formattedStartDate} ~ ${maintenance.formattedEndDate}",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ))
                    ] else ...[
                      EmptyComponent(
                          icon: Iconsax.smileys,
                          title: "Lapor! Semua aman!",
                          subtitle: "Tidak ada maintenance untuk mailbox mu")
                    ]
                  ],
                ),
        ),
      );
    });
  }
}
