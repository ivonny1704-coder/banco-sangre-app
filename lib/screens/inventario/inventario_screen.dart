import 'package:flutter/material.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Inventario'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono y título
            Center(
              child: Column(
                children: [
                  Icon(Icons.bloodtype, size: 80, color: Colors.red.shade700),
                  const SizedBox(height: 8),
                  Text(
                    'Inventario de Sangre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Banco de Sangre',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tarjeta informativa
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Información General',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'El inventario de sangre es administrado exclusivamente por el personal del banco de sangre.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Los donantes pueden consultar la disponibilidad general de tipos de sangre, pero no pueden ver cantidades específicas ni realizar cambios.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tipos de sangre disponibles
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bloodtype, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Tipos de Sangre Disponibles',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _TipoSangreChip('A+'),
                      _TipoSangreChip('A-'),
                      _TipoSangreChip('B+'),
                      _TipoSangreChip('B-'),
                      _TipoSangreChip('AB+'),
                      _TipoSangreChip('AB-'),
                      _TipoSangreChip('O+'),
                      _TipoSangreChip('O-'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nota adicional
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Para más información sobre disponibilidad específica, contacta al banco de sangre.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Información de contacto
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📞 Contacto',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Teléfono: (123) 456-7890'),
                    const Text('Email: banco.sangre@hospital.com'),
                    const Text('Dirección: Calle Principal #123'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar cada tipo de sangre como un chip
class _TipoSangreChip extends StatelessWidget {
  final String tipo;

  const _TipoSangreChip(this.tipo);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.red.shade300),
      avatar: CircleAvatar(
        backgroundColor: Colors.red.shade700,
        radius: 14,
        child: Text(
          tipo[0],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
