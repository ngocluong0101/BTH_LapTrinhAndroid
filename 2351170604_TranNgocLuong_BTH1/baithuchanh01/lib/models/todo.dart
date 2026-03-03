class Todo {
  final int id;
  String title;
  bool isCompleted;
  DateTime? dueDateTime; // Thêm biến này (có thể null nếu không chọn giờ)

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDateTime,    // Thêm vào constructor
  });
}