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
      id: json['id'],
      recordId: json['recordId'],
      userId: json['userId'],
      date: json['date'],
      time: json['time'],
      freq: json['freq'],
    );
  }
}
