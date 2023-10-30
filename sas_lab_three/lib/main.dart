import 'package:flutter/material.dart';

void main() => runApp(PsychTestApp());

class PsychTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PsychTestPage(),
    );
  }
}

class PsychTestPage extends StatefulWidget {
  @override
  _PsychTestPageState createState() => _PsychTestPageState();
}

class _PsychTestPageState extends State<PsychTestPage> {
  List<String> testQuestions = [
    'Як ви оцінюєте свою власну впевненість?',
    'Як ви ставитеся до виправдань у важкі моменти?',
    'Як ви відноситесь до стресу?',
    'Як часто ви відчуваєте втомленість?',
    'Як ви вирішуєте конфлікти з оточуючими?',
    'Як ви реагуєте на негативну критику?',
    'Як ви оцінюєте свою здатність приймати рішення?',
    'Як ви ставитеся до змін у вашому житті?',
    'Як ви оцінюєте свою самодисципліну?',
    'Як ви відноситесь до власного розвитку?',
  ];

  List<List<String>> options = [
    ['Дуже висока', 'Висока', 'Середня', 'Низька', 'Дуже низька'],
    ['Негативно', 'Нейтрально', 'Позитивно'],
    ['Добре', 'Середньо', 'Погано'],
    ['Рідко', 'Час від часу', 'Часто'],
    ['Пошук компромісу', 'Агресивно', 'Втеча від конфлікту'],
    ['Позитивно', 'Нейтрально', 'Негативно'],
    ['Дуже висока', 'Висока', 'Середня', 'Низька', 'Дуже низька'],
    ['Позитивно', 'Нейтрально', 'Негативно'],
    ['Дуже висока', 'Висока', 'Середня', 'Низька', 'Дуже низька'],
    ['Дуже позитивно', 'Позитивно', 'Середньо', 'Негативно', 'Дуже негативно'],
  ];

  int currentQuestionIndex = 0;
  List<int?> userAnswers = [];

  @override
  void initState() {
    super.initState();
    userAnswers = List<int?>.filled(testQuestions.length, null);
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < testQuestions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Користувач відповів на всі питання, обчислюємо результати.
        int totalScore = 0;
        for (int i = 0; i < userAnswers.length; i++) {
          int? userAnswer = userAnswers[i];
          if (userAnswer != null) {
            // Додаємо бали за відповідь до загального результату.
            totalScore -= userAnswer;
          }
        }

        String conclusion;

        if (totalScore >= -5) {
          conclusion = 'Ваше психологічне здоров\'я високе.';
        } else if (totalScore >= -15) {
          conclusion = 'Ваше психологічне здоров\'я середнє.';
        } else {
          conclusion = 'Ваше психологічне здоров\'я низьке.';
        }

        // Виводимо висновок на екран
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Висновок тесту'),
              content: Text(conclusion),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Очищаємо дані і робимо підготовку для нового тесту, якщо потрібно.
                    setState(() {
                      currentQuestionIndex = 0;
                      userAnswers =
                          List<int?>.filled(testQuestions.length, null);
                    });
                  },
                  child: Text('Закрити'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Психологічний тест'),
      ),
      body: SingleChildScrollView(
        // Wrap the content with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Питання ${currentQuestionIndex + 1}: ${testQuestions[currentQuestionIndex]}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Column(
                children: options[currentQuestionIndex]
                    .asMap()
                    .entries
                    .map((entry) => RadioListTile(
                          title: Text(entry.value),
                          value: entry.key,
                          groupValue: userAnswers[currentQuestionIndex],
                          onChanged: (value) {
                            setState(() {
                              userAnswers[currentQuestionIndex] = value;
                              _nextQuestion();
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
