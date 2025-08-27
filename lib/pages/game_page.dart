import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart'
    as streetview;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geoerechim/pages/game_summary_page.dart';
import 'package:geoerechim/pages/map_guess_page.dart';
import 'package:geoerechim/pages/result_page.dart';
import 'package:geoerechim/providers/game_state.dart';
import 'package:geoerechim/utils/calculate_distance.dart';
import 'package:geoerechim/utils/calculate_points.dart';
import 'package:geoerechim/utils/game_mode_config.dart';
import 'package:geoerechim/utils/enums/game_modes.dart';
import 'package:geoerechim/services/street_view_service.dart';
import 'package:geoerechim/widgets/score_overlay.dart';

class GamePage extends StatefulWidget {
  final GameMode mode;

  const GamePage({super.key, required this.mode});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  streetview.LatLng? position;
  streetview.StreetViewController? _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadValidPosition();
  }

  Future<void> _loadValidPosition() async {
    setState(() {
      isLoading = true;
    });

    final pos = await StreetViewService.generateValidCoordinate();
    if (mounted) {
      setState(() {
        position = pos;
        isLoading = false;
      });
    }
  }

  void _reloadRandomPosition() async {
    setState(() {
      isLoading = true;
    });

    final newPos = await StreetViewService.generateValidCoordinate();
    if (mounted) {
      setState(() {
        position = newPos;
        isLoading = false;
      });
      _controller?.setPosition(position: position!, radius: 50);
    }
  }

  void _goToMapGuessPage() async {
    if (position == null) return; // Proteção adicional

    final guessedPosition = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapGuessPage(
          streetViewPosition: gmaps.LatLng(
            position!.latitude,
            position!.longitude,
          ),
        ),
      ),
    );

    if (guessedPosition != null) {
      // Calculate distance and points
      final distance = calculateDistance(
        gmaps.LatLng(position!.latitude, position!.longitude),
        guessedPosition,
      );

      final points = calculatePoints(distance);

      Provider.of<GameState>(context, listen: false).addRoundPoints(points);

      final gameState = Provider.of<GameState>(context, listen: false);

      // Se ainda não for a última rodada → ResultPage
      if (gameState.currentRound < gameState.maxRounds) {
        final nextRound = await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              streetViewPosition: gmaps.LatLng(
                position!.latitude,
                position!.longitude,
              ),
              guessedPosition: guessedPosition,
              points: points,
            ),
          ),
        );

        if (nextRound == true) {
          _reloadRandomPosition();
        }
      } else {
        // Se for a última rodada → SummaryPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameSummaryPage(
              totalRodadas: gameState.maxRounds,
              rodadaAtual: gameState.currentRound,
              pontosRodada: points,
              pontosTotais: gameState.totalPoints,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
      ),
      body: isLoading || position == null
          ? _buildLoadingScreen()
          : _buildStreetView(),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0E3321), Color(0xFF1B4D35)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              'Carregando localização...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Encontrando um local com Street View',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreetView() {
    return Stack(
      children: [
        streetview.FlutterGoogleStreetView(
          key: ValueKey(position),
          initPos: position!,
          streetNamesEnabled: false,
          userNavigationEnabled: GameModeConfig.userNavigation(widget.mode),
          zoomGesturesEnabled: GameModeConfig.zoomEnabled(widget.mode),
          panningGesturesEnabled: GameModeConfig.panningEnabled(widget.mode),
          onStreetViewCreated: (controller) {
            _controller = controller;
          },
          onPanoramaChangeListener: (location, exception) {
            if (location == null) {
              _reloadRandomPosition();
            }
          },
        ),

        const Positioned(top: 20, right: 20, child: ScoreOverlay()),

        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _goToMapGuessPage,
            backgroundColor: const Color(0xF01F6F3F),
            foregroundColor: Colors.white,
            child: const Icon(Icons.map),
          ),
        ),
      ],
    );
  }
}
