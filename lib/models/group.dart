class Group {
  final String id;
  final String name;
  final String createdBy;
  final List<String> members;
  final List<String> pendingRequests;

  Group({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.members,
    required this.pendingRequests,
  });

  factory Group.fromMap(Map<String, dynamic> data, String documentId) {
    return Group(
      id: documentId,
      name: data['name'] ?? '',
      createdBy: data['createdBy'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      pendingRequests: List<String>.from(data['pendingRequests'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createdBy': createdBy,
      'members': members,
      'pendingRequests': pendingRequests,
    };
  }
}
