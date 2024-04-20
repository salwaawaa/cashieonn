import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Edit_Petugas extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> document;
  final String documentId;

  const Edit_Petugas(
      {Key? key, required this.document, required this.documentId})
      : super(key: key);

  @override
  _EditPetugasState createState() => _EditPetugasState();
}

class _EditPetugasState extends State<Edit_Petugas> {
  TextEditingController namaController = TextEditingController();
  TextEditingController kata_sandiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    final data = widget.document.data() as Map<String, dynamic>;

    namaController.text = data['nama'];
    kata_sandiController.text = data['kata_sandi'];
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    namaController.dispose();
    kata_sandiController.dispose();
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
                Text(
                  'nama Petugas',
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
                    controller: namaController,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'masukkan nama petugas',
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
            Text(
              'kata sandi',
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
                controller: kata_sandiController,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'masukkan kata sandi',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                ),
              ),
            ),
            Container(
              width: 400,
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 234, 90, 5),
                ),
                onPressed: () {
                  // Call the function to update data in Firestore
                  updatePetugasData();
                },
                child: Text(
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

  // Function to update data in Firestore
  void updatePetugasData() async {
    try {
      // Get the data from the text fields
      String nama = namaController.text;
      String kata_sandi = kata_sandiController.text;

      // Update the data in Firestore
      await FirebaseFirestore.instance
          .collection('petugass')
          .doc(widget.document.id) // Use document ID from widget
          .update({
        'nama': nama,
        'kata_sandi': kata_sandi,
        // Add other fields as needed
      });

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle any potential errors here
      print('Error updating data: $e');
      // Show a snackbar or dialog to indicate the error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update data. Please try again.'),
        ),
      );
    }
  }
}
