import 'package:flutter/material.dart';

void main() {
  runApp(SmartLuggageApp());
}

class SmartLuggageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Luggage Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WeightPage(),
    FindPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Luggage Tracker')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_weight), label: 'Weight'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.luggage, size: 100, color: Colors.indigo),
            SizedBox(height: 20),
            Text('Welcome to Smart Luggage Tracker!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 10),
            Text('Track your luggage location and weight in real-time.',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class WeightPage extends StatelessWidget {
  final double currentWeight = 25.5; // kg
  final double maxWeight = 23.0; // kg (e.g., airline limit)

  @override
  Widget build(BuildContext context) {
    final isOverweight = currentWeight > maxWeight;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current Luggage Weight', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('$currentWeight kg',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: isOverweight ? Colors.red : Colors.green)),
          SizedBox(height: 20),
          Text('Limit: $maxWeight kg', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          if (isOverweight)
            Text('Overweight! Please reduce luggage.', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class FindPage extends StatelessWidget {
  void triggerSound() {
    print('🔊 Luggage is beeping!'); // Replace with actual Bluetooth/IoT trigger logic
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 100, color: Colors.indigo),
            SizedBox(height: 20),
            Text('Can’t find your luggage?', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.volume_up),
              label: Text('Ring Luggage'),
              onPressed: () {
                triggerSound();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Signal sent to luggage.')),);
              },
            ),
          ],
        ),
      ),
    );
  }
}
