import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CloudSync {
  Future<void> saveSnapshot(Map<String, dynamic> snapshot, String id);
  Future<Map<String, dynamic>?> getSnapshot(String id);
  Future<void> obtainSnapshots();

  bool snapshotNeedsToBeUploaded(Map<String, dynamic> snapshot);

  DateTime? get lastUpdatedTime;
  bool snapshotIsUploaded(Map<String, dynamic> snapshot);
  String getCampaignName(String id);
}

class CloudFirestoreSync implements CloudSync {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final collectionName = 'campaigns';
  late SharedPreferences sharedPreferences;

  Map<String, Map<String, dynamic>> campaigns = {};

  CloudFirestoreSync() {
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }

  Map<String, dynamic> lastSnapshotUploaded = {};
  Map<String, dynamic> lastSnapshot = {};

  @override
  Future<Map<String, dynamic>?> getSnapshot(String id) async {
    final user = auth.currentUser;

    if (user == null) {
      return null;
    }

    final campaign = campaigns[id];
    if (campaign != null) {
      print('Returning cached data');
      lastSnapshotUploaded = campaign;
      lastSnapshot = campaign;
      return campaign;
    }

    DocumentSnapshot<Map<String, dynamic>>? snapshot = null;

    try {
      snapshot = await db.collection(collectionName).doc("${user.uid}_$id").get(
            GetOptions(source: Source.cache),
          );
    } catch (e) {
      try {
        snapshot = await db.collection(collectionName).doc("${user.uid}_$id").get(
              GetOptions(source: Source.server),
            );
      } catch (e) {
        print(e);
      }
    }

    lastSnapshotUploaded = snapshot?.data() ?? {};
    lastSnapshot = snapshot?.data() ?? {'timestamp': DateTime.now().millisecondsSinceEpoch};

    return snapshot?.data();
  }

  @override
  Future<void> saveSnapshot(Map<String, dynamic> snapshot, String id) async {
    final user = auth.currentUser;

    if (user == null) {
      return;
    }

    campaigns[id] = snapshot;

    await db.collection(collectionName).doc("${user.uid}_$id").set(snapshot);

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

  @override
  Future<void> obtainSnapshots() async {
    final user = auth.currentUser;

    if (user == null) {
      return null;
    }

    final snapshots = await db.collection(collectionName).where('__name__', whereIn: [
      '${user.uid}_1',
      '${user.uid}_2',
      '${user.uid}_3',
      '${user.uid}_4',
    ]).get();

    print(snapshots.docs.length);
    print(snapshots.docs);

    campaigns.clear();

    snapshots.docs.forEach((element) {
      campaigns[element.id.split('_').last] = element.data();
    });

    return null;
  }

  @override
  String getCampaignName(String id) {
    return campaigns[id]?['name'] as String? ?? '';
  }
}

extension on Map<String, dynamic> {
  bool equals(Map<String, dynamic> other) {
    return this.toString().hashCode == other.toString().hashCode;
  }
}
