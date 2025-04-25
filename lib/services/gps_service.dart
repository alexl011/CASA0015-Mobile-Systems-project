import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPSService {
  static final GPSService _instance = GPSService._internal();
  factory GPSService() => _instance;
  GPSService._internal();

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  final _locationController = StreamController<Map<String, double>>.broadcast();
  bool _isConnected = false;
  Timer? _connectionTimeout;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _characteristicSubscription;

  Stream<Map<String, double>> get locationStream => _locationController.stream;

  Future<void> connectToGPS() async {
    try {
      // Check if Bluetooth is on
      if (await FlutterBluePlus.isSupported == false) {
        throw Exception('Bluetooth not supported on this device');
      }

      // Turn on Bluetooth
      if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off) {
        await FlutterBluePlus.turnOn();
      }

      print('Starting scan for GPS devices...');
      List<BluetoothDevice> devices = [];
      
      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 10),
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      await for (final result in FlutterBluePlus.scanResults) {
        for (ScanResult r in result) {
          final name = r.device.platformName.toLowerCase();
          if (name.contains('gps') || 
              name.contains('neo') || 
              name.contains('gnss')) {
            print('Found potential GPS device: ${r.device.platformName}');
            devices.add(r.device);
          }
        }
      }

      // Stop scanning
      await FlutterBluePlus.stopScan();

      if (devices.isEmpty) {
        throw Exception('No GPS devices found. Please make sure your GPS module is turned on and in range.');
      }

      // Try to connect to each device
      for (final device in devices) {
        try {
          print('Attempting to connect to ${device.platformName}');
          await device.connect(timeout: Duration(seconds: 10));
          _device = device;
          
          print('Discovering services...');
          List<BluetoothService> services = await device.discoverServices();
          
          for (BluetoothService service in services) {
            for (BluetoothCharacteristic characteristic in service.characteristics) {
              if (characteristic.properties.notify || characteristic.properties.read) {
                _characteristic = characteristic;
                
                if (characteristic.properties.notify) {
                  await characteristic.setNotifyValue(true);
                  _characteristicSubscription = characteristic.onValueReceived.listen((value) {
                    String nmeaString = utf8.decode(value);
                    _processNMEAData(nmeaString);
                  });
                }
                
                _isConnected = true;
                print('Successfully connected to ${device.platformName}');
                return;
              }
            }
          }
        } catch (e) {
          print('Failed to connect to ${device.platformName}: $e');
          continue;
        }
      }

      throw Exception('Could not establish connection with any GPS device');
    } catch (e) {
      print('Error in connectToGPS: $e');
      _isConnected = false;
      rethrow;
    }
  }

  void _processNMEAData(String nmeaString) {
    try {
      // Split the input into individual NMEA sentences
      final sentences = nmeaString.split('\r\n')
          .where((s) => s.isNotEmpty)
          .toList();

      for (final sentence in sentences) {
        if (sentence.startsWith('\$GPRMC') || 
            sentence.startsWith('\$GNRMC')) {
          final parts = sentence.split(',');
          if (parts.length >= 7 && parts[2] == 'A') { // 'A' means data is valid
            final latitude = _convertNMEAToDecimal(parts[3], parts[4]);
            final longitude = _convertNMEAToDecimal(parts[5], parts[6]);
            
            if (latitude != null && longitude != null) {
              print('Valid GPS fix: $latitude, $longitude');
              _locationController.add({
                'latitude': latitude,
                'longitude': longitude,
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error processing NMEA data: $e');
    }
  }

  double? _convertNMEAToDecimal(String coord, String direction) {
    try {
      if (coord.isEmpty || direction.isEmpty) return null;
      
      final double value = double.parse(coord);
      final degrees = value ~/ 100;
      final minutes = value % 100;
      double decimal = degrees + (minutes / 60.0);
      
      if (direction == 'S' || direction == 'W') {
        decimal = -decimal;
      }
      
      return decimal;
    } catch (e) {
      print('Error converting NMEA coordinate: $e');
      return null;
    }
  }

  bool get isConnected => _isConnected;

  Future<List<BluetoothDevice>> scanForDevices() async {
    try {
      if (await FlutterBluePlus.isSupported == false) {
        print('Bluetooth not supported on this device');
        throw Exception('Bluetooth not supported on this device');
      }

      if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off) {
        print('Bluetooth is off, attempting to turn on...');
        await FlutterBluePlus.turnOn();
      }

      List<BluetoothDevice> devices = [];
      
      print('Starting Bluetooth scan...');
      
      // Stop any existing scan
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
      
      // Start new scan
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 4),
        androidUsesFineLocation: true,
      );

      // Wait for scan to complete and collect results
      await Future.delayed(Duration(seconds: 4));
      
      final results = await FlutterBluePlus.lastScanResults;
      print('Scan complete. Found ${results.length} devices');
      
      for (ScanResult r in results) {
        String name = r.device.platformName;
        String id = r.device.remoteId.str;
        print('Adding device: $name ($id)');
        devices.add(r.device);
      }

      return devices;
    } catch (e) {
      print('Error scanning for devices: $e');
      rethrow;
    } finally {
      // Always stop scanning when done
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
    }
  }

  void dispose() {
    _connectionTimeout?.cancel();
    _connectionSubscription?.cancel();
    _characteristicSubscription?.cancel();
    _device?.disconnect();
    _locationController.close();
  }
} 