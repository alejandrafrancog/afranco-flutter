import 'package:flutter/material.dart';
import 'package:afranco/api/service/question_service.dart';
import 'package:afranco/domain/question.dart';
import 'package:afranco/views/result_screen.dart';

class GameScreen extends StatefulWidget {
  final QuestionService questionService;
  
  const GameScreen({
    super.key,
    required this.questionService,
  });

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late List<Question> questionsList;
  int currentQuestionIndex = 0;
  int userScore = 0;
  int? selectedAnswerIndex;
  int? correctAnswerIndex;
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    questionsList = widget.questionService.getQuestions();
  }


  Color _getButtonColor(int index) {
    if (!showFeedback) return Colors.blue;
    if (index == correctAnswerIndex) return Colors.green;
    if (index == selectedAnswerIndex) return Colors.red;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (questionsList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Error: No hay preguntas disponibles'),
        ),
      );
    }

    final currentQuestion = questionsList[currentQuestionIndex];
    final questionCounterText = 
        'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';

    return Scaffold(
      appBar: AppBar(
        title: Text(questionCounterText),
        backgroundColor: Colors.black,
        foregroundColor: Colors.grey,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...currentQuestion.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(index),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    disabledBackgroundColor: _getButtonColor(index),
                  ),
                  onPressed: showFeedback ? null : () => _handleAnswer(index),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  void _handleAnswer(int selectedIndex) {
  final currentQuestion = questionsList[currentQuestionIndex];
  
  // Determinar el mensaje del SnackBar
  final bool isCorrect = selectedIndex == currentQuestion.correctAnswerIndex;
  final String snackBarMessage = isCorrect ? '¡Correcto!' : '¡Incorrecto!';
  final Color snackBarColor = isCorrect ? Colors.green : Colors.red;

  // Mostrar SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(snackBarMessage),
      backgroundColor: snackBarColor,
      duration: const Duration(seconds: 1),
    ),
  );

  setState(() {
    selectedAnswerIndex = selectedIndex;
    correctAnswerIndex = currentQuestion.correctAnswerIndex;
    showFeedback = true;
    
    if (isCorrect) {
      userScore += 1;
    }
  });

  Future.delayed(const Duration(seconds: 2), () {
    if (currentQuestionIndex < questionsList.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        correctAnswerIndex = null;
        showFeedback = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            finalScore: userScore,
            totalQuestions: questionsList.length,
          ),
        ),
      );
    }
  });
}
}
// Pantalla de resultados (básica)
