import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CloudSync {
  Future<void> saveSnapshot(Map<String, dynamic> snapshot, String id);
  Future<Map<String, dynamic>?> getSnapshot(String id);
  bool snapshotNeedsToBeUploaded(Map<String, dynamic> snapshot);

  DateTime? get lastUpdatedTime;
  bool snapshotIsUploaded(Map<String, dynamic> snapshot);
}

class CloudFirestoreSync implements CloudSync {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final collectionName = 'campaigns';
  late SharedPreferencesWithCache sharedPreferences;

  CloudFirestoreSync() {
    SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions()).then(
      (value) => sharedPreferences = value,
    );
  }

  Map<String, dynamic> lastSnapshotUploaded = {};
  Map<String, dynamic> lastSnapshot = {};

  @override
  Future<Map<String, dynamic>?> getSnapshot(String id) async {
    final user = auth.currentUser;

    if (user == null) {
      return null;
    }

    DocumentSnapshot<Map<String, dynamic>>? snapshot;

    try {
      snapshot = await db.collection('campaigns').doc("${user.uid}_$id").get(
            GetOptions(source: Source.cache),
          );
    } catch (e) {
      try {
        snapshot = await db.collection('campaigns').doc("${user.uid}_$id").get(
              GetOptions(source: Source.serverAndCache),
            );
      } catch (e) {
        snapshot = null;
      }
    }

    return snapshot?.data();
  }

  @override
  Future<void> saveSnapshot(Map<String, dynamic> snapshot, String id) async {
    final user = auth.currentUser;

    if (user == null) {
      return;
    }

    await db.collection('campaigns').doc("${user.uid}_$id").set(snapshot);

    sharedPreferences.setInt('lastUpdatedTime', DateTime.now().millisecondsSinceEpoch);
    lastSnapshotUploaded = snapshot;
    lastSnapshot = snapshot;
    return;
  }

  @override
  DateTime? get lastUpdatedTime {
    try {
      final lastUpdatedTime = sharedPreferences.getInt('lastUpdatedTime');

      if (lastUpdatedTime == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(lastUpdatedTime);
    } catch (e) {
      return null;
    }
  }

  @override
  bool snapshotIsUploaded(Map<String, dynamic> snapshot) {
    return lastSnapshotUploaded.equals(snapshot);
  }

  @override
  bool snapshotNeedsToBeUploaded(Map<String, dynamic> snapshot) {
    final needsToBeUpload = !snapshot.equals(lastSnapshotUploaded) && snapshot.equals(lastSnapshot);
    lastSnapshot = snapshot;
    return needsToBeUpload;
  }
}

extension on Map<String, dynamic> {
  bool equals(Map<String, dynamic> other) {
    return this.toString().hashCode == other.toString().hashCode;
  }
}
