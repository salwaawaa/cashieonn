import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMember extends StatefulWidget {
  final String documentId;

  const EditMember({Key? key, required this.documentId}) : super(key: key);

  @override
  _EditMemberState createState() => _EditMemberState();
}

class _EditMemberState extends State<EditMember> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMemberData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Member"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Member',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan nama member',
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Telepon',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _teleponController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan telepon',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateDataToFirestore(widget.documentId);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchMemberData() async {
    try {
      // Retrieve data for the given document ID
      final snapshot = await FirebaseFirestore.instance
          .collection('member')
          .doc(widget.documentId)
          .get();

      // Update text controllers with fetched data
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _teleponController.text = data['telepon'] ?? '';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching member data: $e');
      }
    }
  }

  Future<void> _updateDataToFirestore(String documentId) async {
    try {
      // Update data in Firestore with the specified document ID
      await FirebaseFirestore.instance
          .collection('member')
          .doc(documentId)
          .update({
        'name': _nameController.text,
        'telepon': _teleponController.text,
        // Add other fields as needed
      });
    } catch (e) {
      // Handle any potential errors here
      if (kDebugMode) {
        print('Error updating data in Firestore: $e');
      }
    }
  }
}
