import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'page/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      storageBucket: 'east-ab750.appspot.com',
      apiKey: 'AIzaSyBMNacnsK-DivngcoGiHkHsqD2uo-GMv08', //current_key
      appId: '1:737687528932:android:35d43af53800ffd4d3d3f1', //mobilesdk_app_id
      messagingSenderId: '737687528932', //project_number
      projectId: 'east-ab750'), //project_id: 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: const CardTheme(surfaceTintColor: Colors.white),
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.white, backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
