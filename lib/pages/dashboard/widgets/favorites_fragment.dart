import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/blog.dart';
import 'package:flutter_demo/pages/dashboard/widgets/blog_card.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';

///
/// Created by Auro on 08/11/23 at 9:49 PM
///

class FavoritesFragment extends StatefulWidget {
  const FavoritesFragment({Key? key}) : super(key: key);

  @override
  State<FavoritesFragment> createState() => _FavoritesFragmentState();
}

class _FavoritesFragmentState extends State<FavoritesFragment> {
  late Future<List<BlogDatum>?> futureBlog;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    futureBlog = getAllBlogs();
  }

  Future<List<BlogDatum>?> getAllBlogs() async {
    try {
      dio.options.headers['Authorization'] =
          SharedPreferenceHelper.authenticationData!.accessToken!;

      final response = await dio.get(
        'https://api.dev.thepatchupindia.in/v1/blog-favorite',
        queryParameters: {
          '\$populate': ["createdBy", "blog"],
          '\$limit': -1,
          '\$sort[createdAt]': -1,
        },
      );
      log("$response");
      return List<BlogDatum>.from(
        response.data.map(
          (e) => BlogDatum.fromJson(
            e['blog'],
          ),
        ),
      );
    } catch (err, s) {
      log("$err : $s");
      rethrow;
    }
  }

  handleDeleteBlog(String favoriteId) async {
    try {
      dio.options.headers['Authorization'] =
          SharedPreferenceHelper.authenticationData!.accessToken!;
      final response = await dio.delete(
        "https://api.dev.thepatchupindia.in/v1/blog-favorite/$favoriteId",
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
      body: Column(
        children: [
          AppBar(
            elevation: 0,
            title: const Text(
              "Favorites",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
          ),
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
                      return data.isEmpty
                          ? const SizedBox(
                              height: 600,
                              child: Center(
                                child: Text("No favorites found"),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: data.length,
                              separatorBuilder: (c, i) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (c, i) => BlogCard(
                                data[i],
                                onRefresh: () {
                                  setState(() {
                                    futureBlog = getAllBlogs();
                                  });
                                },
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (c) => Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                "Are you sure you want remove from favorites?",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
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
                                                        handleDeleteBlog(
                                                            data[i].id!);
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
