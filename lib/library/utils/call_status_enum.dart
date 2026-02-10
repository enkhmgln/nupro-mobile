enum CallStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected'),
  completed('completed'),
  cancelled('cancelled');

  const CallStatus(this.value);

  final String value;

  static CallStatus fromString(String status) {
    return CallStatus.values.firstWhere(
      (status) => status.value == status,
      orElse: () => throw ArgumentError('Unknown call status: $status'),
    );
  }

  static List<String> get allValues =>
      CallStatus.values.map((e) => e.value).toList();

  static bool isValid(String status) {
    return CallStatus.values.any((s) => s.value == status);
  }
}
