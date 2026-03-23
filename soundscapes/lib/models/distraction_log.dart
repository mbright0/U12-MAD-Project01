class DistractionLog {
  final int? id;
  final int sessionId;
  final String note;
  final DateTime loggedAt;

  DistractionLog({
    this.id,
    required this.sessionId,
    required this.note,
    required this.loggedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'note': note,
      'logged_at': loggedAt.toIso8601String(),
    };
  }

  factory DistractionLog.fromMap(Map<String, dynamic> map) {
    return DistractionLog(
      id: map['id'],
      sessionId: map['session_id'],
      note: map['note'],
      loggedAt: DateTime.parse(map['logged_at']),
    );
  }
}
