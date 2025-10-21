import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  String playerName = "";
  int totalPoints = 0;
  int currentRound = 1;
  final int maxRounds = 2;
  List<int> roundPoints = [];

  void setPlayerName(String name) {
    playerName = name;
    notifyListeners();
  }

  void addRoundPoints(int points) {
    if (currentRound <= maxRounds) {
      totalPoints += points;
      roundPoints.add(points);
      notifyListeners();
    }
  }

  void nextRound() {
    if (currentRound < maxRounds) {
      currentRound++;
      notifyListeners();
    } else {
      resetGame();
    }
  }

  void resetGame() {
    totalPoints = 0;
    currentRound = 1;
    roundPoints.clear();
    notifyListeners();
  }

  bool get isGameOver => currentRound > maxRounds;
}
