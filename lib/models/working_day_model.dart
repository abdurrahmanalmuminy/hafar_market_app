class WorkingDayModel {
  final String day;
  final bool working;

  WorkingDayModel({required this.day, required this.working});
}

List<WorkingDayModel> days = [
  WorkingDayModel(day: "السبت", working: true),
  WorkingDayModel(day: "الأحد", working: true),
  WorkingDayModel(day: "الإثنين", working: true),
  WorkingDayModel(day: "الثلاثاء", working: true),
  WorkingDayModel(day: "الأربعاء", working: true),
  WorkingDayModel(day: "الخميس", working: false),
  WorkingDayModel(day: "الجمعة", working: false),
];
