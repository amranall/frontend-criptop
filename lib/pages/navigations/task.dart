import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTaskCard('Criptop'),
            const SizedBox(height: 20),
            _buildTaskCard('CCUSD'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String projectName) {
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          // TODO: Navigate to specific project task page
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Click to upload image or link for task'),
            ],
          ),
        ),
      ),
    );
  }
}