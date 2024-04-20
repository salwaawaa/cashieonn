import 'package:cashieonn/Admin/Home/Data_Barang/Data_Barang.dart';
import 'package:cashieonn/Admin/Home/Data_Barang/Tambah_Barang.dart';
import 'package:cashieonn/Admin/Home/Home_Admin.dart';
import 'package:cashieonn/Admin/Login/Login_Admin.dart';
import 'package:cashieonn/Admin/Login/Register.dart';
import 'package:cashieonn/Admin/petugas/Tambah_Petugas.dart';
import 'package:cashieonn/Admin/petugas/petugas.dart';
import 'package:cashieonn/Petugas/Member/Member.dart';
import 'package:cashieonn/Petugas/Member/Tambah_Member.dart';
import 'package:cashieonn/Petugas/Menu/Homescreen.dart';
import 'package:cashieonn/Petugas/Menu/Lihat_Barang.dart';
import 'package:cashieonn/Petugas/Menu/Lihat_Member.dart';
import 'package:cashieonn/Petugas/Transaksi/Transaksi.dart';
import 'package:cashieonn/Petugas/splash/Login.dart';
import 'package:cashieonn/Petugas/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashieon',
      theme: ThemeData(fontFamily: 'poppins'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/tambah_petugas',
      routes: {
        // Petugas
        '/splash': (context) => const Splashscreen(),
        '/login': (context) => const Login(),
        '/home': (context) => const Homescreen(),
        '/lihat_barang': (context) => const Lihat_Barang(),
        '/member': (context) => const Member(),
        '/lihat_member': (context) => const Lihat_Member(),
        '/tambah_member': (context) => const Tambah_Member(),
        '/transaksi': (context) => Transaksi(),

        // Admin
        '/login_admin': (context) => const Login_Admin(),
        '/register': (context) => const Register(),
        '/home_admin': (context) => const Home_Admin(),
        '/data_petugas': (context) => const Data_Petugas(),
        '/tambah_petugas': (context) => const Tambah_Petugas(),
        '/data_barang': (context) => const Data_Barang(),
        '/tambah_barang': (context) => const Tambah_Barang(),

        //struk
        // transaksi
        //riwayat klik transaksi
        //edit petugas
        //edit barang
        //edit member
      },
    );
  }
}

class Edit_Member {}
