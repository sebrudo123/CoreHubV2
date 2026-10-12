import 'package:flutter/material.dart';

import '../shared/theme/app_theme.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

class CoreHubApp extends StatelessWidget {
  const CoreHubApp({super.key});

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
        title: 'CoreHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: const DashboardPage(),
      ),
    );
  }
}
