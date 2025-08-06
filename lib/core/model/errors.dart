class NetworkProblem extends Error {
  @override
  String toString() {
    return 'Network Problem';
  }
}

class UnavailableOffline extends Error {
  @override
  String toString() {
    return 'This functionality is not available offline';
  }
}
