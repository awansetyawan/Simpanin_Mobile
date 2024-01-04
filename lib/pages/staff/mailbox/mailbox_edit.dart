import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/pages/staff/mailbox/mailbox_list.dart';
import 'package:simpanin/pages/staff/staff_main.dart';
import 'package:simpanin/providers/page_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StaffMailboxEditScreen extends StatefulWidget {
  final MailboxModel mailbox;

  const StaffMailboxEditScreen({super.key, required this.mailbox});

  @override
  State<StaffMailboxEditScreen> createState() => _StaffMailboxEditScreenState();
}

class _StaffMailboxEditScreenState extends State<StaffMailboxEditScreen> {
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  List<String> ukuran = ['1x1', '2x2', '2x1', '4x4'];
  String? _selectedUkuran;

  static final db = FirebaseFirestore.instance;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _handleUbah() async {
    setState(() {
      loading = true;
    });

    try {
      db.collection("mailboxes").doc(widget.mailbox.id).update({
        'code': _kodeController.text,
        'price': int.parse(_hargaController.text),
        'size': _selectedUkuran,
      }).then((mailboxesRef) async {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Mailbox Berhasil Diubah!",
          ),
        );
        Provider.of<PageProvider>(context, listen: false).changePage(1);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StaffMainScreen()),
        );
      });
    } catch (e) {
      print(e);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Terjadi Kesalahan!",
        ),
      );
    }
  }

  void _init() async {
    _kodeController.text = widget.mailbox.code;
    _hargaController.text = widget.mailbox.price.toString();
    _selectedUkuran = widget.mailbox.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          leading: BackButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Provider.of<PageProvider>(context, listen: false).changePage(1);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StaffMainScreen()),
              );
            },
          )),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
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
                  'Ubah \nMailbox',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                children: [
                  const SizedBox(height: 30),
                  TextField(
                    controller: _kodeController,
                    decoration: const InputDecoration(
                      labelText: 'Kode',
                      hintText: "Masukkan Kode",
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _hargaController,
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      hintText: "Masukkan Harga",
                    ),
                  ),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: _selectedUkuran,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUkuran = newValue;
                      });
                    },
                    items: ukuran.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Ukuran',
                    ),
                    isExpanded: true,
                  ),
                  const SizedBox(height: 40),
                  ButtonComponent(
                    loading: loading,
                    buttontext: "Ubah",
                    onPressed: _handleUbah,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
