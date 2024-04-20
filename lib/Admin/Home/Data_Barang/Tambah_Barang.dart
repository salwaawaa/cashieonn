import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tambah_Barang extends StatefulWidget {
  const Tambah_Barang({Key? key}) : super(key: key);

  @override
  _Tambah_BarangState createState() => _Tambah_BarangState();
}

class _Tambah_BarangState extends State<Tambah_Barang> {
  final TextEditingController _nama_barangController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  @override
  void dispose() {
    _nama_barangController.dispose();
    _jumlahController.dispose();
    _hargaController.dispose();

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
                  "Tambah barang",
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
                const SizedBox(
                    height: 15), // Added space between the text fields
                const Text(
                  'nama barang',
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
                    controller: _nama_barangController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'masukkan nama barang',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'jumlah',
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
                    controller: _jumlahController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'masukkan jumlah',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'harga',
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
                    controller: _hargaController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'masukkan harga',
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
                Navigator.pushNamed(context, '/data_barang');
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
      await FirebaseFirestore.instance.collection('data_barang').add({
        'index': newIndex,
        'nama_barang': _nama_barangController.text,
        'jumlah': _jumlahController.text,
        'harga': _hargaController.text,
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
        .collection('data_barang')
        .orderBy('index', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the maximum 'index' value
      final maxIndex = querySnapshot.docs.first['index'] as int;
      return maxIndex;
    } else {
      // If there are no documents, start with index 1
      return 0;
    }
  }
}
