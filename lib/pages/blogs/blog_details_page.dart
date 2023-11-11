import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/blog.dart';
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

  @override
  void initState() {
    super.initState();
    // futureBlog = getBlogDetails();
  }

  Future<BlogDatum?> getBlogDetails() async {
    try {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      String blogId = arguments['id'];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Details"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureBlog = getBlogDetails();
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
