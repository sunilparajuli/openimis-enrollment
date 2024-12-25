import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';

class NotificationSettingsPage extends StatefulWidget {


  // Pass the method from your controller as a parameter
  const NotificationSettingsPage();


  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final CustomerProfileController controller = Get.put(CustomerProfileController());
  bool _notificationsEnabled = false;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Check Notification Status and Fetch FCM Token
  Future<void> _initializeNotifications() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _fetchFcmToken();
      setState(() {
        _notificationsEnabled = true;
      });
    }
  }

  // Fetch FCM Token Using Controller's Method
  Future<void> _fetchFcmToken() async {
    String? token = await controller.getFcmDeviceToken();
    setState(() {
      _fcmToken = token;
    });
  }

  // Enable or Disable Notifications
  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await _fetchFcmToken();
        setState(() {
          _notificationsEnabled = true;
        });
      } else {
        setState(() {
          _notificationsEnabled = false;
        });
      }
    } else {
      setState(() {
        _notificationsEnabled = false;
        _fcmToken = null;
      });
      print("Notifications Disabled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enable Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    if (value != null) {
                      await _toggleNotifications(value);
                    }
                  },
                ),
                Text(
                  _notificationsEnabled
                      ? 'Notifications are enabled'
                      : 'Enable notifications',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_notificationsEnabled && _fcmToken != null)
              Text(
                'FCM Token:\n$_fcmToken',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            if (!_notificationsEnabled)
              Text(
                'Notifications are disabled. Enable them to receive updates.',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
