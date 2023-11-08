import 'dart:convert';
import 'dart:developer';

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

  @override
  void initState() {
    super.initState();
    futureBlog = getAllBlogs();
  }

  Future<List<BlogDatum>?> getAllBlogs() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.dev.thepatchupindia.in/v1/blog?\$limit=-1'));

      if (response.statusCode == 200) {
        // log("RESPONSE  : : ${jsonDecode(response.body)}");

        return List<BlogDatum>.from(
          jsonDecode(response.body).map(
            (e) => BlogDatum.fromJson(e),
          ),
        );

        // return AlbumDatum.fromJson(jsonDecode(response.body));
      } else {
        throw "${jsonDecode(response.body)['message']}";
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      itemBuilder: (c, i) => BlogCard(data[i]),
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
    );
  }
}
