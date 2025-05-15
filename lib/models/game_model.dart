import 'dart:math';
import '../data/game_data.dart';

class GameModel {
  final String category;
  late String targetWord;
  List<String> availableWords = [];
  List<GuessResult> guessHistory = [];
  int maxAttempts = 8;
  bool isGameOver = false;
  bool isWinner = false;

  GameModel({required this.category}) {
    availableWords = GameData.getWordsByCategory(category);
    _selectRandomWord();
  }

  void _selectRandomWord() {
    final random = Random();
    targetWord = availableWords[random.nextInt(availableWords.length)];
  }

  GuessResult makeGuess(String guess) {
    if (isGameOver) {
      return GuessResult(
        word: guess,
        bulls: 0,
        cows: 0,
        isCorrect: false,
      );
    }

    // Convert to lowercase for comparison
    guess = guess.toLowerCase();
    
    // Check if the guess is valid (same length as target word)
    if (guess.length != targetWord.length) {
      return GuessResult(
        word: guess,
        bulls: 0,
        cows: 0,
        isCorrect: false,
        message: 'Guess must be ${targetWord.length} letters long',
      );
    }

    // Calculate bulls and cows
    int bulls = 0;
    int cows = 0;
    
    // Create a map to track character occurrences in the target word
    Map<String, int> targetCharCount = {};
    
    // First pass: count bulls (correct letter in correct position)
    for (int i = 0; i < targetWord.length; i++) {
      String targetChar = targetWord[i];
      String guessChar = guess[i];
      
      if (targetChar == guessChar) {
        bulls++;
      } else {
        targetCharCount[targetChar] = (targetCharCount[targetChar] ?? 0) + 1;
      }
    }
    
    // Second pass: count cows (correct letter in wrong position)
    for (int i = 0; i < guess.length; i++) {
      String targetChar = targetWord[i];
      String guessChar = guess[i];
      
      if (targetChar != guessChar && 
          targetCharCount.containsKey(guessChar) && 
          targetCharCount[guessChar]! > 0) {
        cows++;
        targetCharCount[guessChar] = targetCharCount[guessChar]! - 1;
      }
    }
    
    // Create result
    GuessResult result = GuessResult(
      word: guess,
      bulls: bulls,
      cows: cows,
      isCorrect: bulls == targetWord.length,
    );
    
    // Add to history
    guessHistory.add(result);
    
    // Check if game is over
    if (result.isCorrect) {
      isGameOver = true;
      isWinner = true;
    } else if (guessHistory.length >= maxAttempts) {
      isGameOver = true;
    }
    
    return result;
  }

  void resetGame() {
    guessHistory.clear();
    isGameOver = false;
    isWinner = false;
    _selectRandomWord();
  }

  String getHint() {
    if (guessHistory.isEmpty) {
      return "The word has ${targetWord.length} letters.";
    } else {
      return "Try a word with ${targetWord.length} letters.";
    }
  }
}

class GuessResult {
  final String word;
  final int bulls;
  final int cows;
  final bool isCorrect;
  final String? message;

  GuessResult({
    required this.word,
    required this.bulls,
    required this.cows,
    required this.isCorrect,
    this.message,
  });
}
