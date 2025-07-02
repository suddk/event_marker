import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/group_controller.dart';

class GroupRequestsScreen extends StatefulWidget {
  final String groupId;

  const GroupRequestsScreen({super.key, required this.groupId});

  @override
  State<GroupRequestsScreen> createState() => _GroupRequestsScreenState();
}

class _GroupRequestsScreenState extends State<GroupRequestsScreen> {
  Map<String, String> _userNames = {};
  List<String> _pendingRequests = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final groupController = Provider.of<GroupController>(context, listen: false);
      final pending = await groupController.getPendingRequests(widget.groupId);
      final names = await groupController.getUserNames(pending);

      setState(() {
        _pendingRequests = pending;
        _userNames = names;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load requests';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Pending Requests')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _pendingRequests.isEmpty
                  ? const Center(child: Text('No pending join requests.'))
                  : ListView.builder(
                      itemCount: _pendingRequests.length,
                      itemBuilder: (context, index) {
                        final userId = _pendingRequests[index];
                        final userName = _userNames[userId] ?? userId;

                        return ListTile(
                          title: Text(userName),
                          subtitle: Text(userId),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () async {
                                  await groupController.approveUser(widget.groupId, userId);
                                  _loadPendingRequests(); // Refresh
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  await groupController.rejectUser(widget.groupId, userId);
                                  _loadPendingRequests(); // Refresh
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
