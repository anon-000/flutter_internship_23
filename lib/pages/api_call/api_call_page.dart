import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/api_call/data_models/album.dart';
import 'package:http/http.dart' as http;

///
/// Created by Auro on 09/10/23 at 10:07 PM
///

class ApiCallPage extends StatefulWidget {
  const ApiCallPage({Key? key}) : super(key: key);

  @override
  State<ApiCallPage> createState() => _ApiCallPageState();
}

class _ApiCallPageState extends State<ApiCallPage> {
  late Future<AlbumDatum?> futureAlbum;

  /// get album details of id 4
  Future<AlbumDatum?> getAlbumDetails() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/4'));

      if (response.statusCode == 200) {
        return AlbumDatum.fromJson(jsonDecode(response.body));
      } else {
        throw "Failed to load";
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = getAlbumDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rest API Calls"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // futureAlbum = getAlbumDetails();
              });
            },
            icon: Icon(Icons.ac_unit),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: futureAlbum,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as AlbumDatum;
                    return Center(
                      child: Text(
                        "Title: ${data.title}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 50,
          //     child: ElevatedButton(
          //       onPressed: () {},
          //       child: const Text("Get Users"),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
