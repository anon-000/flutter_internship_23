import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';

///
/// Created by Auro on 08/11/23 at 9:49 PM
///

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
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
                              "Are you sure you want to logout?",
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
                                      // code for logout'
                                      SharedPreferenceHelper.preferences!
                                          .clear();
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/welcome-page',
                                        (r) => false,
                                      );
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
              icon: Icon(
                Icons.logout,
                color: Color(0xff005FEE),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Container(
                    child: Image.network(
                      "${SharedPreferenceHelper.authenticationData!.user!.avatar}",
                      fit: BoxFit.cover,
                    ),
                    height: 100,
                    width: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${SharedPreferenceHelper.authenticationData!.user!.name}",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "${SharedPreferenceHelper.authenticationData!.user!.email}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                SharedPreferenceHelper.authenticationData!.user!.bio == null
                    ? "No bio yet"
                    : "${SharedPreferenceHelper.authenticationData!.user!.bio}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Divider(),
              ListTile(
                title: Text("Edit Profile"),
                onTap: () async {
                  final res = await Navigator.of(context)
                      .pushNamed("/edit-profile-page");
                  if (res != null) {
                    setState(() {});
                  }
                },
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
