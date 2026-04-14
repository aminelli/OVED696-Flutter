/// File: home_page.dart
/// 
/// Schermata home dell'applicazione.
/// Mostra le informazioni sull'ambiente corrente e fornisce accesso alle funzionalità.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_test/core/config/app_config.dart';
import 'package:demo_test/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:demo_test/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:demo_test/features/tasks/presentation/providers/task_provider.dart';
import 'package:demo_test/features/tasks/presentation/pages/tasks_page.dart';

class HomePage extends StatelessWidget {
  final AppConfig config;

  const HomePage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.appName),
        backgroundColor: _getEnvironmentColor(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card informazioni ambiente
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Environment Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Environment', config.environment.toUpperCase()),
                    _buildInfoRow('App Version', config.appVersion),
                    _buildInfoRow('API Base URL', config.apiBaseUrl),
                    _buildInfoRow('Debug Logging', config.enableDebugLogging ? 'Enabled' : 'Disabled'),
                    _buildInfoRow('Analytics', config.enableAnalytics ? 'Enabled' : 'Disabled'),
                    _buildInfoRow('Crashlytics', config.enableCrashlytics ? 'Enabled' : 'Disabled'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Features
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Bottone Tasks
            ElevatedButton.icon(
              onPressed: () => _navigateToTasks(context),
              icon: const Icon(Icons.task_alt),
              label: const Text('Task Management'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Card info progetto
            const Spacer(),
            Card(
              elevation: 4,
              color: Colors.blue.shade700,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Demo Flutter Best Practices',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Questo progetto dimostra:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem('Clean Architecture'),
                    _buildFeatureItem('Testing completo (Widget, Integration, Golden)'),
                    _buildFeatureItem('Flavors (Dev/Stage/Prod)'),
                    _buildFeatureItem('Code Quality & Metrics'),
                    _buildFeatureItem('Performance Optimization'),
                    _buildFeatureItem('State Management (Provider)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEnvironmentColor() {
    switch (config.environment) {
      case 'dev':
        return Colors.orange;
      case 'stage':
        return Colors.blue;
      case 'prod':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTasks(BuildContext context) {
    // Setup dependency injection per TaskProvider
    final datasource = TaskLocalDatasource();
    final repository = TaskRepositoryImpl(localDatasource: datasource);
    final provider = TaskProvider(repository: repository);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: provider,
          child: const TasksPage(),
        ),
      ),
    );
  }
}
