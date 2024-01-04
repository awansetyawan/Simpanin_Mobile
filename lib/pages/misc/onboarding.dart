import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simpanin/pages/auth/log_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _handleFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirst', false);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogInScreen()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Daftar',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onFinish: _handleFinish,
        skipTextButton: const Text('Lewati'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogInScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(
              'Masuk',
              style: TextStyle(
                color: Color(0xFFF16807),
                fontSize: 16,
                
              ),
            ),
          ),
        ),
        controllerColor: Theme.of(context).colorScheme.primary,
        background: [
          Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: SvgPicture.asset('assets/svg/onboarding_1.svg',
                      height: 280),
                ),
              )),
          Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: SvgPicture.asset('assets/svg/onboarding_2.svg',
                      height: 280),
                ),
              )),
          Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: SvgPicture.asset('assets/svg/onboarding_3.svg',
                      height: 280),
                ),
              )),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 400,
                ),
                Text('Hey, Kawan Simpanin!', style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 38)),
                const SizedBox(height: 10,),
                Text('Simpan barang berhargamu aman tanpa makan tempat, yuk!', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 400,
                ),
                Text('Tempat Penuh? Kenalin Mailbox', style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 38)),
                const SizedBox(height: 10,),
                Text('Mailbox Simpanin jadi solusi jaga barang kamu mulai dari yang kecil hingga besar, santai...', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 400,
                ),
                Text('Aman, gak? Jelas, dong!', style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 38)),
                const SizedBox(height: 10,),
                Text('Staff kami profesional dan pengamanan PIN elektrik di setiap mailbox-mu!', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
