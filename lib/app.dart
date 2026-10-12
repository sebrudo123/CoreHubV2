import 'package:flutter/material.dart';

import '../shared/theme/app_theme.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

class GameHubApp extends StatelessWidget {
  const GameHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (DismissIntent intent) {
            FocusManager.instance.primaryFocus?.unfocus();
            return null;
          },
        ),
      },
      child: MaterialApp(
        title: 'DroidDeck GameHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: const DashboardPage(),
      ),
    );
  }
}
