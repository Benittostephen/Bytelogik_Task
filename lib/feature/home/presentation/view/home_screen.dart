import 'package:byte_logik/core/shared/widgest/custom_button.dart';
import 'package:byte_logik/feature/auth/presentation/provider/auth_provider.dart';
import 'package:byte_logik/feature/auth/presentation/view/login_screen.dart';
import 'package:byte_logik/feature/home/presentation/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final counterNotifier = ref.read(counterProvider.notifier);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen', style: TextStyle(fontSize: 25)),
        // centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authNotifier.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    'Counter Value',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$counter',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'Increment (+1)',
              onPressed: counterNotifier.increment,
              backgroundColor: Colors.green,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Decrement (-1)',
              onPressed: counterNotifier.decrement,
              backgroundColor: Colors.orange,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Reset',
              onPressed: counterNotifier.reset,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
