import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/pages/user/mailbox/mailbox_book.dart';
import 'package:simpanin/providers/mailbox_book_provider.dart';

class UserMailboxDetailScreen extends StatefulWidget {
  final MailboxModel mailbox;
  UserMailboxDetailScreen({super.key, required this.mailbox});

  @override
  State<UserMailboxDetailScreen> createState() =>
      _UserMailboxDetailScreenState();
}

class _UserMailboxDetailScreenState extends State<UserMailboxDetailScreen> {
  bool loading = false;

  void _handleMailboxBook() async {
    Provider.of<MailboxBookProvider>(context, listen: false)
        .changeMailbox(mailbox: widget.mailbox);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserMailboxBookScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          leading: const BackButton(
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
                  widget.mailbox.code,
                  style: Theme.of(context).textTheme.displayLarge,
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
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(32),
                    topLeft: Radius.circular(32)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Informasi Mailbox",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Harga',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text("${widget.mailbox.formattedPrice}/bln",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Ukuran',
                        style: Theme.of(context).textTheme.titleMedium),
                    trailing: Text(widget.mailbox.size,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            ),
          ),
          ButtonComponent(
            loading: loading,
            buttontext: "Booking Mailbox",
            onPressed: _handleMailboxBook,
          ),
        ],
      ),
    );
  }
}
