import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:simpanin/models/user.dart';
import 'package:simpanin/pages/auth/log_in.dart';
import 'package:simpanin/pages/profile/profile.dart';
import 'package:simpanin/pages/profile/profile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpanin/pages/profile/profile_faq.dart';
import 'package:simpanin/pages/staff/master/master_user.dart';
import 'package:simpanin/providers/theme_mode_provider.dart';
import 'package:simpanin/providers/user_provider.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  _MasterScreenState createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();

  void _handleLogout() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Ingin logout akunmu?',
        title: 'Yakin?',
        confirmBtnText: 'Ya',
        cancelBtnText: 'Nggak',
        confirmBtnColor: Theme.of(context).colorScheme.primary,
        onConfirmBtnTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('isLogin');
          prefs.remove('auth');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LogInScreen()),
              (Route<dynamic> route) => false);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userData, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 80),
                child: Text("More",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(height: 35),
              Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 260),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32)),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()),
                          );
                        },
                        leading: Icon(
                          Iconsax.profile_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        title: Text("Profil",
                            style: Theme.of(context).textTheme.titleMedium),
                        subtitle: Text("informasi tentang anda",
                            style: Theme.of(context).textTheme.bodyLarge),
                        trailing: Icon(
                          Iconsax.arrow_right,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 22,
                        ),
                      ),
                      const Divider(
                        height: 10,
                        thickness: 0.8,
                        indent: 65,
                        endIndent: 25,
                        color: Color.fromARGB(96, 72, 72, 72),
                      ),
                      ListTile(
                        leading: Icon(
                          Iconsax.user_tag,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        title: Text("Users",
                            style: Theme.of(context).textTheme.titleMedium),
                        subtitle: Text("Semua tentang user",
                            style: Theme.of(context).textTheme.bodyLarge),
                        trailing: Icon(
                          Iconsax.arrow_right,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 22,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MasterUserListScreen()),
                          );
                        },
                      ),
                      const Divider(
                        height: 10,
                        thickness: 0.8,
                        indent: 65,
                        endIndent: 25,
                        color: Color.fromARGB(96, 72, 72, 72),
                      ),
                      ListTile(
                        onTap: _handleLogout,
                        leading: Icon(
                          Iconsax.logout_1,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        title: Text("Keluar",
                            style: Theme.of(context).textTheme.titleMedium),
                        subtitle: Text("Sampai jumpa di lain waktu...",
                            style: Theme.of(context).textTheme.bodyLarge),
                        trailing: Icon(
                          Iconsax.arrow_right,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 22,
                        ),
                      ),
                      const Divider(
                        height: 10,
                        thickness: 0.8,
                        indent: 65,
                        endIndent: 25,
                        color: Color.fromARGB(96, 72, 72, 72),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
