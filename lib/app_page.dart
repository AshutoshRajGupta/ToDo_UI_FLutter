import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  const AppPage({Key? key, required this.onNavigateToHome}) : super(key: key);

  final VoidCallback onNavigateToHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 205, 182, 90), // Set the desired background color here

      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // General padding for horizontal sides
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60), // Add some space at the top
            const Text(
              'MANAGE  YOUR\nDAILY  TODOS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 152, 18, 5),
              ),
            ),
            const SizedBox(height: 25), // Space between text and image
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Space from all four sides
                child: SizedBox(
                  width: 300, // Set the desired width
                  height: 300, // Set the desired height
                  child: Image.asset(
                    'assets/images/image2.png', // Path to your asset image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between image and next text
            const Text(
              'Without much worry just manage\n things as easy as a piece of cake',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Space between text and button
            SizedBox(
              width: 200, // Set a specific width for the button
              child: ElevatedButton(
                onPressed: onNavigateToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Dark color for the button
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0), // Increase the button height
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color for the text
                  ),
                ),
                child: const Text('Get Started !!',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16), // Space at the bottom
          ],
        ),
      ),
    );
  }
}
