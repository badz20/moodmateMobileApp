import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/counsellor_assignment_model.dart';
import '../models/user_model.dart';

class CounsellorAssignmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'counsellor_assignments';

  // Assign a user to a counsellor
  Future<void> assignUserToCounsellor({
    required String userId,
    required String counsellorId,
    String? notes,
  }) async {
    try {
      final assignment = CounsellorAssignmentModel(
        userId: userId,
        counsellorId: counsellorId,
        assignedAt: DateTime.now(),
        isActive: true,
        notes: notes,
      );

      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .set(assignment.toFirestore());
    } catch (e) {
      throw Exception('Failed to assign user to counsellor: $e');
    }
  }

  // Unassign a user from counsellor
  Future<void> unassignUser(String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'isActive': false,
        'unassignedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to unassign user: $e');
    }
  }

  // Get assigned users for a counsellor
  Future<List<String>> getAssignedUserIds(String counsellorId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('counsellorId', isEqualTo: counsellorId)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('Failed to fetch assigned users: $e');
    }
  }

  // Get assigned users with details for a counsellor
  Future<List<UserModel>> getAssignedUsers(String counsellorId) async {
    try {
      final userIds = await getAssignedUserIds(counsellorId);

      if (userIds.isEmpty) {
        return [];
      }

      final userDocs = await Future.wait(
        userIds.map(
          (userId) => _firestore.collection('users').doc(userId).get(),
        ),
      );

      return userDocs
          .where((doc) => doc.exists)
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch assigned user details: $e');
    }
  }

  // Get counsellor for a user
  Future<String?> getCounsellorForUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final assignment = CounsellorAssignmentModel.fromFirestore(doc);
      return assignment.isActive ? assignment.counsellorId : null;
    } catch (e) {
      throw Exception('Failed to fetch counsellor for user: $e');
    }
  }

  // Check if user is assigned to counsellor
  Future<bool> isUserAssignedToCounsellor({
    required String userId,
    required String counsellorId,
  }) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return false;
      }

      final assignment = CounsellorAssignmentModel.fromFirestore(doc);
      return assignment.isActive && assignment.counsellorId == counsellorId;
    } catch (e) {
      throw Exception('Failed to check assignment: $e');
    }
  }

  // Stream assigned users
  Stream<List<UserModel>> streamAssignedUsers(String counsellorId) {
    return _firestore
        .collection(_collectionName)
        .where('counsellorId', isEqualTo: counsellorId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.docs.isEmpty) {
            return <UserModel>[];
          }

          final userIds = snapshot.docs.map((doc) => doc.id).toList();
          final userDocs = await Future.wait(
            userIds.map(
              (userId) => _firestore.collection('users').doc(userId).get(),
            ),
          );

          return userDocs
              .where((doc) => doc.exists)
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();
        });
  }

  // Update assignment notes
  Future<void> updateAssignmentNotes(String userId, String notes) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'notes': notes,
      });
    } catch (e) {
      throw Exception('Failed to update assignment notes: $e');
    }
  }
}
