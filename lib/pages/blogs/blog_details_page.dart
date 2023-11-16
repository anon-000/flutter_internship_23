import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/blog.dart';
import 'package:flutter_demo/data_models/comment.dart';
import 'package:flutter_demo/pages/blogs/widgets/add_comment_sheet.dart';
import 'package:flutter_demo/pages/blogs/widgets/comment_tile.dart';
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
        return BlogDatum.fromJson(response.data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog Details"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Comment"),
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
                final datum = snapshot.data as BlogDatum;
                return ListView(
                  children: [
                    Image.network(
                      "${datum.attachment}",
                      height: 250,
                      fit: BoxFit.cover,
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
                            return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16),
                              itemCount: comments.length,
                              separatorBuilder: (c, i) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (c, i) => CommentTile(comments[i]),
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
