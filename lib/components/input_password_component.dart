import 'package:flutter/material.dart';

class InputPasswordComponent extends StatefulWidget {
  String hintText;
  TextEditingController controller;
  InputPasswordComponent({super.key, this.hintText = 'Password', required this.controller});

  @override
  State<InputPasswordComponent> createState() => _InputPasswordComponentState();
}

class _InputPasswordComponentState extends State<InputPasswordComponent> {

  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: widget.controller,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
        hintText: widget.hintText,
        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }
}
