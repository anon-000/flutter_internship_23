import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;

///
/// Created by Auro on 16/11/23 at 9:58 PM
///

class CommentTile extends StatelessWidget {
  final CommentDatum datum;

  const CommentTile(this.datum, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  datum.createdBy!.avatar!,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${datum.createdBy!.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    timeago.format(datum.createdAt!.toLocal()),
                    // "${DateFormat("hh:mm a dd MMM yyyy").format(datum.createdAt!.toLocal())}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text("${datum.text}"),
        ],
      ),
    );
  }
}
