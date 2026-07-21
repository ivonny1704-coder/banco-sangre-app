import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final correcto = await authProvider.registro(
      nombres: _nombresController.text,
      apellidos: _apellidosController.text,
      correo: _correoController.text,
      contrasena: _contrasenaController.text,
      telefono: _telefonoController.text,
    );

    if (!mounted) {
      return;
    }

    if (correcto) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
      return;
    }

    final mensaje = authProvider.error ?? 'No se pudo completar el registro';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFF9ECEE), Color(0xFFF6F7F9), Color(0xFFECEFF2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
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
                        const Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 54,
                          color: Color(0xFF9D1625),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Crear cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF25282D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Regístrate en el Banco de Sangre',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF70757D)),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _nombresController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Nombres',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (valor) {
                            final texto = valor?.trim() ?? '';

                            if (texto.isEmpty) {
                              return 'Los nombres son obligatorios';
                            }

                            if (texto.length < 2) {
                              return 'Ingresa al menos 2 caracteres';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _apellidosController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Apellidos',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (valor) {
                            final texto = valor?.trim() ?? '';

                            if (texto.isEmpty) {
                              return 'Los apellidos son obligatorios';
                            }

                            if (texto.length < 2) {
                              return 'Ingresa al menos 2 caracteres';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _correoController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonoController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            hintText: '0999999999',
                            counterText: '',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (valor) {
                            final telefono = valor?.trim() ?? '';

                            if (telefono.isEmpty) {
                              return null;
                            }

                            if (!RegExp(r'^[0-9]{10}$').hasMatch(telefono)) {
                              return 'Debe contener 10 números';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contrasenaController,
                          obscureText: _ocultarContrasena,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmarController,
                          obscureText: _ocultarConfirmacion,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (!authProvider.cargando) {
                              _registrar();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _ocultarConfirmacion = !_ocultarConfirmacion;
                                });
                              },
                              icon: Icon(
                                _ocultarConfirmacion
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.isEmpty) {
                              return 'Confirma la contraseña';
                            }

                            if (valor != _contrasenaController.text) {
                              return 'Las contraseñas no coinciden';
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
                                : _registrar,
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
                                    'Crear cuenta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: authProvider.cargando
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.login,
                                  );
                                },
                          child: const Text(
                            'Ya tengo una cuenta',
                            style: TextStyle(
                              color: Color(0xFF9D1625),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
