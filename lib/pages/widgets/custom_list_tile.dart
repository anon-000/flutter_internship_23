import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/new_page.dart';

///
/// Created by Auro on 30/09/23 at 9:54 AM
///

class CustomListTile extends StatelessWidget {
  final ToDo datum;
  final VoidCallback? onDelete;
  final int index;
  final Function(ToDo c)? onChanged;

  const CustomListTile(
    this.datum, {
    Key? key,
    this.onDelete,
    this.index = 0,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onChanged!.call(datum);
      },
      leading: Text("${index + 1}"),
      title: Text("${datum.title}"),
      subtitle: Text("${datum.description}"),
      trailing: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (c) => Dialog(
              child: Container(
                // height: 100,
                // width: 100,
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
                        "Are you sure you want to delete this item?",
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
                                onDelete!.call();
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
        child: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}
