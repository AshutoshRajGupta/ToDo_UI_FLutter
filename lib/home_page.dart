import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';
import 'todo.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class HomePage extends StatefulWidget {
  final List<Todo> todos;
  final Function(Todo) addTodo;

  const HomePage({Key? key, required this.todos, required this.addTodo})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  late String _currentDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _updateDate();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TodoProvider>().searchQuery = _searchController.text;
  }

  void _updateDate() {
    setState(() {
      _currentDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final todos = todoProvider.todos;
        String filter = todoProvider.filter.toString().split('.').last;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Welcome ASHUTOSH !!!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 18, 9, 152),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Manage your tasks efficiently and stay organized.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 19, 19, 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.add_task,
                        color: Color.fromARGB(255, 122, 165, 11), size: 30),
                    Icon(Icons.check_circle,
                        color: Color.fromARGB(255, 61, 214, 94), size: 30),
                    Icon(Icons.event_note,
                        color: Color.fromARGB(255, 45, 145, 217), size: 30),
                    Icon(Icons.alarm,
                        color: Color.fromARGB(255, 229, 129, 14), size: 30),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search Todos...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.deepPurple, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(
                        Icons.account_circle,
                        color: Color.fromARGB(255, 214, 62, 123),
                      ),
                      iconSize: 52,
                      onPressed: () {
                        // Add functionality for user icon here if needed
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Date: $_currentDate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 30,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Todos',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: filter,
                          icon: const Icon(Icons.filter_list,
                              color: Colors.deepPurple),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurple,
                          ),
                          onChanged: (String? newValue) {
                            // Update the filter and trigger rebuild
                            context.read<TodoProvider>().setFilter(newValue!);
                          },
                          items: <String>['All', 'Completed', 'Incomplete']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color:
                              todo.completed ? Colors.green[100] : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (value) {
                              // Update the todo completion status
                              context
                                  .read<TodoProvider>()
                                  .updateTodoCompletion(todo.id, value!);
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              // Apply strike-through if todo is completed
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(todo.description),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete button press
                              context.read<TodoProvider>().removeTodo(todo.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
