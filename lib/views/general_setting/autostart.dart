import 'package:autostart_settings/autostart_settings.dart';
import 'package:flutter/material.dart';

class Autostart extends StatefulWidget {
  const Autostart({super.key});

  @override
  State<Autostart> createState() => _AutostartState();
}

class _AutostartState extends State<Autostart> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final canOpen = await AutostartSettings.canOpen(
                      autoStart: true, batterySafer: true);
                  setState(() {
                    if (canOpen) {
                      _text = 'device can open autostart Settings';
                    } else {
                      _text = 'device doesn\'t have autostart settings activity';
                    }
                  });
                },
                child: const Text('Can open autostart settings',style: TextStyle(color: Colors.red),),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final opened = await AutostartSettings.open(
                      autoStart: true, batterySafer: true);
                  setState(() {
                    _text = 'Settings opened: $opened';
                  });
                },
                child: const Text('Open autostart Settings',style: TextStyle(color: Colors.red),),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_text),
            )
          ],
        ),
      ),
    );
  }
}