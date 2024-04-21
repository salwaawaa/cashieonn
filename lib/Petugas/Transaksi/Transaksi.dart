import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaksi extends StatefulWidget {
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  String _selectedItem = ''; // Barang default yang dipilih
  int _quantity = 1;
  List<String> _barangList = []; // Daftar nama barang
  List<Map<String, dynamic>> _transaksiList =
      []; // List untuk menyimpan transaksi
  String _selectedMember = ''; // Member default yang dipilih
  List<String> _memberList = []; // Daftar nama member
  bool _isNonMemberSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchBarangList();
    _fetchMemberList();
  }

  Future<void> _fetchBarangList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('data_barang').get();
      List<String> barangList = [];
      querySnapshot.docs.forEach((doc) {
        barangList.add(doc['nama_barang']);
      });
      setState(() {
        _barangList = barangList;
        _selectedItem = barangList.isNotEmpty ? barangList[0] : '';
      });
    } catch (e) {
      print('Error fetching barang: $e');
    }
  }
  

  Future<void> _fetchMemberList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('member').get();
      List<String> memberList = [];
      querySnapshot.docs.forEach((doc) {
        memberList.add(doc['name']);
      });
      setState(() {
        _memberList = memberList;
        _selectedMember = memberList.isNotEmpty ? memberList[0] : '';
      });
    } catch (e) {
      print('Error fetching member: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: const Color(0xFF137DA8)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                hintText: 'Pilih Barang',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
              value: _selectedItem,
              onChanged: (newValue) {
                setState(() {
                  _selectedItem = newValue!;
                });
              },
              items: _barangList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Jumlah:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) {
                            _quantity--;
                          }
                        });
                      },
                      child: Icon(
                        Icons.remove,
                        color: const Color(0xFF137DA8),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('$_quantity'),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: const Color(0xFF137DA8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Tambahkan transaksi ke list
                _transaksiList.add({
                  'nama_barang': _selectedItem,
                  'jumlah': _quantity,
                });
                // Reset pilihan barang dan jumlah
                _selectedItem = _barangList.isNotEmpty ? _barangList[0] : '';
                _quantity = 1;
                setState(() {});
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF137DA8),
                minimumSize: Size(500, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Tambah',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _transaksiList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var transaksi = _transaksiList[index];
                        return ListTile(
                          title: Text(transaksi['nama_barang']),
                          subtitle: Text('Jumlah: ${transaksi['jumlah']}'),
                          trailing: Text('Rp. ${transaksi['harga'] ?? ''}'),
                        );
                      },
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Harga:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Diskon:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Bayar:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isNonMemberSelected = false;
                                });
                              },
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedMember,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedMember = newValue!;
                                      _isNonMemberSelected = false;
                                    });
                                  },
                                  items: _memberList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isNonMemberSelected = true;
                                });
                              },
                              child: Text(
                                'Non-Member',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 55),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  _isNonMemberSelected
                                      ? const Color(0xFF137DA8)
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Tunai',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: IgnorePointer(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(text: '0'),
                                decoration: InputDecoration(
                                  labelText: 'Kembalian',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk menyimpan transaksi
                      // Misalnya, simpan ke database atau lakukan operasi lainnya
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF137DA8),
                      minimumSize: Size(500, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
