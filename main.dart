import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muscle Selection App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MuscleModule(),
    );
  }
}

class MuscleModule extends StatefulWidget {
  const MuscleModule({super.key});

  @override
  State<MuscleModule> createState() => _MuscleModuleState();
}

class _MuscleModuleState extends State<MuscleModule> {
  int muscleCount = 1;
  List<String?> selectedMuscles = [''];

  final List<String> muscles = <String>[
    'Back',
    'Chest',
    'Abs',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Quads',
    'Calves',
  ];

  @override
  void initState() {
    super.initState();
    selectedMuscles = List<String?>.filled(muscleCount, null, growable: false);
  }

  void updateMuscleCount(int count) {
    setState(() {
      muscleCount = count;
      selectedMuscles = List<String?>.filled(count, null, growable: false);
    });
  }

  bool get canSubmit {
    return selectedMuscles.every((String? muscle) => muscle != null && muscle.isNotEmpty);
  }

  void _submit() {
    if (canSubmit) {
      final String musclesList = selectedMuscles.join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Training: $musclesList'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select all muscles first!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _exit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscle Selection'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _exit,
            tooltip: 'Back to Login',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Muscle Count Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'How many muscles?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <int>[1, 2, 3, 4]
                          .map(
                            (int num) => ElevatedButton(
                              onPressed: () => updateMuscleCount(num),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: muscleCount == num
                                    ? Colors.purple
                                    : Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                '$num',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Muscle Dropdowns
            Expanded(
              child: ListView.builder(
                itemCount: muscleCount,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Muscle ${index + 1}:',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedMuscles[index],
                            decoration: const InputDecoration(
                              labelText: 'Choose muscle',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.fitness_center),
                            ),
                            items: muscles
                                .map(
                                  (String muscle) => DropdownMenuItem<String>(
                                    value: muscle,
                                    child: Text(muscle),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedMuscles[index] = value;
                              });
                            },
                            validator: (String? value) =>
                                value == null ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Submit Button
            ElevatedButton(
              onPressed: canSubmit ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SUBMIT → SET TRACKER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Dummy LoginPage placeholder
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Page')),
    );
  }
}
