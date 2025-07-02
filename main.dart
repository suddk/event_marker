import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:event_marker/controllers/auth_controller.dart';
import 'package:event_marker/controllers/group_controller.dart';
import 'package:event_marker/controllers/event_controller.dart';
import 'package:event_marker/firebase_options.dart';
import 'package:event_marker/screens/auth/login_screen.dart';
import 'package:event_marker/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EventMarkerApp());
}

class EventMarkerApp extends StatelessWidget {
  const EventMarkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => GroupController()),
        ChangeNotifierProvider(create: (_) => EventController()),
      ],
      child: MaterialApp(
        title: 'Event Marker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
