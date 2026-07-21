import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/receptor.dart';
import '../../providers/receptor_provider.dart';
import 'receptor_form_screen.dart';
import 'receptor_detail_screen.dart';

class ReceptoresScreen extends StatefulWidget {
  const ReceptoresScreen({super.key});

  @override
  State<ReceptoresScreen> createState() => _ReceptoresScreenState();
}

class _ReceptoresScreenState extends State<ReceptoresScreen> {
  String _filtroTipo = '';
  String _filtroEstado = '';
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceptorProvider>().loadReceptores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptores'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          // 🔹 Botón recargar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ReceptorProvider>().loadReceptores();
            },
          ),
          // 🔹 Botón filtros
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarFiltros,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '🔍 Buscar receptor...',
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _busqueda = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<ReceptorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar receptores',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error,
                    style: TextStyle(color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadReceptores,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // 🔹 Filtrar receptores
          List<Receptor> receptoresFiltrados = provider.receptores.where((r) {
            final matchBusqueda = _busqueda.isEmpty ||
                r.nombre.toLowerCase().contains(_busqueda) ||
                r.apellido.toLowerCase().contains(_busqueda) ||
                r.cedula.contains(_busqueda);
            
            final matchTipo = _filtroTipo.isEmpty || r.tipoSangre == _filtroTipo;
            final matchEstado = _filtroEstado.isEmpty || r.estado == _filtroEstado;
            
            return matchBusqueda && matchTipo && matchEstado;
          }).toList();

          if (receptoresFiltrados.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bloodtype_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    _busqueda.isNotEmpty || _filtroTipo.isNotEmpty || _filtroEstado.isNotEmpty
                        ? 'No hay receptores que coincidan con los filtros'
                        : 'No hay receptores registrados',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Presiona + para agregar uno nuevo',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  if (_busqueda.isNotEmpty || _filtroTipo.isNotEmpty || _filtroEstado.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _busqueda = '';
                          _filtroTipo = '';
                          _filtroEstado = '';
                        });
                      },
                      child: const Text('Limpiar filtros'),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadReceptores,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: receptoresFiltrados.length,
              itemBuilder: (context, index) {
                final receptor = receptoresFiltrados[index];
                return _buildReceptorCard(context, receptor, provider);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReceptorFormScreen(),
            ),
          ).then((_) {
            context.read<ReceptorProvider>().loadReceptores();
          });
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 🔹 Widget: Tarjeta de receptor
  Widget _buildReceptorCard(BuildContext context, Receptor receptor, ReceptorProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getColorTipoSangre(receptor.tipoSangre).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorTipoSangre(receptor.tipoSangre),
          child: Text(
            receptor.emojiTipoSangre,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        title: Text(
          '${receptor.nombre} ${receptor.apellido}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🆔 ${receptor.cedula}  |  📞 ${receptor.telefono}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getColorEstado(receptor.estado).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    receptor.estado,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getColorEstado(receptor.estado),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getColorTipoSangre(receptor.tipoSangre).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '🩸 ${receptor.tipoSangre}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getColorTipoSangre(receptor.tipoSangre),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, size: 20),
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceptorDetailScreen(receptor: receptor),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceptorFormScreen(receptor: receptor),
                  ),
                ).then((_) {
                  provider.loadReceptores();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              color: Colors.red,
              onPressed: () => _confirmarEliminar(context, receptor.id!, provider),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceptorDetailScreen(receptor: receptor),
            ),
          );
        },
      ),
    );
  }

  // 🔹 Diálogo de confirmación para eliminar
  void _confirmarEliminar(BuildContext context, int id, ReceptorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar receptor'),
        content: const Text('¿Estás seguro de eliminar este receptor? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteReceptor(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '✅ Receptor eliminado' : '❌ Error al eliminar'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // 🔹 Mostrar filtros
  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final tipos = ['', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
        final estados = ['', 'activo', 'inactivo', 'pendiente'];

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Filtro tipo de sangre
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de sangre',
                      border: OutlineInputBorder(),
                    ),
                    value: _filtroTipo.isEmpty ? null : _filtroTipo,
                    items: tipos.map((tipo) {
                      return DropdownMenuItem(
                        value: tipo.isEmpty ? null : tipo,
                        child: Text(tipo.isEmpty ? 'Todos' : tipo),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setStateModal(() {
                        _filtroTipo = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Filtro estado
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    value: _filtroEstado.isEmpty ? null : _filtroEstado,
                    items: estados.map((estado) {
                      return DropdownMenuItem(
                        value: estado.isEmpty ? null : estado,
                        child: Text(estado.isEmpty ? 'Todos' : estado),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setStateModal(() {
                        _filtroEstado = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filtroTipo = '';
                              _filtroEstado = '';
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 🔹 Colores según tipo de sangre
  Color _getColorTipoSangre(String tipo) {
    switch (tipo) {
      case 'A+': return Colors.red.shade700;
      case 'A-': return Colors.red.shade300;
      case 'B+': return Colors.blue.shade700;
      case 'B-': return Colors.blue.shade300;
      case 'AB+': return Colors.purple.shade700;
      case 'AB-': return Colors.purple.shade300;
      case 'O+': return Colors.green.shade700;
      case 'O-': return Colors.green.shade300;
      default: return Colors.grey;
    }
  }

  // 🔹 Colores según estado
  Color _getColorEstado(String estado) {
    switch (estado) {
      case 'activo': return Colors.green;
      case 'inactivo': return Colors.red;
      case 'pendiente': return Colors.orange;
      default: return Colors.grey;
    }
  }
}