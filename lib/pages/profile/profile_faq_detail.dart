import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simpanin/components/button_component.dart';

class ProfileFaqDetailScreen extends StatefulWidget {
  final String title;
  final String content;
  const ProfileFaqDetailScreen({super.key, required this.title, required this.content});

  @override
  State<ProfileFaqDetailScreen> createState() => _ProfileFaqDetailScreenState();
}

class _ProfileFaqDetailScreenState extends State<ProfileFaqDetailScreen> {
  bool loading = false;

  void _handleUbah() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          leading: BackButton(
            color: Colors.white,
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 24),
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(widget.content,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
