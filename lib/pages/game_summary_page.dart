import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoerechim/pages/games_mode_page.dart';
import 'package:geoerechim/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:geoerechim/providers/game_state.dart';

class GameSummaryPage extends StatefulWidget {
  final int totalRodadas;
  final int rodadaAtual;
  final int pontosRodada;
  final int pontosTotais;

  const GameSummaryPage({
    super.key,
    required this.totalRodadas,
    required this.rodadaAtual,
    required this.pontosRodada,
    required this.pontosTotais,
  });

  @override
  State<GameSummaryPage> createState() => _GameSummaryPageState();
}

class _GameSummaryPageState extends State<GameSummaryPage>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late AnimationController _scoreController;
  late AnimationController _cardController;

  late Animation<double> _trophyScale;
  late Animation<double> _scoreCountUp;
  late Animation<double> _cardSlide;

  @override
  void initState() {
    super.initState();

    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _trophyScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.elasticOut),
    );

    _scoreCountUp = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scoreController, curve: Curves.easeOut));

    _cardSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );

    _saveResult();
    _startAnimations();
  }

  void _saveResult() {
    final gameState = Provider.of<GameState>(context, listen: false);
    FirebaseService()
        .addGameResult(gameState.playerName, widget.pontosTotais);
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _trophyController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _scoreController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _cardController.forward();
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _scoreController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxPoints = widget.totalRodadas * 5000;
    final performance = widget.pontosTotais / maxPoints;

    String trophyPath;
    String performanceText;
    Color performanceColor;

    if (performance >= 0.8) {
      trophyPath = "lib/assets/images/trohpyGold.svg";
      performanceText = "Excelente Trabalho!";
      performanceColor = const Color(0xFFFFD700);
    } else if (performance >= 0.5) {
      trophyPath = "lib/assets/images/trophySilver.svg";
      performanceText = "Bom Trabalho!";
      performanceColor = const Color(0xFFC0C0C0);
    } else {
      trophyPath = "lib/assets/images/trophyBronze.svg";
      performanceText = "Continue Tentando!";
      performanceColor = const Color(0xFFCD7F32);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E3321), Color(0xFF1B4D35)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    performanceText,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: performanceColor,
                      fontFamily: 'Lilita One',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  AnimatedBuilder(
                    animation: _trophyScale,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _trophyScale.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: performanceColor.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(trophyPath, height: 120),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  _buildProgressBar(performance),

                  const SizedBox(height: 30),

                  AnimatedBuilder(
                    animation: _cardSlide,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _cardSlide.value),
                        child: Column(
                          children: [
                            _buildInfoCard(
                              "Rodadas Jogadas",
                              "${widget.rodadaAtual} / ${widget.totalRodadas}",
                              Icons.casino,
                            ),
                            AnimatedBuilder(
                              animation: _scoreCountUp,
                              builder: (context, child) {
                                final animatedScore =
                                    (_scoreCountUp.value * widget.pontosRodada)
                                        .round();
                                return _buildInfoCard(
                                  "Pontos da Última Rodada",
                                  "$animatedScore",
                                  Icons.star,
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _scoreCountUp,
                              builder: (context, child) {
                                final animatedTotal =
                                    (_scoreCountUp.value * widget.pontosTotais)
                                        .round();
                                return _buildInfoCard(
                                  "Pontuação Total",
                                  "$animatedTotal / $maxPoints",
                                  Icons.emoji_events,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameModesPage(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(
                            Icons.sports_esports,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Jogar Novamente",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Lilita One',
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F6F3F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double performance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Performance",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lilita One',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: performance,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: performance >= 0.8
                      ? [const Color(0xFFFFD700), const Color(0xFFFF8C00)]
                      : performance >= 0.5
                      ? [const Color(0xFFC0C0C0), const Color(0xFF808080)]
                      : [const Color(0xFFCD7F32), const Color(0xFF8B4513)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${(performance * 100).toInt()}% de aproveitamento",
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      color: Colors.white.withOpacity(0.95),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0E3321).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF0E3321), size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3321),
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4D35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
