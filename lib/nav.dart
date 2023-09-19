import 'package:first_app1/home.dart';
import 'package:flutter/material.dart';

import 'business.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key});

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int selectedIndex = 0;
  bool showBusinessPage = false;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 1) {
        showBusinessPage = true;
      } else {
        showBusinessPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      body: IndexedStack(index: selectedIndex, children: [
        HomePage(),
        BusinessPage(),
        const Center(
          child: Text(
            'School Page',
          ),
        ),
      ]),
    );
  }
}
