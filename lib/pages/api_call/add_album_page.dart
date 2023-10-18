import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/api_call/data_models/album.dart';
import 'package:http/http.dart' as http;

///
/// Created by Auro on 17/10/23 at 10:00 PM
///

class AddAlbumPage extends StatefulWidget {
  const AddAlbumPage({Key? key}) : super(key: key);

  @override
  State<AddAlbumPage> createState() => _AddAlbumPageState();
}

class _AddAlbumPageState extends State<AddAlbumPage> {
  String title = '', userId = '';
  bool loading = false;

  handleSubmit() async {
    try {
      setState(() {
        loading = true;
      });

      final uri = Uri.parse('https://jsonplaceholder.typicode.com/albums');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "title": title,
        "userId": userId,
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      final response = await http.post(
        uri,
        body: jsonBody,
        headers: headers,
        encoding: encoding,
      );
      setState(() {
        loading = false;
      });
      Navigator.pop(context, AlbumDatum.fromJson(jsonDecode(response.body)));
      // if (response.statusCode == 200) {
      //   log("RESPONSE :::::: $response");
      //
      // } else {
      //   throw "Failed to load";
      // }
    } catch (err, s) {
      setState(() {
        loading = false;
      });
      log("$err : $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$err"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Album"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Title"),
                  onChanged: (v) {
                    setState(() {
                      title = v;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "User Id",
                  ),
                  onChanged: (v) {
                    setState(() {
                      userId = v;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: title.isNotEmpty && userId.isNotEmpty
                          ? handleSubmit
                          : null,
                      child: const Text("Submit"),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
