import 'package:cloud_firestore/cloud_firestore.dart';

class CounsellorAssignmentModel {
  final String userId;
  final String counsellorId;
  final DateTime assignedAt;
  final DateTime? unassignedAt;
  final bool isActive;
  final String? notes;

  CounsellorAssignmentModel({
    required this.userId,
    required this.counsellorId,
    required this.assignedAt,
    this.unassignedAt,
    this.isActive = true,
    this.notes,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'counsellorId': counsellorId,
      'assignedAt': Timestamp.fromDate(assignedAt),
      'unassignedAt': unassignedAt != null
          ? Timestamp.fromDate(unassignedAt!)
          : null,
      'isActive': isActive,
      'notes': notes,
    };
  }

  // Create from Firestore document
  factory CounsellorAssignmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return CounsellorAssignmentModel(
      userId: snapshot.id,
      counsellorId: data['counsellorId'] ?? '',
      assignedAt: (data['assignedAt'] as Timestamp).toDate(),
      unassignedAt: data['unassignedAt'] != null
          ? (data['unassignedAt'] as Timestamp).toDate()
          : null,
      isActive: data['isActive'] ?? true,
      notes: data['notes'],
    );
  }

  // Copy with method
  CounsellorAssignmentModel copyWith({
    String? userId,
    String? counsellorId,
    DateTime? assignedAt,
    DateTime? unassignedAt,
    bool? isActive,
    String? notes,
  }) {
    return CounsellorAssignmentModel(
      userId: userId ?? this.userId,
      counsellorId: counsellorId ?? this.counsellorId,
      assignedAt: assignedAt ?? this.assignedAt,
      unassignedAt: unassignedAt ?? this.unassignedAt,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }
}
