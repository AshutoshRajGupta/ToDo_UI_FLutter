import 'package:flutter/material.dart';

class VisualizationPage extends StatefulWidget {
  const VisualizationPage({super.key});

  @override
  _VisualizationPageState createState() => _VisualizationPageState();
}

class _VisualizationPageState extends State<VisualizationPage> {
  final List<String> categories = ["Work", "Personal", "Shopping", "Others"];
  final Map<String, List<Map<String, String>>> todos = {
    "Work": [
      {"task": "Meeting at 10 AM", "time": "2024-06-13 10:00"},
      {"task": "Submit report", "time": "2024-06-13 15:00"},
      {"task": "Team call", "time": "2024-06-14 11:00"},
      {"task": "Prepare presentation", "time": "2024-06-14 13:00"}
    ],
    "Personal": [
      {"task": "Call mom", "time": "2024-06-13 12:00"},
      {"task": "Buy groceries", "time": "2024-06-13 18:00"},
      {"task": "Visit dentist", "time": "2024-06-14 09:00"},
      {"task": "Plan weekend trip", "time": "2024-06-14 20:00"}
    ],
    "Shopping": [
      {"task": "Buy shoes", "time": "2024-06-13 16:00"},
      {"task": "Order laptop", "time": "2024-06-13 20:00"},
      {"task": "Get groceries", "time": "2024-06-14 08:00"},
      {"task": "Buy birthday gift", "time": "2024-06-14 19:00"}
    ],
    "Others": [
      {"task": "Read book", "time": "2024-06-13 14:00"},
      {"task": "Exercise", "time": "2024-06-13 19:00"},
      {"task": "Meditate", "time": "2024-06-14 07:00"},
      {"task": "Clean house", "time": "2024-06-14 17:00"}
    ],
  };

  final Map<String, Color> categoryColors = {
    "Work": Colors.blue,
    "Personal": Colors.green,
    "Shopping": Colors.orange,
    "Others": Colors.purple
  };

  final Map<String, IconData> categoryIcons = {
    "Work": Icons.work,
    "Personal": Icons.person,
    "Shopping": Icons.shopping_cart,
    "Others": Icons.more_horiz
  };

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make Todos For Personalized Activities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying categories in rectangular boxes
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 42) /
                        2, // 10 + 10 + 16 + 16
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: categoryColors[category],
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
                    child: Column(
                      children: [
                        Icon(
                          categoryIcons[category],
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Dropdown menu for selecting category
            Row(
              children: [
                Expanded(
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text("Select a category"),
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          },
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 20),
            // Displaying todos based on selected category
            Expanded(
              child: selectedCategory == null
                  ? const Center(child: Text("Select a category to see todos"))
                  : ListView.builder(
                      itemCount: todos[selectedCategory]!.length,
                      itemBuilder: (context, index) {
                        final todo = todos[selectedCategory]![index];
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              categoryIcons[selectedCategory!],
                              color: categoryColors[selectedCategory!],
                            ),
                            title: Text(todo["task"]!),
                            subtitle: Text(todo["time"]!),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
