import 'package:flutter/material.dart';
import 'screens/inventario/inventario_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco de Sangre',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const InventarioScreen(), // ← Pantalla de inventario
      debugShowCheckedModeBanner: false,
    );
  }
}
