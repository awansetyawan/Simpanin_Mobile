import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/components/input_password_component.dart';
import 'package:simpanin/models/user.dart';
// import 'package:simpanin/pages/auth/sign_in/sign_in_first.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpanin/pages/user/user_main.dart';
import 'package:simpanin/providers/user_provider.dart';
import 'package:simpanin/services/auth_service.dart';
import 'package:simpanin/services/user_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  void _handleSubmit() async {
    setState(() {
      loading = true;
    });
    try {
      UserModel user = UserModel(
          address: '',
          id: '',
          email: _emailController.text,
          name: _nameController.text,
          password: _passwordController.text,
          phone: '',
          role: 'user');
      String id = await AuthService.signUp(user);
      UserModel userData = await UserService.getUser(id);
      Provider.of<UserProvider>(context, listen: false).setAuth(user);
      setState(() {
        loading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLogin', true);

      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Login Success, Welcome Back!",
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserMainScreen()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Daftar",
                      style: Theme.of(context).textTheme.displayLarge),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Text("Kamu bisa langsung jadi kawan Simpanin!",
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 210),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(32),
                    topLeft: Radius.circular(32)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Boleh kasih tahu namamu?",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Masukkan emailmu...",
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputPasswordComponent(
                        controller: _passwordController,
                        hintText: 'Password akunmu...',
                      ),
                      const SizedBox(height: 40),
                      ButtonComponent(
                        loading: loading,
                        buttontext: "Daftar",
                        onPressed: _handleSubmit,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah Punya Akun?",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Text("Masuk disini!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                            onTap: () {},
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
