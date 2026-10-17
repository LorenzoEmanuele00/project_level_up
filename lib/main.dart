import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup/app/app.dart';
import 'package:levelup/app/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await createAppContainer();
  runApp(
    UncontrolledProviderScope(container: container, child: const LevelUpApp()),
  );
}
