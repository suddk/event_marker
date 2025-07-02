import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../events/event_list_screen.dart';
import 'group_requests_screen.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final groupController = Provider.of<GroupController>(context, listen: false);
    final userId = authController.currentUser?.uid;
    if (userId != null) {
      await groupController.getUserGroups(userId);
    }
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController _groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Group'),
        content: TextField(
          controller: _groupNameController,
          decoration: const InputDecoration(hintText: 'Group Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _groupNameController.text.trim();
              if (name.isEmpty) return;

              final authController = Provider.of<AuthController>(context, listen: false);
              final groupController = Provider.of<GroupController>(context, listen: false);
              final adminId = authController.currentUser?.uid ?? '';

              await groupController.createGroup(name, adminId);
              Navigator.pop(context);
              await _loadGroups();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context),
          ),
        ],
      ),
      body: groupController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupController.groups.isEmpty
              ? const Center(child: Text('You are not part of any group.'))
              : ListView.builder(
                  itemCount: groupController.groups.length,
                  itemBuilder: (context, index) {
                    final group = groupController.groups[index];
                    final groupId = group['id'];
                    final groupName = group['name'] ?? '';
                    final members = group['members'] ?? [];

                    return ListTile(
                      title: Text(groupName),
                      subtitle: Text('Members: ${members.length}'),
                      onTap: () {
                        final eventController = Provider.of<EventController>(context, listen: false);
                        eventController.loadGroupEvents(groupId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EventListScreen(),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.group_add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GroupRequestsScreen(groupId: groupId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
