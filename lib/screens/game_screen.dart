import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../models/game_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';

class GameScreen extends StatefulWidget {
  final String category;

  const GameScreen({super.key, required this.category});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late GameModel gameModel;
  final TextEditingController _guessController = TextEditingController();
  late ConfettiController _confettiController;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    gameModel = GameModel(category: widget.category);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _guessController.dispose();
    _confettiController.dispose();
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
      if (gameModel.isWinner) {
        _confettiController.play();
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        _showGameOverDialog();
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result Icon
              Icon(
                gameModel.isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 60,
                color: gameModel.isWinner
                    ? AppTheme.getColorByCategory(widget.category)
                    : Colors.red,
              ).animate().scale(
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

              const SizedBox(height: 16),

              // Result Title
              Text(
                gameModel.isWinner ? 'Congratulations!' : 'Game Over',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: gameModel.isWinner
                      ? AppTheme.getColorByCategory(widget.category)
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Result Message
              Text(
                gameModel.isWinner
                    ? 'You guessed the word correctly!'
                    : 'You ran out of attempts.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 16),

              // The Word
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'The word was: ${gameModel.targetWord.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          gameModel.resetGame();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.getColorByCategory(widget.category),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Play Again'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.getColorByCategory(widget.category),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Back to Menu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getColorByCategory(widget.category);
    final categoryGradient = AppTheme.getGradientByCategory(widget.category);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          AnimatedGradientBackground(
            colors: [
              AppTheme.backgroundColor,
              categoryColor.withOpacity(0.3),
              AppTheme.backgroundColor,
            ],
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    // App Bar
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Guess the ${widget.category}',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.help_outline),
                          onPressed: () => _showHelpDialog(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Game Info Card
                    Animate(
                      effects: [
                        FadeEffect(duration: 600.ms),
                        SlideEffect(
                          begin: const Offset(0, -0.1),
                          end: const Offset(0, 0),
                          duration: 600.ms,
                        ),
                      ],
                      child: GlassCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Hint
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: categoryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Hint',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),

                                // Attempts Counter
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${gameModel.guessHistory.length}/${gameModel.maxAttempts}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: categoryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Hint Text
                            Text(
                              gameModel.getHint(),
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Input Section
                    Animate(
                      effects: [
                        FadeEffect(duration: 600.ms, delay: 200.ms),
                        SlideEffect(
                          begin: const Offset(0, 0.1),
                          end: const Offset(0, 0),
                          duration: 600.ms,
                          delay: 200.ms,
                        ),
                      ],
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _guessController,
                              decoration: InputDecoration(
                                hintText: 'Enter your guess',
                                errorText: errorMessage,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: categoryColor,
                                ),
                                suffixIcon: _guessController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _guessController.clear();
                                            errorMessage = null;
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.go,
                              onSubmitted: (_) => _makeGuess(),
                              onChanged: (value) {
                                setState(() {
                                  // Clear error when typing
                                  if (errorMessage != null) {
                                    errorMessage = null;
                                  }
                                });
                              },
                              onTap: () {
                                // Focus on text field
                              },
                              onEditingComplete: () {
                                // Complete editing
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: categoryGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: categoryColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _makeGuess,
                                borderRadius: BorderRadius.circular(16),
                                child: const Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // History Section
                    Expanded(
                      child: Animate(
                        effects: [
                          FadeEffect(duration: 600.ms, delay: 400.ms),
                        ],
                        child: gameModel.guessHistory.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      size: 48,
                                      color: categoryColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Make your first guess!',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: gameModel.guessHistory.length,
                                itemBuilder: (context, index) {
                                  final result = gameModel.guessHistory[index];
                                  return Animate(
                                    effects: [
                                      FadeEffect(duration: 400.ms),
                                      SlideEffect(
                                        begin: const Offset(0.05, 0),
                                        end: const Offset(0, 0),
                                        duration: 400.ms,
                                      ),
                                    ],
                                    child: Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            // Attempt Number
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: categoryColor.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: categoryColor,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 16),

                                            // Guess Word
                                            Expanded(
                                              child: Text(
                                                result.word.toUpperCase(),
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            // Result Badges
                                            Row(
                                              children: [
                                                ResultBadge(
                                                  emoji: '🎯',
                                                  count: result.bulls.toString(),
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 8),
                                                ResultBadge(
                                                  emoji: '🐄',
                                                  count: result.cows.toString(),
                                                  color: Colors.orange,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: categoryGradient,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How to Play',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                context,
                '1',
                'Guess the hidden word from the ${widget.category} category',
              ),
              const SizedBox(height: 8),
              _buildHelpItem(
                context,
                '2',
                'Bulls (🎯) = correct letter in correct position',
              ),
              const SizedBox(height: 8),
              _buildHelpItem(
                context,
                '3',
                'Cows (🐄) = correct letter in wrong position',
              ),
              const SizedBox(height: 8),
              _buildHelpItem(
                context,
                '4',
                'You have ${gameModel.maxAttempts} attempts to guess the word',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getColorByCategory(widget.category),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Got it!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, String number, String text) {
    final categoryColor = AppTheme.getColorByCategory(widget.category);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: categoryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
