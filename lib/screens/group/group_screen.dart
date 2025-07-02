import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/auth_controller.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _joinGroupIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);
    final groupController = Provider.of<GroupController>(context, listen: false);
    if (authController.currentUser != null) {
      groupController.getUserGroups(authController.currentUser!.uid);
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _joinGroupIdController.dispose();
    super.dispose();
  }

  void _createGroup() async {
    final groupController = Provider.of<GroupController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);

    final name = _groupNameController.text.trim();
    if (name.isEmpty || authController.currentUser == null) return;

    final groupId = await groupController.createGroup(name, authController.currentUser!.uid);
    if (groupId != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group created successfully')),
      );
      _groupNameController.clear();
      groupController.getUserGroups(authController.currentUser!.uid);
    }
  }

  void _joinGroup() async {
    final groupId = _joinGroupIdController.text.trim();
    final groupController = Provider.of<GroupController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);

    if (groupId.isEmpty || authController.currentUser == null) return;

    final result = await groupController.joinGroup(groupId, authController.currentUser!.uid);
    if (result && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Join request sent')),
      );
      _joinGroupIdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context);
    final groups = groupController.groups;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Groups')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            ElevatedButton(onPressed: _createGroup, child: const Text('Create Group')),

            const SizedBox(height: 16),

            TextField(
              controller: _joinGroupIdController,
              decoration: const InputDecoration(labelText: 'Group ID to Join'),
            ),
            ElevatedButton(onPressed: _joinGroup, child: const Text('Request to Join')),

            const SizedBox(height: 20),

            const Divider(),

            Expanded(
              child: groupController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return ListTile(
                          title: Text(group['name']),
                          subtitle: Text('ID: ${group['id'] ?? 'N/A'}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
