/// Contract for observing network reachability, used by repositories to
/// decide between remote and cached datasources.
///
/// No concrete implementation yet (e.g. backed by `connectivity_plus`) —
/// reserved for when a feature module first needs real network awareness.
abstract interface class ConnectivityService {
  Future<bool> get isConnected;

  Stream<bool> get onConnectivityChanged;
}
