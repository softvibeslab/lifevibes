import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lifevibes/features/avatar/models/avatar.dart';
import 'package:lifevibes/core/constants/firebase_constants.dart';

/// Avatar service for Firebase Firestore operations
class AvatarService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  AvatarService({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  /// Get user's avatar reference
  DocumentReference _getAvatarRef(String userId) {
    return _firestore
        .collection(FirebaseConstants.avatarsCollection)
        .doc(userId);
  }

  /// Create a new avatar
  Future<Avatar> createAvatar({
    required String name,
    String description = '',
    Map<String, int>? superpowers,
    String appearance = '',
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final avatar = Avatar(
      id: userId!,
      userId: userId,
      name: name,
      description: description,
      superpowers: superpowers ?? {},
      appearance: appearance,
      createdAt: DateTime.now(),
    );

    await _getAvatarRef(userId).set(avatar.toDocument());

    return avatar;
  }

  /// Get user's avatar
  Future<Avatar?> getAvatar() async {
    final userId = currentUserId;
    if (userId == null) {
      return null;
    }

    final docSnapshot = await _getAvatarRef(userId).get();

    if (!docSnapshot.exists) {
      return null;
    }

    return Avatar.fromDocument(
      docSnapshot.data() as Map<String, dynamic>,
      docSnapshot.id,
    );
  }

  /// Stream user's avatar (real-time updates)
  Stream<Avatar?> avatarStream() {
    final userId = currentUserId;
    if (userId == null) {
      return const Stream.empty();
    }

    return _getAvatarRef(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists
            ? Avatar.fromDocument(
                snapshot.data() as Map<String, dynamic>,
                snapshot.id,
              )
            : null);
  }

  /// Update avatar
  Future<void> updateAvatar(Avatar avatar) async {
    final userId = currentUserId;
    if (userId != avatar.userId) {
      throw Exception('Cannot update another user\'s avatar');
    }

    final updatedAvatar = avatar.copyWith(
      updatedAt: DateTime.now(),
    );

    await _getAvatarRef(userId).set(updatedAvatar.toDocument());
  }

  /// Add XP to avatar
  Future<Avatar> addXP(int xpToAdd) async {
    final avatar = await getAvatar();
    if (avatar == null) {
      throw Exception('Avatar not found');
    }

    final newXP = avatar.xp + xpToAdd;
    int newLevel = avatar.level;

    // Check if level up
    while (newXP >= newLevel * FirebaseConstants.xpPerLevel) {
      newLevel++;
    }

    return updateAvatar(avatar.copyWith(
      xp: newXP,
      level: newLevel,
    ));
  }

  /// Update avatar stats
  Future<void> updateStats({
    required int health,
    required int energy,
    required int happiness,
  }) async {
    final avatar = await getAvatar();
    if (avatar == null) {
      throw Exception('Avatar not found');
    }

    await updateAvatar(avatar.copyWith(
      health: health,
      energy: energy,
      happiness: happiness,
    ));
  }

  /// Update superpowers
  Future<void> updateSuperpowers(Map<String, int> superpowers) async {
    final avatar = await getAvatar();
    if (avatar == null) {
      throw Exception('Avatar not found');
    }

    await updateAvatar(avatar.copyWith(
      superpowers: superpowers,
    ));
  }

  /// Update avatar appearance
  Future<void> updateAppearance(String appearance) async {
    final avatar = await getAvatar();
    if (avatar == null) {
      throw Exception('Avatar not found');
    }

    await updateAvatar(avatar.copyWith(
      appearance: appearance,
    ));
  }

  /// Delete avatar
  Future<void> deleteAvatar() async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _getAvatarRef(userId).delete();
  }
}
