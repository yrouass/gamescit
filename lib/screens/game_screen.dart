import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameScreen extends StatefulWidget {
  final String category;

  const GameScreen({super.key, required this.category});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameModel gameModel;
  final TextEditingController _guessController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    gameModel = GameModel(category: widget.category);
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  void _makeGuess() {
    final guess = _guessController.text.trim();
    if (guess.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a guess';
      });
      return;
    }

    final result = gameModel.makeGuess(guess);
    
    setState(() {
      errorMessage = result.message;
      if (result.message == null) {
        _guessController.clear();
      }
    });

    if (gameModel.isGameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          gameModel.isWinner ? 'Congratulations!' : 'Game Over',
          style: TextStyle(
            color: gameModel.isWinner ? Colors.green : Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              gameModel.isWinner
                  ? 'You guessed the word correctly!'
                  : 'You ran out of attempts.',
            ),
            const SizedBox(height: 10),
            Text(
              'The word was: ${gameModel.targetWord.toUpperCase()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                gameModel.resetGame();
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Categories'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guess the ${widget.category}'),
        backgroundColor: _getCategoryColor(),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hint section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Hint',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gameModel.getHint(),
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Attempts: ${gameModel.guessHistory.length}/${gameModel.maxAttempts}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Input section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guessController,
                    decoration: InputDecoration(
                      labelText: 'Enter your guess',
                      border: const OutlineInputBorder(),
                      errorText: errorMessage,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _makeGuess(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _makeGuess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getCategoryColor(),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Guess'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // History section
            Expanded(
              child: gameModel.guessHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'Make your first guess!',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: gameModel.guessHistory.length,
                      itemBuilder: (context, index) {
                        final result = gameModel.guessHistory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(),
                              foregroundColor: Colors.white,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              result.word.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                _buildResultIcon(
                                  '🎯',
                                  result.bulls.toString(),
                                  Colors.green,
                                ),
                                const SizedBox(width: 16),
                                _buildResultIcon(
                                  '🐄',
                                  result.cows.toString(),
                                  Colors.orange,
                                ),
                              ],
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
  }

  Widget _buildResultIcon(String emoji, String count, Color color) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor() {
    switch (widget.category.toLowerCase()) {
      case 'countries':
        return Colors.green;
      case 'animals':
        return Colors.orange;
      case 'foods':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
