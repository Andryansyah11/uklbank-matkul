import 'package:flutter/material.dart';
import 'package:ukl/models/nasabahlogin.dart';
import 'package:ukl/widgets/navbar.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});


  @override
  State<DashboardView> createState() => _DashboardViewState();
}


class _DashboardViewState extends State<DashboardView> {
  Nasabahlogin userLogin = Nasabahlogin();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/update');
              },
              icon: Icon(Icons.person_outlined)),
        ],
      ),
      body: Center(child: Text("Selamat Datang ${userLogin.username}")),
      bottomNavigationBar: BottomNav(0),
    );
  }
}
