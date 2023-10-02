import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home_page.dart';
import 'package:flutter_demo/pages/new_page.dart';
import 'package:flutter_demo/pages/next_page.dart';
import 'package:flutter_demo/pages/utils/sharedpreference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferenceHelper.preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/next-page': (context) => NextPage(),
        '/new-page': (context) => NewPage(),
      },
    );
  }
}
