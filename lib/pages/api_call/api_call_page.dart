import 'dart:convert';
import 'dart:developer';

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
  late Future<List<AlbumDatum>?> futureAlbum;

  /// get album details of id 4
  Future<List<AlbumDatum>?> getAlbumDetails() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

      if (response.statusCode == 200) {
        return List<AlbumDatum>.from(
          jsonDecode(response.body).map(
            (e) => AlbumDatum.fromJson(e),
          ),
        );

        // return AlbumDatum.fromJson(jsonDecode(response.body));
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
        title: const Text("Albums"),
        actions: [
          IconButton(
            onPressed: () async {
              final res = await Navigator.pushNamed(
                context,
                '/add-album-page',
              );
              if (res != null) {
                log("Result : $res");
                setState(() {
                  futureAlbum = getAlbumDetails();
                });
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  futureAlbum = getAlbumDetails();
                });
              },
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
                      final data = snapshot.data as List<AlbumDatum>;
                      return ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: (c, i) => const Divider(
                          color: Colors.red,
                        ),
                        itemBuilder: (c, i) => ListTile(
                          title: Text("${data[i].title}"),
                          subtitle: Text("User ID : ${data[i].userId}"),
                          leading: Text("# ${data[i].id}"),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final res = await Navigator.pushNamed(
                                context,
                                '/edit-album-page',
                                arguments: {
                                  "data": data[i],
                                },
                              );
                              if (res != null) {
                                log("Result : $res");
                                setState(() {
                                  futureAlbum = getAlbumDetails();
                                });
                              }
                            },
                          ),
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
