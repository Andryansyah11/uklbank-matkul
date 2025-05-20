import 'package:flutter/material.dart';
import 'package:ukl/models/matkul.dart';
import 'package:ukl/views/dasboard.dart';
import 'package:ukl/views/login_view.dart';
import 'package:ukl/views/matkul_view.dart';
import 'package:ukl/views/register_view.dart';
import 'package:ukl/views/updateprofilview.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'bankbelibawank',
    initialRoute: '/login',
    routes: {
      '/register': (context) => RegisterView(),
      '/login': (context) => LoginView(),
      '/dashboard': (context) => DashboardView(),
      '/update': (context) => UpdateProfilView(),
      '/matkul': (context) => MatkulViewPage(),
    },
  ));
}
