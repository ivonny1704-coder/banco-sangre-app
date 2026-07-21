import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const BancoSangreApp());
}

class BancoSangreApp extends StatelessWidget {
  const BancoSangreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..cargarSesion(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Banco de Sangre',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9D1625)),
          scaffoldBackgroundColor: const Color(0xFFF6F7F9),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF9D1625),
                width: 1.5,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.registro: (_) => const RegisterScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (_) => const SesionInicial());
          }

          return null;
        },
      ),
    );
  }
}

class SesionInicial extends StatelessWidget {
  const SesionInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.inicializando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.autenticado) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}
