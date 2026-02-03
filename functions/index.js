/**
 * Firebase Cloud Functions for LifeVibes
 *
 * Functions:
 * - onUserCreate: Initialize user profile and avatar when a new user signs up
 * - calculateMatch: Calculate compatibility between two users (Softvibes algorithm)
 * - generateAvatarManifesto: Generate avatar manifesto with PoppyAI
 * - coachChat: Generate coach responses with PoppyAI
 * - assignDailyQuest: Assign daily quest to user
 * - validateQuestCompletion: Validate quest and award XP
 */

const admin = require('firebase-admin');
const functions = require('firebase-functions');

// Initialize Firebase Admin
admin.initializeApp();

// Firestore and Auth references
const db = admin.firestore();
const auth = admin.auth();

/**
 * Trigger: onUserCreate
 * Fires when a new user is created via Firebase Auth
 * Actions:
 * - Create user profile document
 * - Create default avatar
 * - Initialize gamification stats
 */
exports.onUserCreate = functions.auth.user().onCreate(async (user) => {
  const userId = user.uid;
  const timestamp = admin.firestore.FieldValue.serverTimestamp();

  try {
    // Create user profile
    await db.collection('users').doc(userId).set({
      email: user.email,
      displayName: user.displayName || '',
      photoURL: user.photoURL || '',
      createdAt: timestamp,
      updatedAt: timestamp,
      completedOnboarding: false,
      currentPhase: 'SER', // SER, HACER, TENER
      level: 1,
      xp: 0,
      badges: [],
      streak: 0,
      lastActiveDate: timestamp,
    });

    // Create default avatar
    await db.collection('avatars').doc(userId).set({
      faceType: 'round',
      eyeStyle: 'normal',
      eyeColor: '#4A5568',
      mouthStyle: 'smile',
      hairStyle: 'short',
      hairColor: '#1A202C',
      skinColor: '#FBD38D',
      outfit: 'casual',
      accessories: [],
      level: 1,
      xp: 0,
      badges: [],
      lastUpdated: timestamp,
    });

    // Initialize user stats
    await db.collection('user_stats').doc(userId).set({
      totalQuestsCompleted: 0,
      totalContentGenerated: 0,
      totalMatches: 0,
      totalMessages: 0,
      createdAt: timestamp,
      updatedAt: timestamp,
    });

    console.log(`User profile created for: ${userId}`);
    return null;
  } catch (error) {
    console.error('Error creating user profile:', error);
    throw error;
  }
});

/**
 * Callable: calculateMatch
 * Calculate Softvibes compatibility between two users
 * Algorithm:
 * - Common values: 40%
 * - Aligned purposes: 30%
 * - Complementary skills: 20%
 * - Similar interests: 10%
 */
exports.calculateMatch = functions.https.onCall(async (data, context) => {
  // Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated',
    );
  }

  const { targetUserId } = data;
  const currentUserId = context.auth.uid;

  try {
    // Get both user profiles
    const [currentUserDoc, targetUserDoc] = await Promise.all([
      db.collection('users').doc(currentUserId).get(),
      db.collection('users').doc(targetUserId).get(),
    ]);

    if (!currentUserDoc.exists || !targetUserDoc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'One or both users not found',
      );
    }

    const currentUser = currentUserDoc.data();
    const targetUser = targetUserDoc.data();

    // Calculate match score (placeholder - implement actual algorithm)
    const matchScore = Math.floor(Math.random() * 40) + 60; // 60-100 for demo

    // Save match result
    const matchId = [currentUserId, targetUserId].sort().join('_');
    await db.collection('matches').doc(matchId).set({
      userId1: currentUserId,
      userId2: targetUserId,
      matchScore,
      matchDate: admin.firestore.FieldValue.serverTimestamp(),
      status: 'pending', // pending, accepted, rejected
    }, { merge: true });

    return {
      matchScore,
      matchId,
      targetUser: {
        displayName: targetUser.displayName,
        photoURL: targetUser.photoURL,
        level: targetUser.level,
        currentPhase: targetUser.currentPhase,
      },
    };
  } catch (error) {
    console.error('Error calculating match:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message,
    );
  }
});

/**
 * Callable: generateAvatarManifesto
 * Generate manifesto for user avatar using PoppyAI
 */
exports.generateAvatarManifesto = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated',
    );
  }

  const { usuario, valores, proposito, superpoder } = data;
  const userId = context.auth.uid;

  try {
    // TODO: Call PoppyAI API to generate manifesto
    // For now, return placeholder
    const manifesto = `
# Manifiesto de ${usuario}

## Nuestra Promesa
Transformamos ${valores} en acción concreta.

## Nuestra Misión
${proposito}

## Nuestro Superpoder
${superpoder}

---

Generado por LifeVibes 🗿
    `.trim();

    // Update avatar with manifesto
    await db.collection('avatars').doc(userId).update({
      manifesto,
      manifestoGeneratedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { manifesto };
  } catch (error) {
    console.error('Error generating manifesto:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message,
    );
  }
});

/**
 * Callable: coachChat
 * Generate coach response using PoppyAI
 */
exports.coachChat = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated',
    );
  }

  const { message } = data;
  const userId = context.auth.uid;

  try {
    // TODO: Call PoppyAI API to generate response
    // For now, return placeholder response
    const response = `
¡Hola! 👋 Entiendo que ${message}.

Desde la metodología Softvibes1, te sugiero:

1. **Diagnóstico**: Identifica dónde estás (SER/HACER/TENER)
2. **Prioridad**: ¿Qué es lo más importante AHORA?
3. **Acción**: ¿Cuál es el siguiente paso más simple?

¿Quieres que te ayude con algo específico?

Buena vibra 🗿
    `.trim();

    // Save conversation
    await db.collection('coach_chats').doc(userId).collection('messages').add({
      userId,
      message,
      response,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Update user stats
    await db.collection('user_stats').doc(userId).update({
      totalMessages: admin.firestore.FieldValue.increment(1),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { response };
  } catch (error) {
    console.error('Error generating coach response:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message,
    );
  }
});

/**
 * Callable: assignDailyQuest
 * Assign a daily quest to the user
 */
exports.assignDailyQuest = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated',
    );
  }

  const userId = context.auth.uid;
  const today = new Date().toISOString().split('T')[0];

  try {
    // Check if quest already assigned for today
    const existingQuest = await db
      .collection('quests')
      .where('userId', '==', userId)
      .where('date', '==', today)
      .limit(1)
      .get();

    if (!existingQuest.empty) {
      return {
        questId: existingQuest.docs[0].id,
        quest: existingQuest.docs[0].data(),
      };
    }

    // Assign new quest (random selection for demo)
    const quests = [
      {
        title: 'Define tu "Por Qué"',
        description: 'Escribe 3 párrafos sobre por qué haces lo que haces',
        phase: 'SER',
        xpReward: 50,
      },
      {
        title: 'Crea tu Primer Contenido',
        description: 'Publica algo que aporte valor a tu audiencia',
        phase: 'HACER',
        xpReward: 75,
      },
      {
        title: 'Conecta con 3 Personas',
        description: 'Reach out y ofrece valor primero',
        phase: 'HACER',
        xpReward: 60,
      },
    ];

    const randomQuest = quests[Math.floor(Math.random() * quests.length)];

    // Create quest document
    const questRef = await db.collection('quests').add({
      userId,
      title: randomQuest.title,
      description: randomQuest.description,
      phase: randomQuest.phase,
      xpReward: randomQuest.xpReward,
      date: today,
      status: 'pending', // pending, in_progress, completed
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      questId: questRef.id,
      quest: (await questRef.get()).data(),
    };
  } catch (error) {
    console.error('Error assigning daily quest:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message,
    );
  }
});

/**
 * Callable: validateQuestCompletion
 * Validate quest completion and award XP
 */
exports.validateQuestCompletion = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated',
    );
  }

  const { questId } = data;
  const userId = context.auth.uid;

  try {
    // Get quest
    const questDoc = await db.collection('quests').doc(questId).get();

    if (!questDoc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'Quest not found',
      );
    }

    const quest = questDoc.data();

    if (quest.userId !== userId) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Quest does not belong to user',
      );
    }

    if (quest.status === 'completed') {
      throw new functions.https.HttpsError(
        'already-exists',
        'Quest already completed',
      );
    }

    // Mark quest as completed
    await db.collection('quests').doc(questId).update({
      status: 'completed',
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Award XP to user
    await db.runTransaction(async (transaction) => {
      const userRef = db.collection('users').doc(userId);
      const userDoc = await transaction.get(userRef);
      const userData = userDoc.data();

      const newXp = (userData.xp || 0) + quest.xpReward;
      const newLevel = Math.floor(newXp / 100) + 1;

      // Check if level up
      const oldLevel = userData.level || 1;
      const leveledUp = newLevel > oldLevel;

      // Update user XP and level
      transaction.update(userRef, {
        xp: newXp,
        level: newLevel,
        streak: admin.firestore.FieldValue.increment(1),
        lastActiveDate: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Update avatar XP and level
      const avatarRef = db.collection('avatars').doc(userId);
      transaction.update(avatarRef, {
        xp: newXp,
        level: newLevel,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Update user stats
      const statsRef = db.collection('user_stats').doc(userId);
      transaction.update(statsRef, {
        totalQuestsCompleted: admin.firestore.FieldValue.increment(1),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return { leveledUp, newLevel };
    });

    return {
      success: true,
      xpAwarded: quest.xpReward,
    };
  } catch (error) {
    console.error('Error validating quest completion:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message,
    );
  }
});
