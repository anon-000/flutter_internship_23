import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/blog.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:intl/intl.dart';

///
/// Created by Auro on 08/11/23 at 10:16 PM
///

class BlogCard extends StatelessWidget {
  final BlogDatum datum;
  final VoidCallback? onTap;

  const BlogCard(this.datum, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/blog-details-page',
          arguments: {
            "id": datum.id,
          },
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              offset: const Offset(0, 0),
              blurRadius: 7,
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  "${datum.attachment}",
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: datum.createdBy!.id ==
                          SharedPreferenceHelper.authenticationData!.user!.id
                      ? Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: onTap,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Text("${datum.createdBy!.id}"),
            // Text("${SharedPreferenceHelper.authenticationData!.user!.id}"),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
