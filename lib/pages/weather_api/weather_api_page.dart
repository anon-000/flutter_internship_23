import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_demo/data_models/weather.dart';
import 'package:http/http.dart' as http;

///
/// Created by Auro on 12/10/23 at 9:24 PM
///

class WeatherApiPage extends StatefulWidget {
  const WeatherApiPage({Key? key}) : super(key: key);

  @override
  State<WeatherApiPage> createState() => _WeatherApiPageState();
}

class _WeatherApiPageState extends State<WeatherApiPage> {
  WeatherDatum? weatherDatum;
  String tfValue = '';
  bool loading = false;

  Future<WeatherDatum?> getWeatherData() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$tfValue&appid=21df875e31d9a53171c21e08e6f63e3a",
        ),
      );

      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        return WeatherDatum.fromJson(jsonDecode(response.body));
      } else {
        throw "Failed to load";
      }
    } catch (err) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather API"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    tfValue = v;
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  log("text field value : $tfValue");
                  try {
                    final response = await getWeatherData();
                    setState(() {
                      weatherDatum = response;
                    });
                  } catch (err) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$err")));
                  }
                },
                child: const Text("Search"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: loading
                ? const CircularProgressIndicator()
                : Text(
                    weatherDatum == null
                        ? ""
                        : "${weatherDatum!.main!.toJson()}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
