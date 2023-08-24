import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson_prepare/services/fcm_service.dart';
import 'package:lesson_prepare/services/remote_config.dart';
import 'firebase_options.dart';

final fcm = FCMService();
final rcs = RCService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// For Firebase Messaging
  await fcm.init();

  /// For Remote Config
  await rcs.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    fcm.requestMessagingPermission();
    fcm.generateToken();

    /// remote config
    rcs.activate().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rcs.title),
      ),
      backgroundColor: Color(rcs.color),
      body: Center(
        child: Column(
          children: [
            if(rcs.showAdd) Card(
              margin: const EdgeInsets.all(20),
              child: ListTile(
                leading: Image(image: NetworkImage(rcs.add.imageUrl), fit: BoxFit.cover,),
                title: Text(rcs.add.title),
                subtitle: Text(rcs.add.description),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                fcm.sendMessageForOne();
              },
              child: const Text("Press Me"),
            ),
          ],
        ),
      ),
    );
  }
}
