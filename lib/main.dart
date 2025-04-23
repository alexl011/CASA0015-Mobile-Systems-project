import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles/map_styles.dart';

void main() {
  runApp(SmartLuggageApp());
}

class SmartLuggageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luggo',
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

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changePage,
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
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Center(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.luggage,
                      size: 80,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Welcome to Luggo!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Smart Luggage Companion',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Quick Actions Section
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: Icons.monitor_weight,
                      title: 'Check Weight',
                      subtitle: 'Monitor your luggage weight',
                      color: Colors.blue,
                      onTap: () {
                        final mainScreenState = context.findAncestorStateOfType<_MainScreenState>();
                        mainScreenState?.changePage(1); // Navigate to My Luggage page
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: Icons.location_on,
                      title: 'Locate',
                      subtitle: 'Find your luggage',
                      color: Colors.orange,
                      onTap: () {
                        final mainScreenState = context.findAncestorStateOfType<_MainScreenState>();
                        mainScreenState?.changePage(2); // Navigate to Find page
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Features Section
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.bluetooth_connected,
                title: 'Real-time Tracking',
                description: 'Keep track of your luggage location in real-time',
                color: Colors.green,
              ),
              SizedBox(height: 12),
              _buildFeatureCard(
                icon: Icons.battery_charging_full,
                title: 'Long Battery Life',
                description: 'Up to 15 days of battery life on a single charge',
                color: Colors.purple,
              ),
              SizedBox(height: 12),
              _buildFeatureCard(
                icon: Icons.notifications_active,
                title: 'Instant Alerts',
                description: 'Get notified when your luggage moves away',
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
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
  final String _weightLimitKey = 'weight_limit';
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadSavedWeightLimit();
  }

  Future<void> _loadSavedWeightLimit() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      maxWeight = _prefs?.getDouble(_weightLimitKey) ?? 23.0;
    });
  }

  Future<void> _saveWeightLimit(double value) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs?.setDouble(_weightLimitKey, value);
  }

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
          Text(
            "Weight Limit: ${maxWeight.toStringAsFixed(1)} kg",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isOverweight)
            Text("Overweight! Please reduce luggage.",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Text(
            "Customize Weight Limit:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
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
              _saveWeightLimit(value); // Save the new value
            },
          )
        ],
      ),
    );
  }
}

class FindPage extends StatefulWidget {
  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  GoogleMapController? mapController;
  final LatLng luggageLocation = LatLng(37.4219999, -122.0840575); // Sample location
  bool isMapReady = false;
  double _currentZoom = 15.0;

  void triggerSound() {
    print('🔊 Luggage is beeping!'); // Replace with actual Bluetooth/IoT trigger logic
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      isMapReady = true;
    });
    _setMapStyle(controller);
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    await controller.setMapStyle(MapStyles.lightStyle);
  }

  void _centerOnLuggage() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: luggageLocation,
          zoom: 17.0,
          tilt: 45.0,
        ),
      ),
    );
  }

  void _zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(1.0, 20.0);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: luggageLocation,
          zoom: _currentZoom,
        ),
      ),
    );
  }

  void _zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(1.0, 20.0);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: luggageLocation,
          zoom: _currentZoom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: luggageLocation,
              zoom: _currentZoom,
            ),
            markers: {
              Marker(
                markerId: MarkerId('luggage'),
                position: luggageLocation,
                infoWindow: InfoWindow(
                  title: 'My Luggage',
                  snippet: 'Last seen 2 minutes ago',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              ),
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false, // Disable default zoom controls since we have custom ones
            compassEnabled: true,
            onCameraMove: (CameraPosition position) {
              _currentZoom = position.zoom;
            },
          ),
          if (isMapReady) ...[
            // Distance Card
            Positioned(
              top: topPadding + 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Distance: 120m away',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32.0), // Add padding to prevent buttons from stretching too wide
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end, // Ensure everything aligns to the right
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
              mainAxisSize: MainAxisSize.min, // Make row take minimum space needed
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoomOut',
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove, color: Colors.white),
                  backgroundColor: Colors.indigo,
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: 'center',
                  onPressed: _centerOnLuggage,
                  child: Icon(Icons.center_focus_strong, color: Colors.white),
                  backgroundColor: Colors.indigo,
                ),
                SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'zoomIn',
                  onPressed: _zoomIn,
                  child: Icon(Icons.add, color: Colors.white),
                  backgroundColor: Colors.indigo,
                ),
              ],
            ),
            SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'ring',
              onPressed: () {
                triggerSound();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.volume_up, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Signal sent to luggage'),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.volume_up, color: Colors.white),
              label: Text(
                'Ring Luggage',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}
