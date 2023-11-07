import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/next_page.dart';
import 'package:flutter_demo/utils/sharedpreference_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

///
/// Created by Auro on 25/09/23 at 9:09 AM
///

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String value = '';
  bool isObscure = true;
  RegExp digitValidator = RegExp("[0-9]+");
  int currentIndex = 0, sliderIndex = 0;
  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  String? selectedValue;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  PageController pageController = PageController();
  late TabController _tabController;

  List<String> images = [
    'https://images.unsplash.com/photo-1500964757637-c85e8a162699?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YmVhdXRpZnVsJTIwbGFuZHNjYXBlfGVufDB8fDB8fHww&w=1000&q=80',
    'https://media.istockphoto.com/id/1296913338/photo/sonoran-sunset.jpg?s=612x612&w=0&k=20&c=lGXd-vnDmH_bCnR53BNmwxsh3qn8MBLQoh5M926QAbY=',
    'https://media.istockphoto.com/id/517188688/photo/mountain-landscape.jpg?s=612x612&w=0&k=20&c=A63koPKaCyIwQWOTFBRWXj_PwCrR4cEoOw2S9Q7yVl8=',
    'https://media.photographycourse.net/wp-content/uploads/2014/11/08164934/Landscape-Photography-steps.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello World"),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (v) {
            pageController.animateToPage(
              v,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
            );
          },
          tabs: [
            const Tab(text: 'Home'),
            const Tab(text: 'Items'),
            const Tab(text: 'History'),
            const Tab(text: 'Profile'),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.add),
          // ),
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.star),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Get The App")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.chrome_reader_mode),
                    SizedBox(
                      width: 10,
                    ),
                    Text("About")
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 30),
            color: Colors.grey,
            elevation: 2,
            onSelected: (v) {
              if (v == 0) {
                // logout
              }
            },
          ),
          IconButton(
            onPressed: () async {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (c) => NextPage(
              //       data: "Helloooooooo",
              //     ),
              //   ),
              // );

              final result = await Navigator.pushNamed(
                context,
                '/next-page',
                arguments: {
                  "data": "Hello World",
                },
              );

              if (result != null) {
                print("Got back arguments from next opage : $result");
              }
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
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
                                    SharedPreferenceHelper.preferences!.clear();
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      // body: Center(
      //   child: DropdownButton(
      //     hint: const Text("Select a value"),
      //     value: selectedValue,
      //     icon: const Icon(Icons.keyboard_arrow_down),
      //     items: items.map((String each) {
      //       return DropdownMenuItem(
      //         value: each,
      //         child: Text(each),
      //       );
      //     }).toList(),
      //     onChanged: (String? newValue) {
      //       setState(() {
      //         selectedValue = newValue!;
      //       });
      //     },
      //   ),
      // ),
      // body: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Container(
      //         color: Colors.yellow,
      //       ),
      //     ),
      //     Positioned(
      //       top: 70,
      //       left: 70,
      //       right: 70,
      //       bottom: 70,
      //       child: ColoredBox(
      //         color: Colors.greenAccent,
      //         child: Center(
      //           child: Container(
      //             height: 100,
      //             width: 100,
      //             color: Colors.red,
      //           ),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: 70,
      //       right: 70,
      //       child: Container(
      //         height: 100,
      //         width: 100,
      //         color: Colors.green,
      //       ),
      //     ),
      //   ],
      // ),

      // body: Form(
      //   key: _formKey,
      //   autovalidateMode: autoValidateMode,
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 16),
      //           child: ElevatedButton(
      //             onPressed: () {
      //               // Navigator.of(context).push(
      //               //   MaterialPageRoute(
      //               //     builder: (context) => const NextPage(
      //               //       data: "Hello World",
      //               //     ),
      //               //   ),
      //               // );
      //
      //               Navigator.pushNamed(
      //                 context,
      //                 '/next-page',
      //                 arguments: {
      //                   "data": "Hello World",
      //                 },
      //               );
      //             },
      //             child: const Text('Go to next page'),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // body: SizedBox(
      //   height: 300,
      //   child: ListView(
      //     scrollDirection: Axis.horizontal,
      //     children: [
      //       Container(
      //         height: 400,
      //         width: 400,
      //         color: Colors.yellow,
      //       ),
      //       Container(
      //         height: 400,
      //         width: 400,
      //         color: Colors.greenAccent,
      //       ),
      //       Container(
      //         height: 400,
      //         width: 400,
      //         color: Colors.red,
      //       ),
      //     ],
      //   ),
      // ),

      // body: GridView.builder(
      //   padding: const EdgeInsets.all(16),
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     childAspectRatio: 1,
      //     crossAxisSpacing: 16,
      //     mainAxisSpacing: 16,
      //   ),
      //   // scrollDirection: Axis.vertical,
      //   itemCount: items.length,
      //   itemBuilder: (ctx, i) => Container(
      //     color: Colors.yellow,
      //     alignment: Alignment.center,
      //     child: Text("${items[i]}"),
      //   ),
      // children: [
      //   Container(
      //     color: Colors.yellow,
      //   ),
      //   Container(
      //     color: Colors.greenAccent,
      //   ),
      //   Container(
      //     color: Colors.red,
      //   ),
      //   Container(
      //     color: Colors.blue,
      //   ),
      //   Container(
      //     color: Colors.black,
      //   ),
      //   Container(
      //     color: Colors.pink,
      //   ),
      //   Container(
      //     color: Colors.amber,
      //   ),
      // ],
      // ),

      // body: PageView(
      //   controller: pageController,
      //   onPageChanged: (v) {
      //     setState(() {
      //       currentIndex = v;
      //     });
      //   },
      //   children: [
      //     Container(
      //       color: Colors.yellow,
      //       alignment: Alignment.center,
      //       child: Text("Home"),
      //     ),
      //     Container(
      //       color: Colors.green,
      //       child: Text("Items"),
      //       alignment: Alignment.center,
      //     ),
      //     Container(
      //       color: Colors.pink,
      //       child: Text("History"),
      //       alignment: Alignment.center,
      //     ),
      //     Container(
      //       color: Colors.amber,
      //       child: Text("Profile"),
      //       alignment: Alignment.center,
      //     ),
      //   ],
      // ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: CarouselSlider(
              options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  onPageChanged: (i, res) {
                    setState(() {
                      sliderIndex = i;
                    });
                  }),
              items: images.map((each) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: Colors.amber),
                      child: Image.network(
                        each,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map(
              (e) {
                int index = images.indexOf(e);
                bool isActive = index == sliderIndex;
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(6),
                  height: isActive ? 16 : 12,
                  width: isActive ? 16 : 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blue : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  // child: Text('$index'),
                );
              },
            ).toList(),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/weather-api-page');
                },
                child: const Text("Weather API Page"),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Lottie.asset('assets/icons/animation.json'),
          // const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/new-page');
                },
                child: const Text("New Page"),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Hello world"),
                      margin: EdgeInsets.all(16),
                      // clipBehavior: Clip.antiAlias,
                    ),
                  );
                },
                child: const Text("Show SnackBar.."),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              "https://images.unsplash.com/photo-1500964757637-c85e8a162699?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YmVhdXRpZnVsJTIwbGFuZHNjYXBlfGVufDB8fDB8fHww&w=1000&q=80",
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        elevation: 10,
        currentIndex: currentIndex,
        onTap: (v) {
          setState(() {
            currentIndex = v;
          });
          pageController.animateToPage(
            v,
            curve: Curves.bounceIn,
            duration: const Duration(milliseconds: 300),
          );

          _tabController.animateTo(
            v,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Items",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
