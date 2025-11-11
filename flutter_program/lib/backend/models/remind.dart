class UserRemind {
  final int id;
  final int recordId;
  final int userId;
  final String date;
  final String time;
  final String freq;

  UserRemind({
    required this.id,
    required this.recordId,
    required this.userId,
    required this.date,
    required this.time,
    required this.freq,
  });

  factory UserRemind.fromJson(Map<String, dynamic> json) {
    return UserRemind(
      id: json['id_calls'],
      recordId: json['fk_record_id'],
      userId: json['fk_user_id'],
      date: json['day'],
      time: json['time'],
      freq: json['freq'],
    );
  }
}
