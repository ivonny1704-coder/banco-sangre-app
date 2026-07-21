import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _ocultarContrasena = true;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final correcto = await authProvider.login(
      correo: _correoController.text,
      contrasena: _contrasenaController.text,
    );

    if (!mounted) {
      return;
    }

    if (correcto) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
      return;
    }

    final mensaje = authProvider.error ?? 'No se pudo iniciar sesión';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9ECEE), Color(0xFFF6F7F9), Color(0xFFECEFF2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 28,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 72,
                            height: 72,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9D1625),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.bloodtype_rounded,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Text(
                          'Banco de Sangre',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF25282D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Inicia sesión para acceder al sistema',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF70757D),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _correoController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            hintText: 'correo@ejemplo.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (valor) {
                            final correo = valor?.trim() ?? '';

                            if (correo.isEmpty) {
                              return 'El correo es obligatorio';
                            }

                            final expresion = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );

                            if (!expresion.hasMatch(correo)) {
                              return 'Ingresa un correo válido';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _contrasenaController,
                          obscureText: _ocultarContrasena,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) {
                            if (!authProvider.cargando) {
                              _iniciarSesion();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: 'Mínimo 6 caracteres',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _ocultarContrasena = !_ocultarContrasena;
                                });
                              },
                              icon: Icon(
                                _ocultarContrasena
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.isEmpty) {
                              return 'La contraseña es obligatoria';
                            }

                            if (valor.length < 6) {
                              return 'Debe tener al menos 6 caracteres';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: authProvider.cargando
                                ? null
                                : _iniciarSesion,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF9D1625),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: authProvider.cargando
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          runSpacing: 0,
                          children: [
                            const Text(
                              '¿No tienes una cuenta?',
                              style: TextStyle(color: Color(0xFF70757D)),
                            ),
                            TextButton(
                              onPressed: authProvider.cargando
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.registro,
                                      );
                                    },
                              child: const Text(
                                'Regístrate',
                                style: TextStyle(
                                  color: Color(0xFF9D1625),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
