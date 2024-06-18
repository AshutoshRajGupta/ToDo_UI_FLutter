import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'add_todo_page.dart';
import 'todo_provider.dart';
import 'visualization_page.dart';
import 'app_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'ToDo App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _showAppPage = true;

  void _onNavigateToHome() {
    setState(() {
      _showAppPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showAppPage) {
      return AppPage(onNavigateToHome: _onNavigateToHome);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Consumer<TodoProvider>(
            builder: (context, todoProvider, _) {
              return HomePage(
                todos: todoProvider.todos,
                addTodo: todoProvider.addTodo,
              );
            },
          ),
          AddTodoPage(
            addTodo: (todo) {
              Provider.of<TodoProvider>(context, listen: false).addTodo(todo);
            },
          ),
          const VisualizationPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Color.fromARGB(255, 208, 209, 204), // Set the background color here
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 7, 7, 7)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Color.fromARGB(255, 15, 15, 14)),
            label: 'Add ToDo',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
