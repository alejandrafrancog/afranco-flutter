import 'package:flutter/material.dart';
import 'package:afranco/views/game_screen.dart';
import 'package:afranco/api/service/question_service.dart';
import 'package:afranco/data/question_repository.dart'; // Añadir import del repositorio
import 'package:afranco/constants/constants.dart';
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                GameConstants.welcomeMessage,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text(GameConstants.startGame),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30, 
                  vertical: 15
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
                backgroundColor: Colors.blue
                , foregroundColor: Colors.white
              ),
              onPressed: () {
                // Crear instancia del repositorio
                final questionRepository = QuestionRepository();
                // Inyectar repositorio al servicio
                final questionService = QuestionService(repository: questionRepository);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      questionService: questionService,
                    ),
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