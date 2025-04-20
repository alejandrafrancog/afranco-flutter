import 'package:afranco/domain/question.dart';
import 'package:afranco/data/question_repository.dart';

class QuestionService {
  final QuestionRepository _questionRepository;

  // Inyección de dependencia por constructor
  QuestionService({required QuestionRepository repository})
      : _questionRepository = repository;

  List<Question> getQuestions() {
    return _questionRepository.getQuestions();
  }

  Question getQuestionByIndex(int index) {
    final questions = _questionRepository.getQuestions();
    _validateIndex(index, questions.length);
    return questions[index];
  }

  void _validateIndex(int index, int totalQuestions) {
    if (index < 0 || index >= totalQuestions) {
      throw RangeError('Índice fuera de rango: $index');
    }
  }
}