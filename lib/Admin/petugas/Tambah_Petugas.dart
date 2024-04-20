import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tambah_Petugas extends StatefulWidget {
  const Tambah_Petugas({Key? key}) : super(key: key);

  @override
  _Tambah_PetugasState createState() => _Tambah_PetugasState();
}

class _Tambah_PetugasState extends State<Tambah_Petugas> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kata_sandiController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _kata_sandiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/data_petugas');
                },
                icon: const Icon(Icons.arrow_back)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tambah Petugas",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const Text(
                  'email',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    border: Border.all(color: Colors.black45, width: 1.0),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'masukkan email',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'kata sandi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    border: Border.all(color: Colors.black45, width: 1.0),
                  ),
                  child: TextField(
                    controller: _kata_sandiController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'masukkan kata sandi',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 450),
            InkWell(
              onTap: () {
                _addDataToFirestore();
                Navigator.pushNamed(context, '/data_petugas');
              },
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF137DA8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Simpan',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addDataToFirestore() async {
    try {
      // Get the current maximum 'index' value from Firestore
      final maxIndex = await _getMaxIndex();

      // Increment the maximum index value by 1
      final newIndex = maxIndex + 1;

      // Add data to Firestore with the incremented 'index' value
      await FirebaseFirestore.instance.collection('petugass').add({
        'index': newIndex,
        'name': _nameController.text,
        'kata_sandi': _kata_sandiController.text,
        // Add other fields as needed
      });
    } catch (e) {
      // Handle any potential errors here
      if (kDebugMode) {
        print('Error adding data to Firestore: $e');
      }
    }
  }

  // Function to get the current maximum 'index' value from Firestore
  Future<int> _getMaxIndex() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('petugass')
        .orderBy('index', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final maxIndex = querySnapshot.docs.first['index'] as int;
      return maxIndex;
    } else {
      return 0;
    }
  }
}
