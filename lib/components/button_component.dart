import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const buttonComponentDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
);

class ButtonSecondaryComponent extends StatelessWidget {
  final String buttontext;
  final BoxDecoration buttonDecoration;
  var onPressed;

  // ignore: use_key_in_widget_constructors
  ButtonSecondaryComponent({
    required this.buttontext,
    required this.onPressed,
    this.buttonDecoration = buttonComponentDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: buttonDecoration.copyWith(color: const Color(0xFFE6E6E6)),
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Center(
          child: Text(
            buttontext,
            style: const TextStyle(
                fontSize: 21.0,
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonComponent extends StatelessWidget {
  final String buttontext;
  final BoxDecoration buttonDecoration;
  final bool loading;
  var onPressed;

  // ignore: use_key_in_widget_constructors
  ButtonComponent({
    required this.buttontext,
    required this.onPressed,
    this.loading = false,
    this.buttonDecoration = buttonComponentDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          )),
          TextButton(
            onPressed: onPressed,
            child: Container(
              width: double.infinity,
              decoration: buttonDecoration,
              height: 50,
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Center(
                child: loading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 35,
                      )
                    : Text(
                        buttontext,
                        style: const TextStyle(
                            fontSize: 21.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
