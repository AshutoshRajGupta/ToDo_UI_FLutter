import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'todo.dart';
import 'todo_provider.dart';

class AddTodoPage extends StatefulWidget {
  final Function(Todo) addTodo;
  final Todo? todo;

  const AddTodoPage({Key? key, required this.addTodo, this.todo})
      : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int _selectedIndex = 0;
  DateTime _selectedMonth = DateTime.now();

  List<DateTime> _currentWeekDates(DateTime month) {
    DateTime now = month;
    int currentDayOfWeek = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentDayOfWeek - 1));

    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  void _addTodo() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate.isNotEmpty) {
      final newTodo = Todo(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
      );

      Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);

      // Clear the text fields after adding the todo
      _titleController.clear();
      _descriptionController.clear();
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Optionally, you can navigate back or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo Added Successfully')),
      );
    } else {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _currentWeekDates(_selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task',
          style: TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month selection dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_selectedMonth),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                DropdownButton<int>(
                  value: DateTime.now().month,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(
                          DateFormat('MMMM').format(DateTime(0, index + 1))),
                    );
                  }),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekDates.length,
                itemBuilder: (context, index) {
                  DateTime date = weekDates[index];
                  String day = DateFormat('EEE').format(date);
                  String dayNumber = DateFormat('d').format(date);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _selectedDate = DateFormat('yyyy-MM-dd').format(date);
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            dayNumber,
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Date: $_selectedDate',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addTodo,
                child: const Text('Add ToDo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
