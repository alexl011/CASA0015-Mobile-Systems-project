import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles/map_styles.dart';
import 'services/gps_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
                      style: const TextStyle(
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
                style: const TextStyle(
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
                style: const TextStyle(
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
                style: const TextStyle(
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
                    style: const TextStyle(
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
    double remainingWeight = maxWeight - luggageWeight;

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Weight Monitor',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Track and manage your luggage weight',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Weight Indicator Section
              Center(
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 130.0,
                      lineWidth: 15.0,
                      percent: percent,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${luggageWeight.toStringAsFixed(1)}",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "kg",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      progressColor: isOverweight ? Colors.red : Colors.indigo,
                      backgroundColor: Colors.grey.shade200,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                    ),
                    SizedBox(height: 24),
                    // Weight Status Card
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isOverweight ? Colors.red.shade50 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOverweight ? Colors.red.shade200 : Colors.green.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOverweight ? Icons.warning : Icons.check_circle,
                            color: isOverweight ? Colors.red : Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isOverweight
                                ? 'Overweight by ${(-remainingWeight).toStringAsFixed(1)} kg'
                                : '${remainingWeight.toStringAsFixed(1)} kg remaining',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Weight Limit Section
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Weight Limit",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "${maxWeight.toStringAsFixed(1)} kg",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Adjust the maximum weight limit:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Slider(
                        value: maxWeight,
                        min: 10,
                        max: 50,
                        divisions: 40,
                        label: maxWeight.toStringAsFixed(1),
                        activeColor: Colors.indigo,
                        onChanged: (value) {
                          setState(() {
                            maxWeight = value;
                          });
                          _saveWeightLimit(value);
                        },
                      ),
                      // Weight Range Indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "10 kg",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "50 kg",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
  LatLng? luggageLocation;
  bool isMapReady = false;
  double _currentZoom = 15.0;
  final GPSService _gpsService = GPSService();
  BluetoothDevice? _selectedDevice;
  bool _isConnecting = false;
  bool _isScanning = false;
  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _checkAndStartScan();
  }

  Future<void> _checkAndStartScan() async {
    if (!_gpsService.isConnected) {
      await _startScan();
    }
  }

  Future<void> _startScan() async {
    if (_isScanning) return; // Prevent multiple concurrent scans

    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    try {
      final devices = await _gpsService.scanForDevices();
      setState(() {
        _devices = devices;
        _isScanning = false;
      });

      if (devices.isNotEmpty) {
        _showDeviceSelectionDialog();
      } else {
        _showNoDevicesFoundDialog();
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning for devices: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _showNoDevicesFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.bluetooth_disabled, color: Colors.grey),
            SizedBox(width: 8),
            Text('No Devices Found'),
          ],
        ),
        content: Text('No Bluetooth devices were found. Make sure your GPS module is turned on and within range.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startScan();
            },
            child: Text('Try Again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeviceSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxWidth: 340,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with explanation
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.gps_fixed,
                      color: Colors.indigo,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connect GPS Module',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _isScanning ? 'Scanning for GPS modules...' : '${_devices.length} devices available',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isScanning)
                    Container(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),
              // Help text
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select your GPS module from the list below. Make sure it\'s turned on and in range.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),

              // Devices List
              if (_devices.isEmpty && !_isScanning) ...[
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.gps_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No GPS modules found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Make sure your GPS module is turned on\nand within range',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _devices.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      final name = device.platformName.isEmpty ? 'Unknown Device' : device.platformName;
                      final bool isLikelyGPS = name.toLowerCase().contains('gps') || 
                                             name.toLowerCase().contains('neo') ||
                                             name.toLowerCase().contains('gnss');
                      
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _selectedDevice = device;
                            Navigator.pop(context);
                            _connectToDevice();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isLikelyGPS ? Colors.green[50] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    isLikelyGPS ? Icons.gps_fixed : Icons.bluetooth,
                                    color: isLikelyGPS ? Colors.green : Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: isLikelyGPS ? Colors.black87 : Colors.grey[600],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isLikelyGPS)
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'GPS',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        device.remoteId.str,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              // Actions
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _isScanning ? null : () {
                      Navigator.pop(context);
                      _startScan();
                    },
                    icon: Icon(Icons.refresh, size: 18),
                    label: Text('RESCAN'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectToDevice() async {
    if (_selectedDevice == null) return;

    setState(() {
      _isConnecting = true;
    });

    try {
      await _gpsService.connectToGPS();
      
      setState(() {
        _isConnecting = false;  // Set connecting state to false after successful connection
      });

      _gpsService.locationStream.listen((location) {
        setState(() {
          luggageLocation = LatLng(location['latitude']!, location['longitude']!);
        });
        _updateMap();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to GPS module')),
      );
    } catch (e) {
      setState(() {
        _isConnecting = false;  // Set connecting state to false after failed connection
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to GPS module: $e')),
      );
    }
  }

  void _updateMap() {
    if (mapController != null && luggageLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(luggageLocation!),
      );
    }
  }

  @override
  void dispose() {
    _gpsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              setState(() {
                isMapReady = true;
              });
              _setMapStyle(controller);
            },
            initialCameraPosition: CameraPosition(
              target: luggageLocation ?? LatLng(37.4219999, -122.0840575),
              zoom: _currentZoom,
            ),
            markers: luggageLocation == null ? {} : {
              Marker(
                markerId: MarkerId('luggage'),
                position: luggageLocation!,
                infoWindow: InfoWindow(
                  title: 'My Luggage',
                  snippet: 'Last updated: ${DateTime.now().toString().split('.').first}',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              ),
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            onCameraMove: (CameraPosition position) {
              _currentZoom = position.zoom;
            },
          ),
          if (isMapReady) ...[
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
                        style: const TextStyle(
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
          if (_isConnecting)
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Connecting to GPS module...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_gpsService.isConnected)
            FloatingActionButton(
              heroTag: 'scan',
              onPressed: _startScan,
              child: Icon(Icons.bluetooth_searching, color: Colors.white),
              backgroundColor: Colors.indigo,
            ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'center',
            onPressed: _centerOnLuggage,
            child: Icon(Icons.center_focus_strong, color: Colors.white),
            backgroundColor: Colors.indigo,
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.indigo,
          ),
        ],
      ),
    );
  }

  void triggerSound() {
    print('🔊 Luggage is beeping!'); // Replace with actual Bluetooth/IoT trigger logic
  }

  void _centerOnLuggage() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: luggageLocation ?? LatLng(37.4219999, -122.0840575),
          zoom: 17.0,
          tilt: 45.0,
        ),
      ),
    );
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    await controller.setMapStyle(MapStyles.lightStyle);
  }
}
