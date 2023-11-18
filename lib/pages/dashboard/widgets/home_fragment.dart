import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/blog.dart';
import 'package:flutter_demo/pages/dashboard/widgets/blog_card.dart';
import 'package:http/http.dart' as http;

///
/// Created by Auro on 08/11/23 at 9:49 PM
///

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late Future<List<BlogDatum>?> futureBlog;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureBlog = getAllBlogs();
  }

  Future<List<BlogDatum>?> getAllBlogs() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.dev.thepatchupindia.in/v1/blog?\$limit=-1&\$populate=createdBy&\$sort[createdAt]=-1&search=$searchQuery'));

      if (response.statusCode == 200) {
        // log("RESPONSE  : : ${jsonDecode(response.body)}");

        return List<BlogDatum>.from(
          jsonDecode(response.body).map(
            (e) => BlogDatum.fromJson(e),
          ),
        );

        // return AlbumDatum.fromJson(jsonDecode(response.body));
      } else {
        log("${jsonDecode(response.body)['message']}");
        throw "${jsonDecode(response.body)['message']}";
      }
    } catch (err) {
      rethrow;
    }
  }

  handleDeleteBlog(String blogId) async {
    try {
      final dio = Dio();
      final response = await dio.delete(
        "https://api.dev.thepatchupindia.in/v1/blog/$blogId",
      );
      if (response.statusCode == 200) {
        setState(() {
          futureBlog = getAllBlogs();
        });
      } else {
        throw "${response.data['message']}";
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          ///create-blog-page
          final res = await Navigator.pushNamed(
            context,
            '/create-blog-page',
          );
          if (res != null) {
            setState(() {
              futureBlog = getAllBlogs();
            });
          }
        },
        label: const Text('Create'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          AppBar(
            elevation: 0,
            title: const Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          // TextField(
          //   onChanged: (c){
          //     searchQuery = c;
          //     setState(() {
          //       futureBlog = getAllBlogs();
          //     });
          //   },
          // ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  futureBlog = getAllBlogs();
                });
              },
              child: FutureBuilder(
                future: futureBlog,
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
                      final data = snapshot.data as List<BlogDatum>;
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: data.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 16),
                        itemBuilder: (c, i) => BlogCard(
                          data[i],
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (c) => Dialog(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "Are you sure you want to delete this blog?",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No"),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  // code for delete'
                                                  handleDeleteBlog(data[i].id!);
                                                },
                                                child: const Text("Yes"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
        ],
      ),
    );
  }
}
