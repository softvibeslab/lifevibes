/// Firebase configuration constants
class FirebaseConstants {
  static const String projectId = 'lifevibes-e5915';
  static const String storageBucket = 'lifevibes-e5915.firebasestorage.app';
  static const String databaseUrl = 'https://lifevibes-e5915-default-rtdb.firebaseio.com';

  // Collection names
  static const String usersCollection = 'users';
  static const String avatarsCollection = 'avatars';
  static const String questsCollection = 'quests';
  static const String matchesCollection = 'matches';
  static const String contentPiecesCollection = 'content_pieces';
  static const String funnelsCollection = 'funnels';
  static const String productsCollection = 'products';

  // Avatar stats
  static const int baseXP = 0;
  static const int baseLevel = 1;
  static const int xpPerLevel = 100;
}
