import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/authentication.dart';
import 'package:flutter_demo/data_models/user.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as p;

///
/// Created by Auro on 13/11/23 at 10:10 PM
///

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  dynamic avatar;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  ImagePicker picker = ImagePicker();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() {
    nameController.text =
        SharedPreferenceHelper.authenticationData!.user!.name!;
    emailController.text =
        SharedPreferenceHelper.authenticationData!.user!.email!;
    bioController.text =
        SharedPreferenceHelper.authenticationData!.user!.bio ?? "";
    avatar = SharedPreferenceHelper.authenticationData!.user!.avatar;
  }

  pickAnImage() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        avatar = File(photo.path);
      });
    }
  }

  Future<void> handleEditProfile() async {
    try {
      setState(() {
        loading = true;
      });

      String? url;

      /// UPLOAD
      if (avatar != null && avatar is File) {
        final Dio dio = Dio();
        dio.options.headers['Authorization'] =
            SharedPreferenceHelper.authenticationData!.accessToken!;
        final data = FormData.fromMap({
          "purpose": 'profile',
          "photo": await MultipartFile.fromFile(avatar!.path,
              filename: avatar!.path.split('/').last,
              contentType: p.MediaType('image', 'jpeg'))
        });
        // log("====>>> UPLOAD BODY :: ${body}");
        Response response = await dio.post(
          'https://api.dev.thepatchupindia.in/v1/upload',
          data: data,
        );
        log("UPLOAD RES : ${response.data[0]['filePath']}");
        url = response.data[0]['filePath'];
      }

      /// Create Blog API
      final encoding = Encoding.getByName('utf-8');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer ${SharedPreferenceHelper.authenticationData!.accessToken!}"
      };
      Map<String, dynamic> body = {
        "name": nameController.text,
        "email": emailController.text,
        "bio": bioController.text,
        if (url != null) "avatar": url,
      };

      String jsonBody = json.encode(body);

      // log("body: $body");

      final response = await http.patch(
        Uri.parse(
          "https://api.dev.thepatchupindia.in/v1/user/${SharedPreferenceHelper.authenticationData!.user!.id}",
        ),
        body: jsonBody,
        headers: headers,
        encoding: encoding,
      );

      log("EDIT PROFILE API CALL RESPONSE : ${response.body}");

      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        /// show success msg

        ///  Storing data in local storage
        final userResponse = User.fromJson(jsonDecode(response.body));
        AuthenticationDatum tempDatum =
            SharedPreferenceHelper.authenticationData!;
        tempDatum.user = userResponse;
        SharedPreferenceHelper.storeAuthenticationData(tempDatum);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")));

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
        title: Text("Edit Profile"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: pickAnImage,
                    child: Stack(
                      children: [
                        Container(
                          child: avatar == null
                              ? Icon(Icons.person)
                              : avatar is String
                                  ? Image.network(
                                      "$avatar",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      avatar,
                                      fit: BoxFit.cover,
                                    ),
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(Icons.photo),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the name",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the email",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the bio",
                  ),
                  minLines: 6,
                  maxLines: 8,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: handleEditProfile,
                      child: Text("Save"),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
