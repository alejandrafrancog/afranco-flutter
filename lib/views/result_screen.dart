import 'package:flutter/material.dart';
import 'package:afranco/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });

  String get scoreText => '$finalScore/$totalQuestions';
  String get feedbackMessage => finalScore > (totalQuestions ~/ 2) 
      ? '¡Buen trabajo!' 
      : '¡Sigue practicando!';
  
  Color get buttonColor => finalScore > (totalQuestions ~/ 2)
      ? Colors.blue
      : Colors.green;

  @override
  Widget build(BuildContext context) {
    const scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    const double spacingHeight = 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¡Juego Completado!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Puntuación Final: $scoreText',
                style: scoreTextStyle,
              ),
              const SizedBox(height: spacingHeight), 
              Text(
                feedbackMessage,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Jugar de nuevo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Color condicional
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartScreen(),
                  ),
                  (Route<dynamic> route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}