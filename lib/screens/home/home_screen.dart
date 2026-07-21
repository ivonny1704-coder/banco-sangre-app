import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    await context.read<AuthProvider>().cerrarSesion();

    if (!context.mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final usuario = authProvider.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Banco de Sangre'),
        backgroundColor: const Color(0xFF9D1625),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _cerrarSesion(context),
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: Color(0xFFF7DFE2),
                    child: Icon(
                      Icons.person,
                      size: 38,
                      color: Color(0xFF9D1625),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    usuario?.nombreCompleto ?? 'Usuario',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(usuario?.correo ?? '', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Chip(label: Text(usuario?.rol.nombre ?? 'Sin rol')),
                  const SizedBox(height: 20),
                  const Text(
                    'Autenticación realizada correctamente.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
