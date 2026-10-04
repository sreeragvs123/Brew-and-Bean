import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/common/app_theme.dart';
import 'package:frontend/core/injection/injection_container.dart';
import 'package:frontend/presentation/bloc/cafe_bloc.dart';
import 'package:frontend/presentation/pages/cafe_page.dart';

void main() {
  initDependencies();
  runApp(const BrewBeanApp());
}

class BrewBeanApp extends StatelessWidget {
  const BrewBeanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brew & Bean',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: BlocProvider(
        create: (_) => sl<CafeBloc>()..add(const CafeStarted()),
        child: const CafePage(),
      ),
    );
  }
}
