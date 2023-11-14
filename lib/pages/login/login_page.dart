import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/authentication.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

///
/// Created by Auro on 06/10/23 at 10:28 PM
///

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool loading = false;

  Future<void> handleLogin() async {
    try {
      setState(() {
        loading = true;
      });
      final encoding = Encoding.getByName('utf-8');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "email": email,
        "password": password,
        "deviceId": "sdlfusfefsmnfsfsd",
        "deviceType": 1,
        "deviceName": "Realerme",
        "fcmId": "woiruwejlkfnslkfjsdf",
        "role": 3,
        "strategy": "local",
      };
      String jsonBody = json.encode(body);

      log("body: $body");

      final response = await http.post(
        Uri.parse(
          "https://api.dev.thepatchupindia.in/v1/authenticate",
        ),
        body: jsonBody,
        headers: headers,
        encoding: encoding,
      );

      log("LOGIN API CALL RESPONSE : ${response.body}");

      setState(() {
        loading = false;
      });

      if (response.statusCode == 201) {
        /// show success msg
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged In successfully")));

        final parsedResponse =
            AuthenticationDatum.fromJson(jsonDecode(response.body));

        /// Save authentication information to local storage
        SharedPreferenceHelper.storeAuthenticationData(parsedResponse);

        /// GO TO HOME PAGE
        Navigator.pushNamed(
          context,
          '/dashboard-page',
        );
      } else {
        throw "${jsonDecode(response.body)['message']}";
      }
    } catch (err) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 60),
          SvgPicture.asset("assets/icons/demo.svg"),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Login Page",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Email",
            ),
            onChanged: (c) {
              setState(() {
                email = c;
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
          loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed:
                      email.isEmpty || password.isEmpty ? null : handleLogin,
                  child: const Text("Login"),
                )
        ],
      ),
    );
  }
}
