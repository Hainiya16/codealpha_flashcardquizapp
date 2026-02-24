import 'package:flutter/material.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FlashcardScreen(),
    );
  }
}

class Flashcard {
  String question;
  String answer;

  Flashcard(this.question, this.answer);
}

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {

  List<Flashcard> flashcards = [
    Flashcard("What is Flutter?", "Flutter is a UI toolkit"),
    Flashcard("Who developed Flutter?", "Google"),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  // NEXT
  void nextCard() {
    setState(() {
      showAnswer = false;
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
      }
    });
  }

  // PREVIOUS
  void previousCard() {
    setState(() {
      showAnswer = false;
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  // ADD
  void addFlashcard() {
    if (questionController.text.isNotEmpty &&
        answerController.text.isNotEmpty) {

      setState(() {
        flashcards.add(
          Flashcard(
            questionController.text,
            answerController.text,
          ),
        );
      });

      questionController.clear();
      answerController.clear();
      Navigator.pop(context);
    }
  }

  // DELETE
  void deleteFlashcard() {

    if (flashcards.isEmpty) return;

    setState(() {
      flashcards.removeAt(currentIndex);

      if (currentIndex > 0) {
        currentIndex--;
      }

      showAnswer = false;
    });
  }

  // EDIT
  void editFlashcard() {

    questionController.text =
        flashcards[currentIndex].question;

    answerController.text =
        flashcards[currentIndex].answer;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: Text("Edit Flashcard"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: "Question",
              ),
            ),

            TextField(
              controller: answerController,
              decoration: InputDecoration(
                labelText: "Answer",
              ),
            ),
          ],
        ),

        actions: [

          ElevatedButton(

            onPressed: () {

              setState(() {

                flashcards[currentIndex].question =
                    questionController.text;

                flashcards[currentIndex].answer =
                    answerController.text;

              });

              questionController.clear();
              answerController.clear();

              Navigator.pop(context);

            },

            child: Text("Update"),
          )
        ],
      ),
    );
  }

  // SHOW ADD DIALOG
  void showAddDialog() {

    questionController.clear();
    answerController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: Text("Add Flashcard"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: questionController,
              decoration:
              InputDecoration(labelText: "Question"),
            ),

            TextField(
              controller: answerController,
              decoration:
              InputDecoration(labelText: "Answer"),
            ),
          ],
        ),

        actions: [

          ElevatedButton(
            onPressed: addFlashcard,
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (flashcards.isEmpty) {

      return Scaffold(

        appBar: AppBar(title: Text("Flashcards")),

        body: Center(
          child: Text(
            "No flashcards available",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(

        title: Text("Flashcard Quiz App"),

        actions: [

          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddDialog,
          ),

          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editFlashcard,
          ),

          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteFlashcard,
          ),
        ],
      ),

      body: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Card(

            margin: EdgeInsets.all(20),

            elevation: 8,

            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(15),
            ),

            child: Padding(

              padding: EdgeInsets.all(30),

              child: Column(

                children: [

                  Text(

                    flashcards[currentIndex]
                        .question,

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  if (showAnswer)

                    Text(

                      flashcards[currentIndex]
                          .answer,

                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  SizedBox(height: 20),

                  ElevatedButton(

                    onPressed: () {

                      setState(() {
                        showAnswer = true;
                      });
                    },

                    child:
                    Text("Show Answer"),
                  ),
                ],
              ),
            ),
          ),

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,

            children: [

              ElevatedButton(
                onPressed: previousCard,
                child: Text("Previous"),
              ),

              ElevatedButton(
                onPressed: nextCard,
                child: Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}