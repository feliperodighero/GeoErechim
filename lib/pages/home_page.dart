<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoerechim/widgets/custom_buttom.dart';
import 'package:geoerechim/services/auth_service.dart';
import 'ranking_page.dart';
import 'games_mode_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    final user = await _authService.signInWithGoogle();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login cancelado ou falhou.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/Logo.png',
                    height: 130,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Explore a geografia de Erechim de forma divertida!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  if (user == null) ...[
                    // Estado deslogado
                    if (_isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text(
                          'Entrar com Google',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _handleLogin,
                      ),
                  ] else ...[
                    // Estado logado
                    if (user.photoURL != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.photoURL!),
                      )
                    else
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Olá, ${user.displayName?.split(' ').first ?? 'Jogador'}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: "Jogar",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameModesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Ranking Global",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RankingPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    TextButton.icon(
                      onPressed: () => _authService.signOut(),
                      icon: const Icon(Icons.logout, color: Colors.white70),
                      label: const Text(
                        'Trocar de conta',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:geoerechim/widgets/custom_buttom.dart';
import 'games_mode_page.dart';
import 'package:geoerechim/widgets/player_name_dialog.dart';
import 'package:provider/provider.dart';
import 'package:geoerechim/providers/game_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/Logo.png',
              height: 130,
            ),
            const Text(
              "Explore a geografia de Erechim de forma divertida!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 200),
            CustomButton(
              text: "Jogar",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PlayerNameDialog(
                    onConfirm: (playerName) {
                      Provider.of<GameState>(context, listen: false)
                          .setPlayerName(playerName);
                      Navigator.of(context).pop(); // Fecha o diálogo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameModesPage()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> b4e5fe076728b4236ca04f1f159c2d6b2be514da
