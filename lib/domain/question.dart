class Question {
  final String questionText;
  final List<String> answerOptions;
  final int correctAnswerIndex;

  Question (
    {required this.questionText
    , required this.answerOptions,
    required this.correctAnswerIndex,
     }):
     assert(correctAnswerIndex >= 0 && correctAnswerIndex < answerOptions.length, 
    'El índice de la respuesta correcta debe estar dentro del rango de opciones de respuesta.'

  );
} 