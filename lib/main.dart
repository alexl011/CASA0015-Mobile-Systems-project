import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
    LuggagePage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.monitor_weight), label: 'My Luggage'),
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



class LuggagePage extends StatefulWidget {
  @override
  _LuggagePageState createState() => _LuggagePageState();
}

class _LuggagePageState extends State<LuggagePage> {
  double luggageWeight = 18.5;
  double maxWeight = 23.0;

  @override
  Widget build(BuildContext context) {
    double percent = (luggageWeight / maxWeight).clamp(0.0, 1.0);
    bool isOverweight = luggageWeight > maxWeight;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 14.0,
            percent: percent,
            center: Text("${luggageWeight.toStringAsFixed(1)} kg",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            progressColor: isOverweight ? Colors.red : Colors.indigo,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          SizedBox(height: 30),
          Text("Weight Limit: ${maxWeight.toStringAsFixed(1)} kg"),
          if (isOverweight)
            Text("Overweight! Please reduce luggage.",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Text("Customize Weight Limit:"),
          Slider(
            value: maxWeight,
            min: 10,
            max: 50,
            divisions: 40,
            label: maxWeight.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                maxWeight = value;
              });
            },
          )
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
