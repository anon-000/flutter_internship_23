import 'dart:convert';
import 'dart:developer';
import 'package:flutter_demo/pages/api_call/data_models/album.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

///
/// Created by Auro on 18/10/23 at 9:50 PM
///

class EditAlbumPage extends StatefulWidget {
  const EditAlbumPage({Key? key}) : super(key: key);

  @override
  State<EditAlbumPage> createState() => _EditAlbumPageState();
}

class _EditAlbumPageState extends State<EditAlbumPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  int? albumId;

  bool loading = false;

  handleSubmit() async {
    try {
      setState(() {
        loading = true;
      });
      final uri =
          Uri.parse('https://jsonplaceholder.typicode.com/albums/$albumId');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "title": titleController.text,
        "userId": userIdController.text,
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      final response = await http.patch(
        uri,
        body: jsonBody,
        headers: headers,
        encoding: encoding,
      );
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Album updated successfully"),
        ),
      );
      Navigator.pop(context, AlbumDatum.fromJson(jsonDecode(response.body)));
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    titleController.text = (arguments['data'] as AlbumDatum).title ?? "";
    userIdController.text = "${(arguments['data'] as AlbumDatum).userId}";
    albumId = (arguments['data'] as AlbumDatum).id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Album"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Title"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "User Id",
                  ),
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
                      onPressed: titleController.text.isNotEmpty &&
                              userIdController.text.isNotEmpty
                          ? handleSubmit
                          : null,
                      child: const Text("Update"),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
