import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'mainScreen.dart';

//TODO: App ID Onesignal anda
const String appId = "MASUKAN APP ID ONESIGNAL ANDA";

void main() => runApp(
      MaterialApp(
        home: Root(),
      ),
    );

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    OneSignal.shared.init(appId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}
