import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simpanin/components/button_component.dart';
import 'package:simpanin/models/mailbox.dart';
import 'package:simpanin/pages/staff/mailbox/mailbox_list.dart';
import 'package:simpanin/pages/staff/maintenance/maintenance_list.dart';
import 'package:simpanin/pages/staff/staff_main.dart';
import 'package:simpanin/providers/maintenance_create_provider.dart';
import 'package:simpanin/providers/page_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StaffMaintenanceCreateScreen extends StatefulWidget {
  @override
  _StaffMaintenanceCreateScreenState createState() =>
      _StaffMaintenanceCreateScreenState();
}

class _StaffMaintenanceCreateScreenState
    extends State<StaffMaintenanceCreateScreen> {
  final _scrollController = ScrollController();
  DateTime _tanggalMulai = DateTime.now();
  DateTime _tanggalSelesai = DateTime.now();
  TextEditingController _noteController = TextEditingController();
  


    static final db = FirebaseFirestore.instance;

  Future<void> _pilihTanggal(BuildContext context, bool isTanggalMulai) async {
    DateTime? tanggalTerpilih = await showDatePicker(
      context: context,
      initialDate: isTanggalMulai ? _tanggalMulai : _tanggalSelesai,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (tanggalTerpilih != null &&
        tanggalTerpilih != (isTanggalMulai ? _tanggalMulai : _tanggalSelesai)) {
      setState(() {
        isTanggalMulai
            ? _tanggalMulai = tanggalTerpilih
            : _tanggalSelesai = tanggalTerpilih;
      });
    }
  }

  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _tanggalMulai = DateTime.now();
    _tanggalSelesai = DateTime.now();
  }

  void _handleSubmit() async {
    setState(() {
      loading = true;
    });
    MailboxModel mailbox =
                Provider.of<MaintenanceCreateProvider>(context, listen: false)
                    .maintenance.mailbox;
    DocumentReference mailboxRef =
                db.collection('mailboxes').doc(mailbox.id);

    try {
      db.collection("maintenance").add({
        'start_date': _tanggalMulai,
        'end_date': _tanggalSelesai,
        'note': _noteController.text,
        'mailbox': mailboxRef,
      }).then((maintenanceRef) async {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Maintenance ${mailbox.code} Berhasil Ditambah!",
          ),
        );
        Provider.of<PageProvider>(context, listen: false).changePage(2);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          leading: BackButton(
            color: Theme.of(context).colorScheme.primary,
          )),
      body: SingleChildScrollView(
        controller: _scrollController,
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child:BackButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Provider.of<PageProvider>(context, listen: false).changePage(2);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StaffMainScreen()),
              );
            },
          )
            ),
            
            ListTile(
              title: Text(
                "Tambah\nMaintenance",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                    ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 210,
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(32),
                  topLeft: Radius.circular(32),
                ),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  // Tanggal Mulai
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'Tanggal Mulai    :',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    title: ElevatedButton(
                      onPressed: () => _pilihTanggal(context, true),
                      child:
                          Text(DateFormat('dd-MM-yyyy').format(_tanggalMulai)),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tanggal Selesai
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'Tanggal Selesai :',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    title: ElevatedButton(
                      onPressed: () => _pilihTanggal(context, false),
                      child: Text(
                          DateFormat('dd-MM-yyyy').format(_tanggalSelesai)),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Catatan
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'Catatan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: TextField(
                      controller: _noteController,
                      maxLines:
                          3, // Atau berikan nilai lebih dari 1 sesuai kebutuhan
                      decoration: InputDecoration(labelText: 'Catatan'),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Divider(
                    height: 0,
                    thickness: 0.8,
                    indent: 0,
                    endIndent: 0,
                    color: Color.fromARGB(96, 72, 72, 72),
                  ),
                  SizedBox(height: 16),

                  // Tombol Selesai
                  ButtonComponent(
                    loading: loading,
                    buttontext: "Selesai",
                    onPressed: () {
                      // Mengecek apakah ada input yang kosong
                      if (
                          _noteController.text.isEmpty) {
                        // Menampilkan pesan peringatan jika ada input yang kosong
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Peringatan'),
                            content: Text(
                              'Semua input harus diisi.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 241, 7, 7),
                                    fontSize: 18,
                                  ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'OK',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 241, 7, 7),
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        _handleSubmit();
                        
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
