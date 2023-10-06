import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/user.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
/// Created by Auro on 06/10/23 at 10:28 PM
///

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 60),
          SvgPicture.asset("assets/icons/demo.svg"),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "User name",
            ),
            onChanged: (c) {
              setState(() {
                name = c;
              });
            },
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
            onChanged: (c) {
              setState(() {
                password = c;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: name.isEmpty || password.isEmpty
                ? null
                : () {
                    final user = User(
                      name: name,
                      password: password,
                      gender: "Male",
                    );
                    log("===>>> ${userToJson(user)}");
                    if (user.name == "auro" && user.password == "Auro@123") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login successful'),
                        ),
                      );
                      SharedPreferenceHelper.storeUser(user);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home-page',
                        (r) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid user name or password'),
                        ),
                      );
                    }
                  },
            child: const Text("Login"),
          )
        ],
      ),
    );
  }
}
