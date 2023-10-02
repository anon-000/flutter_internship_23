import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/utils/sharedpreference_helper.dart';
import 'package:flutter_demo/pages/widgets/custom_list_tile.dart';
import 'dart:convert';

///
/// Created by Auro on 30/09/23 at 9:25 AM
///
///

ToDo toDoFromJson(String str) => ToDo.fromJson(json.decode(str));

String toDoToJson(ToDo data) => json.encode(data.toJson());

class ToDo {
  String id;
  String? title;
  String? description;

  ToDo({
    required this.id,
    this.title,
    this.description,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
      };
}

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List<ToDo> data = [];
  String toDoValue = '';
  List<ToDo> oldData = [
    ToDo.fromJson({"id": "0", "title": "hello", "description": "world"}),
    ToDo(
      id: '1',
      title: "Hello 1",
      description:
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum',
    ),
    ToDo(
      id: '2',
      title: "Hello 2",
      description:
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum',
    ),
    ToDo(
      id: '3',
      title: "Hello 3",
      description:
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum',
    ),
    ToDo(
      id: '4',
      title: "Hello 4",
      description:
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum',
    ),
    ToDo(
      id: '5',
      title: "Hello 5",
      description:
          'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum',
    ),
  ];

  // get
  getDataFromLocalStorage() {
    try {
      data = SharedPreferenceHelper.toDoList;
      log("getDataFromLocalStorage>>> $data");
    } catch (er) {
      log("$er");
    }
  }

  // set
  storeDataToLocalStorage() {
    try {
      SharedPreferenceHelper.storeToDoList(data);
    } catch (er) {
      log("$er");
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: data.length,
              separatorBuilder: (c, i) => const Divider(),
              itemBuilder: (c, i) => CustomListTile(
                data[i],
                index: i,
                onChanged: (v) {
                  print("$v");
                },
                onDelete: () {
                  print("Remove item at $i");
                  setState(() {
                    data.removeAt(i);
                  });
                  storeDataToLocalStorage();
                },
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    builder: (c) => Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Add item"),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              minLines: 5,
                              maxLines: 6,
                              onChanged: (v) {
                                toDoValue = v ?? "";
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text("Add"),
                                onPressed: () async {
                                  setState(() {
                                    data.add(
                                      ToDo(
                                        id: "${DateTime.now().millisecondsSinceEpoch}",
                                        title: toDoValue,
                                        description: "",
                                      ),
                                    );
                                  });
                                  storeDataToLocalStorage();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text("Add"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
