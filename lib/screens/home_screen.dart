import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Guessing Game'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose a Category',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _buildCategoryButton(
                context,
                'Countries',
                Colors.green,
                Icons.public,
              ),
              const SizedBox(height: 20),
              _buildCategoryButton(
                context,
                'Animals',
                Colors.orange,
                Icons.pets,
              ),
              const SizedBox(height: 20),
              _buildCategoryButton(
                context,
                'Foods',
                Colors.red,
                Icons.restaurant,
              ),
              const SizedBox(height: 40),
              const Text(
                'How to Play:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '1. Choose a category and guess the word\n'
                  '2. Bulls (🎯) = correct letter in correct position\n'
                  '3. Cows (🐄) = correct letter in wrong position\n'
                  '4. You have 8 attempts to guess the word',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String category,
    Color color,
    IconData icon,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Text(
          category,
          style: const TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(category: category),
            ),
          );
        },
      ),
    );
  }
}
