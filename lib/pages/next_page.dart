import 'package:flutter/material.dart';

///
/// Created by Auro on 28/09/23 at 9:14 AM
///

Stream<int> generateNumbers = (() async* {
  await Future<void>.delayed(const Duration(seconds: 2));

  for (int i = 1; i <= 10; i++) {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield i;
  }
})();

class NextPage extends StatefulWidget {
  static const routeName = '/next-page';
  final String data;

  const NextPage({Key? key, this.data = ''}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  /// Future method
  Future? getData() async {
    try {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return Future.delayed(
        const Duration(seconds: 2),
        () {
          return "${arguments['data']}";
        },
      );
    } catch (err) {
      print("$err");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Page"),
        actions: [
          IconButton(onPressed: () {
            Navigator.pop(context, 'sdsdsdzdsds');
          }, icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: StreamBuilder<int>(
              stream: generateNumbers,
              initialData: 0,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("${snapshot.data}"),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString(),
                        style:
                            const TextStyle(color: Colors.red, fontSize: 40));
                  } else {
                    return const CircularProgressIndicator();
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: getData(),
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
                  final data = snapshot.data as String;
                  return Center(
                    child: Text(
                      data,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
