import 'package:chatkuy/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';

main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString("email");
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false,
        home: email == null ? LoginPage():chatPage(),
      )
  );
}
