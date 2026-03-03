import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  // Hàm phụ trợ để định dạng ngày giờ (Không cần cài thư viện intl)
  String _formatDate(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} - ${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem đã quá hạn chưa (để đổi màu chữ thành đỏ)
    bool isOverdue = todo.dueDateTime != null && 
                     DateTime.now().isAfter(todo.dueDateTime!) && 
                     !todo.isCompleted;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Hiển thị thời gian ở đây
        subtitle: todo.dueDateTime != null
            ? Text(
                'Hạn chót: ${_formatDate(todo.dueDateTime!)}',
                style: TextStyle(
                  color: isOverdue ? Colors.red : Colors.grey[700],
                  fontSize: 12,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}