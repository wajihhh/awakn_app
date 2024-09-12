




import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autostart/flutter_autostart.dart';

class Autostart2 extends StatefulWidget {
  const Autostart2({super.key});

  @override
  State<Autostart2> createState() => _Autostart2State();
}

class _Autostart2State extends State<Autostart2> {
  final _flutterAutostartPlugin = FlutterAutostart();
  String _deviceManufacturer = '';

  @override
  void initState() {
    super.initState();
    _getDeviceManufacturer();
  }

  Future<void> _getDeviceManufacturer() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      setState(() {
        _deviceManufacturer = androidInfo.manufacturer?.toLowerCase() ?? '';
      });
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

  Future<void> checkIsAutoStartEnabled() async {
    String isAutoStartEnabled;
    try {
      isAutoStartEnabled = await _flutterAutostartPlugin.checkIsAutoStartEnabled() == true ? "Yes" : "No";
      print("isAutoStartEnabled: $isAutoStartEnabled");
    } on PlatformException {
      isAutoStartEnabled = 'Failed to check isAutoStartEnabled.';
    }
    if (!mounted) return;
  }

  Future<void> openAutoStartPermissionSettings() async {
    try {
      if (_deviceManufacturer.contains('xiaomi')) {
        const MethodChannel('com.example.auto_start')
            .invokeMethod('openXiaomiAutoStart');
      } else if (_deviceManufacturer.contains('oppo') || _deviceManufacturer.contains('realme')) {
        const MethodChannel('com.example.auto_start')
            .invokeMethod('openOppoAutoStart');
      } else if (_deviceManufacturer.contains('vivo')) {
        const MethodChannel('com.example.auto_start')
            .invokeMethod('openVivoAutoStart');
      } else if (_deviceManufacturer.contains('huawei')) {
        const MethodChannel('com.example.auto_start')
            .invokeMethod('openHuaweiAutoStart');
      } else {
        await _flutterAutostartPlugin.showAutoStartPermissionSettings();
      }
    } on PlatformException {
      print('Failed to show auto-start permission.');
    }
    if (!mounted) return;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter AutoStart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                checkIsAutoStartEnabled();
              },
              child: const Text("Check is auto-start enabled",style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              onPressed: () {
                openAutoStartPermissionSettings();
              },
              child: const Text("Request auto-start permission",style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ),
    );
  }
}
