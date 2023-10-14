import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/layout_example/widgets/feature_icon.dart';

///
/// Created by Auro on 14/10/23 at 10:20 PM
///

class LayoutExamplePage extends StatefulWidget {
  const LayoutExamplePage({Key? key}) : super(key: key);

  @override
  State<LayoutExamplePage> createState() => _LayoutExamplePageState();
}

class _LayoutExamplePageState extends State<LayoutExamplePage> {
  List<Map<String, dynamic>> data = [
    {
      "icon":
          "https://openweathermap.org/themes/openweathermap/assets/img/landing/icon-1.png",
      "title": "current weather",
      "description": "(current)",
    },
    {
      "icon":
          "https://openweathermap.org/themes/openweathermap/assets/img/landing/icon-2.png",
      "title": "hourly forecast",
      "description": "(4 days)",
    },
    {
      "icon":
          "https://openweathermap.org/themes/openweathermap/assets/img/landing/icon-3.png",
      "title": "daily forecast",
      "description": "(16 days)",
    },
    {
      "icon":
          "https://openweathermap.org/themes/openweathermap/assets/img/landing/icon-4.png",
      "title": "climatic forecast",
      "description": "(30 days)",
    },
    {
      "icon":
          "https://openweathermap.org/themes/openweathermap/assets/img/landing/icon-5.png",
      "title": "historical weather",
      "description": "(40+ years back)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Layout example"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 50,
            ),
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Use our ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "Professional collections ",
                        style: TextStyle(
                          color: const Color(0xff333333).withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text:
                            "to get extended weather data for any coordinates on the globe.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "For professionals and specialists with middle and large sized project, we recommend our Professional collections. They include either an extended data sets, or various tools for receiving and displaying data, etc.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: data
                      .map(
                        (e) => Expanded(
                          child: FeatureIcon(
                            icon: e["icon"],
                            title: e["title"],
                            description: e["description"],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Called by:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "geographic coordinates, zip/post code, city name, city ID, number of cities (only in current weather and forecast APIs)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(
                          color: Color(0xff333333),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Learn more",
                    style: TextStyle(
                      color: Color(0xff333333),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
