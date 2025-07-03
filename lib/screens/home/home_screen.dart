import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/event_controller.dart';
import '../group/group_list_screen.dart';
import '../events/event_list_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final authController = Provider.of<AuthController>(context, listen: false);
    final groupController = Provider.of<GroupController>(context, listen: false);
    final eventController = Provider.of<EventController>(context, listen: false);
    final userId = authController.currentUser?.uid ?? '';

    groupController.getUserGroups(userId);
    eventController.getEventsForUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Marker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: GroupListScreen()),
          Divider(height: 1),
          Expanded(child: EventListScreen()),
        ],
      ),
    );
  }
}
