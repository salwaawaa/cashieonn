import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMember extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> document;
  final String documentId;

  const EditMember({
    Key? key,
    required this.document,
    required this.documentId,
  }) : super(key: key);

  @override
  _EditMemberState createState() => _EditMemberState();
}

class _EditMemberState extends State<EditMember> {
  TextEditingController nameController = TextEditingController();
  TextEditingController teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = widget.document.data() as Map<String, dynamic>;

    nameController.text = data['name'];
    teleponController.text = data['telepon'];
  }

  @override
  void dispose() {
    nameController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Petugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Nama Petugas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan nama petugas',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Kata Sandi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(255, 255, 255, 1),
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: TextField(
                controller: teleponController,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Masukkan kata sandi',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF137DA8),
                ),
                onPressed: () {
                  updatePetugasData();
                  Navigator.pushNamed(context, '/member');
                },
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePetugasData() async {
    try {
      String name = nameController.text;
      String telepon = teleponController.text;

      await FirebaseFirestore.instance
          .collection('member')
          .doc(widget.document.id)
          .update({
        'name': name,
        'telepon': telepon,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diperbarui')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data: $error')),
      );
    }
  }
}
