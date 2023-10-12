import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:lottie/lottie.dart';

///
/// Created by Auro on 06/10/23 at 9:57 PM
///

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkForUser();
  }

  checkForUser() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2)).then((value) {

        Navigator.pushNamed(
          context,
          '/home-page',
        );

        // final user = SharedPreferenceHelper.user;
        // if (user == null) {
        //   Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     '/login-page',
        //     (r) => false,
        //   );
        // } else {
        //   Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     '/home-page',
        //     (r) => false,
        //   );
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...[1, 2, 3].map((e) => Text("Hi_> $e")),
          Lottie.asset('assets/icons/animation.json'),
          const Text(
            "TODO APP",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
