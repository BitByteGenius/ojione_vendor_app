class ExperienceScheduleModel {
  final String id;
  final String experienceId;
  final String startTime; // '09:00 AM'
  final String endTime; // '12:00 PM'
  final List<String> daysOfWeek; // ['Monday', 'Wednesday', 'Friday', 'Saturday']
  final int maxCapacity;
  final int bookedCount;

  ExperienceScheduleModel({
    required this.id,
    required this.experienceId,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
    required this.maxCapacity,
    this.bookedCount = 0,
  });

  int get availableSeats => (maxCapacity - bookedCount).clamp(0, maxCapacity);

  factory ExperienceScheduleModel.fromJson(Map<String, dynamic> json) {
    return ExperienceScheduleModel(
      id: json['id'] ?? '',
      experienceId: json['experience_id'] ?? '',
      startTime: json['start_time'] ?? '09:00 AM',
      endTime: json['end_time'] ?? '12:00 PM',
      daysOfWeek: List<String>.from(json['days_of_week'] ?? []),
      maxCapacity: json['max_capacity'] ?? 10,
      bookedCount: json['booked_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experience_id': experienceId,
      'start_time': startTime,
      'end_time': endTime,
      'days_of_week': daysOfWeek,
      'max_capacity': maxCapacity,
      'booked_count': bookedCount,
    };
  }
}
