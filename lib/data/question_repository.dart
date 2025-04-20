import 'package:afranco/domain/question.dart';

class QuestionRepository {
  final List<Question> _questions = [
    Question(
      questionText: "¿Cuál es la capital de Francia?",
      answerOptions: ["Madrid", "París", "Roma"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "¿Cuál es la capital de Japón?",
      answerOptions: ["Osaka", "Kioto", "Tokio"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "¿Cuánto es 2 + 2?",
      answerOptions: ["3", "4", "5"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "¿Cuál es el océano más grande del mundo?",
      answerOptions: ["Atlántico", "Índico", "Pacífico"],
      correctAnswerIndex: 2,
    ),
  ];

  List<Question> getQuestions() => _questions;
  
  // Opcional: Método para agregar más preguntas dinámicamente
  void addQuestion(Question newQuestion) {
    _questions.add(newQuestion);
  }
}