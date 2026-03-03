import 'package:flutter/material.dart';
// Import 2 file đã tách để sử dụng
import 'models/todo.dart';
import 'widgets/todo_item.dart';

void main() {
  runApp(const TodoApp());
}

// Enum định nghĩa các trạng thái lọc
enum TodoFilter { all, active, completed }

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App Final',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  // Danh sách dữ liệu gốc
  final List<Todo> _todos = [];
  
  // Biến quản lý ID tự tăng (đơn giản hóa cho bài tập)
  int _nextId = 1;
  
  // Biến lưu trạng thái lọc hiện tại
  TodoFilter _currentFilter = TodoFilter.all;

  // LOGIC BỘ LỌC (Yêu cầu số 6) 
  List<Todo> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.active:
        return _todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((t) => t.isCompleted).toList();
      default:
        return _todos;
    }
  }

  /// ... (Các phần import và code khác giữ nguyên)

  // CHỨC NĂNG THÊM / SỬA CÓ CHỌN GIỜ
  void _showTaskDialog({Todo? todo}) {
    final TextEditingController controller = TextEditingController(
      text: todo?.title ?? '',
    );
    // Biến tạm để lưu thời gian người dùng chọn
    DateTime? selectedDateTime = todo?.dueDateTime;
    final bool isEditing = todo != null;

    showDialog(
      context: context,
      builder: (ctx) {
        // Dùng StatefulBuilder để cập nhật giao diện bên trong Dialog (để hiện ngày vừa chọn)
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEditing ? 'Sửa công việc' : 'Thêm công việc mới'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Nhập nội dung công việc...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Khu vực chọn ngày giờ
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDateTime == null
                              ? 'Chưa chọn hạn chót'
                              : 'Hạn: ${selectedDateTime!.hour}:${selectedDateTime!.minute} - ${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}',
                          style: TextStyle(
                              color: selectedDateTime == null ? Colors.grey : Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month, color: Colors.indigo),
                        onPressed: () async {
                          // 1. Chọn Ngày
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate == null) return;

                          // 2. Chọn Giờ
                          if (!context.mounted) return;
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
                          );
                          if (pickedTime == null) return;

                          // 3. Gộp Ngày + Giờ lại
                          setStateDialog(() {
                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập nội dung!')),
                      );
                      return;
                    }

                    setState(() {
                      if (isEditing) {
                        todo.title = text;
                        todo.dueDateTime = selectedDateTime; // Cập nhật giờ
                      } else {
                        _todos.insert(0, Todo(
                          id: _nextId++, 
                          title: text, 
                          dueDateTime: selectedDateTime // Lưu giờ
                        ));
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // CHỨC NĂNG XÓA (Yêu cầu số 4) 
  // Bắt buộc có Dialog xác nhận "Bạn có chắc chắn muốn xóa?"
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _todos.removeWhere((t) => t.id == id);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App - Bài Thực Hành 1'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // THANH BỘ LỌC (Filter UI)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('Tất cả', TodoFilter.all),
                const SizedBox(width: 8),
                _buildFilterChip('Chưa xong', TodoFilter.active),
                const SizedBox(width: 8),
                _buildFilterChip('Đã xong', TodoFilter.completed),
              ],
            ),
          ),
          
          // DANH SÁCH CÔNG VIỆC (ListView) 
          Expanded(
            child: _filteredTodos.isEmpty
                ? const Center(
                    child: Text(
                      'Không có công việc nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredTodos.length,
                    itemBuilder: (ctx, index) {
                      final item = _filteredTodos[index];
                      // Sử dụng Widget đã tách riêng (Code sạch)
                      return TodoItemWidget(
                        todo: item,
                        // Logic đổi trạng thái Checkbox 
                        onToggle: () {
                          setState(() {
                            item.isCompleted = !item.isCompleted;
                          });
                        },
                        // Logic Xóa
                        onDelete: () => _confirmDelete(item.id),
                        // Logic Sửa
                        onEdit: () => _showTaskDialog(todo: item),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget con để vẽ nút lọc (Chip)
  Widget _buildFilterChip(String label, TodoFilter filter) {
    final bool isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _currentFilter = filter;
          });
        }
      },
      selectedColor: Colors.indigo.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.indigo : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}