import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/blog.dart';
import 'package:flutter_demo/data_models/comment.dart';
import 'package:flutter_demo/data_models/favorite.dart';
import 'package:flutter_demo/pages/blogs/widgets/add_comment_sheet.dart';
import 'package:flutter_demo/pages/blogs/widgets/comment_tile.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

///
/// Created by Auro on 10/11/23 at 10:00 PM
///

class BlogDetailsPage extends StatefulWidget {
  final String? id;

  const BlogDetailsPage({Key? key, this.id}) : super(key: key);

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  late Future<BlogDatum?> futureBlog;
  late Future<List<CommentDatum>?> futureComment;
  String blogId = '';
  bool loading = false;
  final Dio dio = Dio();

  /// way 2
  BlogDatum? blogDatum;

  @override
  void initState() {
    super.initState();
    // futureBlog = getBlogDetails();
  }

  Future<BlogDatum?> getBlogDetails() async {
    try {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      blogId = arguments['id'];

      // log("API URL: https://api.dev.thepatchupindia.in/v1/blog/$blogId");
      final dio = Dio();
      final response = await dio.get(
        "https://api.dev.thepatchupindia.in/v1/blog/$blogId",
        queryParameters: {
          '\$populate': "createdBy",
        },
      );

      // log("API URL : https://api.dev.thepatchupindia.in/v1/blog/$id?\$populate=createdBy");
      // log("RESPONSE of $id : $response");
      // log("RESPONSE  : : ${response.data}");
      if (response.statusCode == 200) {
        // log("RESPONSE  : : ${response.data}");
        blogDatum = BlogDatum.fromJson(response.data);
        return blogDatum;
      } else {
        throw "${response.data['message']}";
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureBlog = getBlogDetails();
    futureComment = getBlogComments();
  }

  Future<List<CommentDatum>?> getBlogComments() async {
    try {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      blogId = arguments['id'];
      final dio = Dio();
      final response = await dio.get(
        "https://api.dev.thepatchupindia.in/v1/blog-comments",
        queryParameters: {
          '\$populate': "createdBy",
          '\$limit': -1,
          'blog': blogId,
          '\$sort[createdAt]': -1,
        },
      );
      if (response.statusCode == 200) {
        // log("RESPONSE  : : ${response.data}");
        return List<CommentDatum>.from(
          response.data.map(
            (e) => CommentDatum.fromJson(e),
          ),
        );
      } else {
        throw "${response.data['message']}";
      }
    } catch (err) {
      rethrow;
    }
  }

  addToFavorite(String blogId) async {
    // POST API
    try {
      setState(() {
        loading = true;
      });
      dio.options.headers['Authorization'] =
          SharedPreferenceHelper.authenticationData!.accessToken!;
      Map<String, dynamic> body = {
        "blog": blogId,
        "createdBy": "${SharedPreferenceHelper.authenticationData!.user!.id}",
      };
      // log("body: $body");
      final response = await dio.post(
        "https://api.dev.thepatchupindia.in/v1/blog-favorite",
        data: body,
      );

      log("${response.data}");

      setState(() {
        // futureBlog = getBlogDetails();
        loading = false;
        blogDatum!.favorite = FavoriteDatum.fromJson(response.data);
      });
    } catch (err, s) {
      log("$err : $s");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }
  }

  removeFromFavorite(String favoriteId) async {
    /// DELETE API
    try {
      setState(() {
        loading = true;
      });
      dio.options.headers['Authorization'] =
          SharedPreferenceHelper.authenticationData!.accessToken!;

      final response = await dio.delete(
        "https://api.dev.thepatchupindia.in/v1/blog-favorite/$favoriteId",
      );

      log("${response.data}");

      setState(() {
        // futureBlog = getBlogDetails();
        loading = false;
        blogDatum!.favorite = null;
      });
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
        title: const Text("Blog Details"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Comment"),
        onPressed: () async {
          final res = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: true,
            builder: (c) => AddCommentSheet(
              blogId: blogId,
            ),
          );

          if (res != null) {
            setState(() {
              futureBlog = getBlogDetails();
              futureComment = getBlogComments();
            });
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureBlog = getBlogDetails();
            futureComment = getBlogComments();
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
                final datum = blogDatum!;
                return ListView(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          "${datum.attachment}",
                          height: 250,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            child: Icon(
                              Icons.favorite,
                              color: datum.favorite == null
                                  ? Colors.white
                                  : Colors.red,
                            ),
                            onPressed: () {
                              if (datum.favorite == null) {
                                addToFavorite(datum.id!);
                              } else {
                                removeFromFavorite(datum.favorite!.id!);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${datum.title}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "written by ${datum.createdBy!.name} on ${DateFormat("dd MMM yyyy").format(datum.createdAt!)}",
                        style: const TextStyle(),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${datum.description}",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "All Comments",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: futureComment,
                      builder: (c, ss) {
                        if (ss.connectionState == ConnectionState.done) {
                          // If we got an error
                          if (ss.hasError) {
                            return Center(
                              child: Text(
                                '${ss.error} occurred',
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                            // if we got our data
                          } else if (ss.hasData) {
                            // Extracting data from snapshot object
                            final comments = ss.data as List<CommentDatum>;
                            return comments.isEmpty
                                ? const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Text("No comments found"),
                                    ),
                                  )
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(16),
                                    itemCount: comments.length,
                                    separatorBuilder: (c, i) =>
                                        const SizedBox(height: 16),
                                    itemBuilder: (c, i) =>
                                        CommentTile(comments[i]),
                                  );
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
