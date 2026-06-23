import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../services/sync/sync_service.dart';

enum ConnectivityStatus { online, offline }

enum SyncState { idle, syncing, synced, error }

class SyncStatusProvider extends ChangeNotifier {
  ConnectivityStatus _connectivity = ConnectivityStatus.offline;
  SyncState _syncState = SyncState.idle;
  int _pendingCount = 0;
  DateTime? _lastSyncedAt;
  String? _lastError;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityStatus get connectivity => _connectivity;
  SyncState get syncState => _syncState;
  int get pendingCount => _pendingCount;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  String? get lastError => _lastError;
  bool get isOnline => _connectivity == ConnectivityStatus.online;

  Future<void> init() async {
    final initial = await Connectivity().checkConnectivity();
    _applyConnectivity(initial, triggerSyncIfOnline: false);

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOffline = _connectivity == ConnectivityStatus.offline;
    _applyConnectivity(results, triggerSyncIfOnline: wasOffline);
  }

  void _applyConnectivity(
    List<ConnectivityResult> results, {
    required bool triggerSyncIfOnline,
  }) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    _connectivity =
        hasConnection ? ConnectivityStatus.online : ConnectivityStatus.offline;
    _pendingCount = SyncService.instance.pendingCount;
    notifyListeners();

    if (triggerSyncIfOnline && isOnline) {
      triggerSync();
    }
  }

  Future<void> triggerSync() async {
    if (!isOnline || _syncState == SyncState.syncing) return;

    _syncState = SyncState.syncing;
    _lastError = null;
    notifyListeners();

    try {
      await SyncService.instance.syncPending();
      _pendingCount = SyncService.instance.pendingCount;
      _syncState = SyncState.synced;
      _lastSyncedAt = DateTime.now();
    } catch (e) {
      _syncState = SyncState.error;
      _lastError = e.toString();
    }
    notifyListeners();
  }

  /// Call after any CRUD write so the pending count stays current.
  void onDataWritten() {
    _pendingCount = SyncService.instance.pendingCount;
    if (_syncState == SyncState.synced) _syncState = SyncState.idle;
    notifyListeners();
    if (isOnline) triggerSync();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
