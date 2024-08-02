import 'package:ex2_expense_tracker/screens/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

final kColorSceme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF4D71DA),
);
final kDarkColorSceme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF4D71DA),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: kColorSceme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorSceme.primary,
          foregroundColor: kColorSceme.onPrimary
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorSceme.primaryContainer,
          shadowColor: kColorSceme.inverseSurface,
        ),
        textTheme: const TextTheme().copyWith(
          titleLarge: textTheme.titleLarge!.copyWith(color: kColorSceme.inverseSurface),
          titleMedium: textTheme.titleMedium!.copyWith(color: kColorSceme.inverseSurface),
          titleSmall: textTheme.titleSmall!.copyWith(color: kColorSceme.inverseSurface),
          bodyLarge: textTheme.bodyLarge!.copyWith(color: kColorSceme.inverseSurface),
          bodyMedium: textTheme.bodyMedium!.copyWith(color: kColorSceme.inverseSurface),
          bodySmall: textTheme.bodySmall!.copyWith(color: kColorSceme.inverseSurface),
        ),
      ),
      darkTheme: ThemeData().copyWith(
        colorScheme: kDarkColorSceme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorSceme.primary,
          shadowColor: kDarkColorSceme.inverseSurface,),
        scaffoldBackgroundColor: kDarkColorSceme.surfaceContainerLow,
        textTheme: const TextTheme().copyWith(
          titleLarge: textTheme.titleLarge!.copyWith(color: kDarkColorSceme.surface),
          titleMedium: textTheme.titleMedium!.copyWith(color: kDarkColorSceme.surface),
          titleSmall: textTheme.titleSmall!.copyWith(color: kDarkColorSceme.surface),
          bodyLarge: textTheme.bodyLarge!.copyWith(color: kDarkColorSceme.surface),
          bodyMedium: textTheme.bodyMedium!.copyWith(color: kDarkColorSceme.surface),
          bodySmall: textTheme.bodySmall!.copyWith(color: kDarkColorSceme.surface),
        ),
        ),
        
      home: const ExpensesScreen(),
      );
  }
}
