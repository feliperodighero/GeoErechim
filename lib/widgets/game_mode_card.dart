import 'package:flutter/material.dart';

class GameModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String difficulty;
  final VoidCallback onTap;

  const GameModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F6F3F), // verde médio
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontFamily: 'Lilita One',
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Description
                    Text(
                      description,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    // Difficulty and Record
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dificuldade: $difficulty",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
