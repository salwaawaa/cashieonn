import 'package:cashieonn/Admin/petugas/Edit_Petugas.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data_Petugas extends StatelessWidget {
  const Data_Petugas({Key? key}) : super(key: key);

  Future<void> _deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('petugass')
          .doc(documentId)
          .delete();
      print('Document deleted successfully!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home_admin');
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Petugas",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("petugass")
            .orderBy("name", descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<DocumentSnapshot<Map<String, dynamic>>> data = snapshot
              .data!.docs
              .cast<DocumentSnapshot<Map<String, dynamic>>>();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                data.length,
                (index) {
                  DocumentSnapshot<Map<String, dynamic>> docs = data[index];

                  final name = docs["name"] ?? '';
                  final kataSandi = docs["kata_sandi"] ?? '';

                  final documentId = docs.id;

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'email: $name',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'kata sandi: $kataSandi',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                          'Apakah kamu yakin ingin menghapusnya?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Delete the document and close the dialog
                                            _deleteDocument(documentId);
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Edit_Petugas(
                                      document: docs,
                                      documentId: documentId,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_petugas');
        },
        backgroundColor: Color(0xFF137DA8),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
