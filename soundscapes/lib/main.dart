import 'package:flutter/material.dart';
import 'app.dart';
import 'core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseHelper.instance.database;
  
  runApp(const SoundScapesApp());
}
