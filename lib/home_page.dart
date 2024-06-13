import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_todo_page.dart'; // Import the AddTodoPage
import 'todo_provider.dart';
import 'todo.dart';

class HomePage extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) addTodo;
  const HomePage({Key? key, required this.todos, required this.addTodo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final todos = todoProvider.todos;
        String filter = "All";
        List<Todo> filteredTodos = todos;
        if (filter == "Completed") {
          filteredTodos = todos.where((todo) => todo.completed).toList();
        } else if (filter == "Incomplete") {
          filteredTodos = todos.where((todo) => !todo.completed).toList();
        }

        return Scaffold(
          // backgroundColor:
          //     Color.fromARGB(255, 166, 225, 241), // Brighter background color
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome to the ToDo App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage your tasks efficiently and stay organized.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                // Row of icons above the search bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.add_task, color: Colors.deepPurple, size: 28),
                    Icon(Icons.check_circle,
                        color: Colors.deepPurple, size: 28),
                    Icon(Icons.event_note, color: Colors.deepPurple, size: 28),
                    Icon(Icons.alarm, color: Colors.deepPurple, size: 28),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                      icon: const Icon(Icons.account_circle),
                      iconSize: 32,
                      onPressed: () {
                        // Add functionality for user icon here if needed
                      },
                    ),
                  ],
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
                    // Dropdown menu for filtering todos
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
                            // Update the filter
                            filter = newValue!;
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
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (value) {
                            // Update the todo completion status
                            todoProvider.updateTodoCompletion(todo.id, value!);
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to the AddTodoPage with existing todo data for editing
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTodoPage(
                                      addTodo: (updatedTodo) {
                                        // Update the existing todo with the edited data
                                        todoProvider.updateTodo(updatedTodo);
                                        // Pop the AddTodoPage from the navigation stack
                                        Navigator.pop(context);
                                      },
                                      todo:
                                          todo, // Pass the existing todo data to the AddTodoPage
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete button press
                                todoProvider.removeTodo(todo.id);
                              },
                            ),
                          ],
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
