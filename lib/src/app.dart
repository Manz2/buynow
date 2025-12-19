import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:buynow/src/login/login_view.dart';
import 'package:buynow/src/login/login.controller.dart';
import 'package:buynow/src/home/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'buynow',
      home: user == null
          ? LoginView(controller: LoginController())
          : const HomeView(),
    );
  }
}
