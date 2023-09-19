import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  String _responseText = '';
  String OPENAI_API_KEY = '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';
  String weatherApi = 'e032255571224d3fb81121802231909';
  int temperature = 0;

  Future<String> _makeWeatherRequest() async {
    final apiKey = 'e032255571224d3fb81121802231909';
    final location = 'Munich';
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=no');
    try {
      final response = await http.get(url);
      final jsonResponse = json.decode(response.body);
      // final location = jsonResponse['location']['name'];
      temperature = jsonResponse['current']['temp_c'];
      // final condition = jsonResponse['current']['condition']['text'];
      // final message = 'The weather in $location is $temperature°C and $condition.';

      final jsonres = jsonResponse.toString();
      return jsonres;
      // setState(() {
      //   _responseText = message;
      // });
    } catch (e) {
      return e.toString();
      print(e);
    }
  }

  Future<void> _makeRequest() async {
    print('Making request...');
    String weather = await _makeWeatherRequest();
    // print(weather);
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $OPENAI_API_KEY',
    };
    final body = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'user',
          'content':
              'What should I wear today? Write a very short response based on the data below:\n\n$weather\n\n Format of your response: \n\nThe weather in {city} is {weather}. You should wear {type of clothes or name or clothes}'
        }
      ],
      'temperature': 0.7,
    };
    try {
      final response =
          await http.post(url, headers: headers, body: json.encode(body));

      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final message = jsonResponse['choices'][0]['message']['content'];
      setState(() {
        _responseText = message;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _makeRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Temperature: $temperature°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _makeRequest,
                      child: const Text('Make API Request'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _responseText,
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
