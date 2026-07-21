import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/receptor.dart';
import '../../providers/receptor_provider.dart';

class ReceptorFormScreen extends StatefulWidget {
  final Receptor? receptor;

  const ReceptorFormScreen({super.key, this.receptor});

  @override
  State<ReceptorFormScreen> createState() => _ReceptorFormScreenState();
}

class _ReceptorFormScreenState extends State<ReceptorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEditing;

  // Controladores
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();

  // Valores seleccionables
  String _genero = 'M';
  String _tipoSangre = 'A+';
  String _estado = 'activo';

  // Opciones
  final List<String> _generos = ['M', 'F', 'Otro'];
  final List<String> _tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _estados = ['activo', 'inactivo', 'pendiente'];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.receptor != null;

    if (_isEditing) {
      final r = widget.receptor!;
      _nombreController.text = r.nombre;
      _apellidoController.text = r.apellido;
      _cedulaController.text = r.cedula;
      _fechaNacimientoController.text = r.fechaNacimiento;
      _telefonoController.text = r.telefono;
      _emailController.text = r.email;
      _direccionController.text = r.direccion;
      _genero = r.genero;
      _tipoSangre = r.tipoSangre;
      _estado = r.estado;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _cedulaController.dispose();
    _fechaNacimientoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Receptor' : 'Nuevo Receptor'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Apellido
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Cédula
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Fecha Nacimiento
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha Nacimiento * (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _fechaNacimientoController.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              const SizedBox(height: 16),

              // Género
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Género *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.transgender),
                ),
                value: _genero,
                items: _generos.map((g) {
                  return DropdownMenuItem(value: g, child: Text(g));
                }).toList(),
                onChanged: (value) => setState(() => _genero = value!),
              ),
              const SizedBox(height: 16),

              // Tipo Sangre
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Sangre *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                value: _tipoSangre,
                items: _tiposSangre.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (value) => setState(() => _