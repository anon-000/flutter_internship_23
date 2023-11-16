import 'dart:convert';
import 'dart:developer';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

///
/// Created by Auro on 16/11/23 at 10:23 PM
///

class AddCommentSheet extends StatefulWidget {
  final String blogId;

  const AddCommentSheet({Key? key, this.blogId = ''}) : super(key: key);

  @override
  State<AddCommentSheet> createState() => _AddCommentSheetState();
}

class _AddCommentSheetState extends State<AddCommentSheet> {
  TextEditingController textController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  handleAddComment() async {
    try {
      setState(() {
        loading = true;
      });

      /// Create Comment API
      final encoding = Encoding.getByName('utf-8');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "text": textController.text,
        "blog": widget.blogId,
        "createdBy": "${SharedPreferenceHelper.authenticationData!.user!.id}",
      };

      String jsonBody = json.encode(body);

      // log("body: $body");

      final response = await http.post(
        Uri.parse(
          "https://api.dev.thepatchupindia.in/v1/blog-comments",
        ),
        body: jsonBody,
        headers: headers,
        encoding: encoding,
      );

      setState(() {
        loading = false;
      });

      if (response.statusCode == 201) {
        /// show success msg
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Comment added successfully")));

        Navigator.pop(context, true);
      } else {
        throw "${jsonDecode(response.body)['message']}";
      }
    } catch (err, s) {
      log("$err : $s");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Add Comment Sheet",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              minLines: 5,
              maxLines: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: handleAddComment,
                      child: const Text("Add"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
