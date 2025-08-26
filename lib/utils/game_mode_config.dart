import 'package:geoerechim/utils/enums/game_modes.dart';

class GameModeConfig {
  static bool userNavigation(GameMode mode) {
    switch (mode) {
      case GameMode.pracaDaBandeira:
        return true; // pode andar
      case GameMode.castelinho:
      case GameMode.seminario:
        return false;
    }
  }

  static bool zoomEnabled(GameMode mode) {
    switch (mode) {
      case GameMode.pracaDaBandeira:
      case GameMode.castelinho:
        return true; // pode dar zoom
      case GameMode.seminario:
        return false;
    }
  }

  static bool panningEnabled(GameMode mode) {
    switch (mode) {
      case GameMode.pracaDaBandeira:
      case GameMode.castelinho:
        return true; // pode mover
      case GameMode.seminario:
        return false;
    }
  }
}
