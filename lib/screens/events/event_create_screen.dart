import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../controllers/event_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/group_controller.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;
  String? _selectedGroupId;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submit() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final eventController = Provider.of<EventController>(context, listen: false);

    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final date = _selectedDate;
    final groupId = _selectedGroupId;
    final user = authController.currentUser;

    if (title.isEmpty || desc.isEmpty || date == null || user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    await eventController.createEvent(
      title: title,
      description: desc,
      date: date,
      createdBy: user.uid,
      groupId: groupId,
      imageFile: _selectedImage,
    );

    if (context.mounted) Navigator.pop(context); // back after creation
  }

  @override
  Widget build(BuildContext context) {
    final groupController = Provider.of<GroupController>(context);
    final eventController = Provider.of<EventController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select Date'
                  : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 2),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Group (optional)'),
              value: _selectedGroupId,
              items: groupController.groups
                  .map<DropdownMenuItem<String>>((group) => DropdownMenuItem<String>(
                    value: group['id'],
                    child: Text(group['name'] ?? 'Unnamed Group'),
                  ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedGroupId = val),
            ),
            const SizedBox(height: 10),
            _selectedImage == null
                ? TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Upload Image'),
                  )
                : Image.file(_selectedImage!, height: 150),
            const SizedBox(height: 20),
            eventController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Create Event'),
                  ),
          ],
        ),
      ),
    );
  }
}
