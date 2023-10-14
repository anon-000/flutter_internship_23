import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/api_call/api_call_page.dart';
import 'package:flutter_demo/pages/home/home_page.dart';
import 'package:flutter_demo/pages/layout_example/layout_example_page.dart';
import 'package:flutter_demo/pages/login/login_page.dart';
import 'package:flutter_demo/pages/new_page.dart';
import 'package:flutter_demo/pages/next_page.dart';
import 'package:flutter_demo/pages/splash/splash_page.dart';
import 'package:flutter_demo/pages/weather_api/weather_api_page.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
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
      initialRoute: '/layout-page',
      routes: {
        '/layout-page': (context) => const LayoutExamplePage(),
        '/': (context) => const LayoutExamplePage(),
        '/login-page': (context) => const LoginPage(),
        '/home-page': (context) => const HomePage(),
        '/next-page': (context) => const NextPage(),
        '/new-page': (context) => const NewPage(),
        '/api-call-page': (context) => const ApiCallPage(),
        '/weather-api-page': (context) => const WeatherApiPage(),

      },
    );
  }
}
