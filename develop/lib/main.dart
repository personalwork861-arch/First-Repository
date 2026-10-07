import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GuessingApp());
}

const navy = Color(0xFF10172A);
const purple = Color(0xFF7C5CFC);

class GuessingApp extends StatelessWidget {
  const GuessingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Guessing Game',
      theme: ThemeData(
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// SCREEN 1: SPLASH
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RangeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.casino, size: 100, color: purple),
            SizedBox(height: 20),
            Text(
              'GUESS THE NUMBER',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            CircularProgressIndicator(color: purple),
          ],
        ),
      ),
    );
  }
}

// SCREEN 2: RANGE SELECTION
class RangeScreen extends StatelessWidget {
  const RangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ranges = [50, 100, 500];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your range'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select a number range',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ...ranges.map((range) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            GameScreen(maxNumber: range),
                      ),
                    );
                  },
                  child: Text(
                    '1 - $range',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// SCREEN 3: MAIN GAME
class GameScreen extends StatefulWidget {
  final int maxNumber;

  const GameScreen({
    super.key,
    required this.maxNumber,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final controller = TextEditingController();
  late int secretNumber;
  String message = 'Enter your guess!';
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    secretNumber =
        Random().nextInt(widget.maxNumber) + 1;
  }

  void checkGuess() {
    final guess = int.tryParse(controller.text);

    if (guess == null ||
        guess < 1 ||
        guess > widget.maxNumber) {
      setState(() {
        message =
            'Enter a number from 1 to ${widget.maxNumber}';
      });
      return;
    }

    setState(() {
      attempts++;

      if (guess == secretNumber) {
        message = 'Correct! You won in $attempts attempts.';
      } else if (guess < secretNumber) {
        message = 'Too low! Try again.';
      } else {
        message = 'Too high! Try again.';
      }
    });
  }

  void restart() {
    setState(() {
      secretNumber =
          Random().nextInt(widget.maxNumber) + 1;
      attempts = 0;
      message = 'Enter your guess!';
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Guessing Game'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const RangeScreen(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.casino,
                size: 90,
                color: purple,
              ),
              const SizedBox(height: 20),
              Text(
                'Guess a number between 1 and ${widget.maxNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 21),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your number',
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: checkGuess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'GUESS',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Attempts: $attempts'),
              const SizedBox(height: 20),
              TextButton(
                onPressed: restart,
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}