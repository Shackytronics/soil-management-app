import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/local/hive_service.dart';
import '../../data/models/sync_queue_model.dart';

/// Processes SyncQueueModel entries and writes them to Firestore.
/// Call [syncPending()] after detecting connectivity or on app resume.
class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  static const _maxRetries = 3;
  final _firestore = FirebaseFirestore.instance;

  bool _isSyncing = false;

  /// Processes all pending sync queue entries for the current user.
  Future<void> syncPending() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isSyncing) return;

    _isSyncing = true;
    try {
      final box = HiveService.syncQueue;
      final pending = box.values
          .where((e) => e.retryCount < _maxRetries)
          .toList()
        ..sort((a, b) => a.queuedAt.compareTo(b.queuedAt));

      for (final entry in pending) {
        await _processEntry(entry, user.uid);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processEntry(SyncQueueModel entry, String uid) async {
    try {
      final collRef = _firestore
          .collection('users')
          .doc(uid)
          .collection(entry.collection);

      switch (entry.operation) {
        case 'create':
        case 'update':
          if (entry.dataJson == null) break;
          final data = jsonDecode(entry.dataJson!) as Map<String, dynamic>;
          await collRef.doc(entry.documentId).set(data, SetOptions(merge: true));
          break;

        case 'delete':
          await collRef.doc(entry.documentId).delete();
          break;
      }

      // Mark the Hive object as synced
      _markLocalSynced(entry);

      // Remove from queue
      await entry.delete();
    } catch (_) {
      entry.retryCount++;
      await entry.save();
    }
  }

  void _markLocalSynced(SyncQueueModel entry) {
    if (entry.collection == 'measurements') {
      final box = HiveService.measurements;
      final m = box.values
          .cast<dynamic>()
          .firstWhere(
            (m) => m.id == entry.documentId,
            orElse: () => null,
          );
      if (m != null) {
        m.isSynced = true;
        m.save();
      }
    } else if (entry.collection == 'plots') {
      final box = HiveService.plots;
      final p = box.values
          .cast<dynamic>()
          .firstWhere(
            (p) => p.id == entry.documentId,
            orElse: () => null,
          );
      if (p != null) {
        p.isSynced = true;
        p.save();
      }
    }
  }

  /// Returns the number of items waiting to be synced.
  int get pendingCount => HiveService.syncQueue.values
      .where((e) => e.retryCount < _maxRetries)
      .length;
}
