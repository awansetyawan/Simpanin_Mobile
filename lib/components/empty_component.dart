import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EmptyComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyComponent(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Theme.of(context).colorScheme.primary,),
          const SizedBox(height: 10,),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium),
          Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    );
  }
}
