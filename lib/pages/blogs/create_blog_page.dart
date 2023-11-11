import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as p;

///
/// Created by Auro on 09/11/23 at 9:59 PM
///

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({Key? key}) : super(key: key);

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  String title = '', description = '';
  File? image;
  ImagePicker picker = ImagePicker();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  pickAnImage() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        image = File(photo.path);
      });
    }
  }

  Future<void> handleCreateBlog() async {
    try {
      setState(() {
        loading = true;
      });

      String url = '';

      /// UPLOAD
      if (image != null) {
        final Dio dio = Dio();
        dio.options.headers['Authorization'] =
            SharedPreferenceHelper.authenticationData!.accessToken!;
        final data = FormData.fromMap({
          "purpose": 'profile',
          "photo": await MultipartFile.fromFile(image!.path,
              filename: image!.path.split('/').last,
              contentType: p.MediaType('image', 'jpeg'))
        });
        //log("====>>> UPLOAD BODY :: ${body}");
        Response response = await dio.post(
          'https://api.dev.thepatchupindia.in/v1/upload',
          data: data,
        );
        log("UPLOAD RES : ${response.data[0]['filePath']}");
        url = response.data[0]['filePath'];
      }

      /// Create Blog API
      final encoding = Encoding.getByName('utf-8');
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "attachment": url,
        "createdBy": "${SharedPreferenceHelper.authenticationData!.user!.id}",
      };

      String jsonBody = json.encode(body);

      // log("body: $body");

      final response = await http.post(
        Uri.parse(
          "https://api.dev.thepatchupindia.in/v1/blog",
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
            const SnackBar(content: Text("Blog created successfully")));

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Blog"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                  ),
                  onChanged: (c) {
                    setState(() {
                      title = c;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Description",
                  ),
                  onChanged: (c) {
                    setState(() {
                      description = c;
                    });
                  },
                  minLines: 10,
                  maxLines: 15,
                ),
                const SizedBox(height: 16),
                image != null
                    ? SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.file(
                                image!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: pickAnImage,
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            children: const [
                              Icon(Icons.upload),
                              Text('Choose an image')
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: ElevatedButton(
                      onPressed: (title.isEmpty ||
                              description.isEmpty ||
                              image == null)
                          ? null
                          : handleCreateBlog,
                      child: const Text("Create"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
