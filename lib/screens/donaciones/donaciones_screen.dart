import 'package:flutter/material.dart';

class DonacionesScreen extends StatefulWidget {
  const DonacionesScreen({super.key});

  @override
  State<DonacionesScreen> createState() => _DonacionesScreenState();
}

class _DonacionesScreenState extends State<DonacionesScreen> {

  final List<Map<String, dynamic>> donaciones = [
    {
      "donante": "Juan Pérez",
      "tipo": "O+",
      "cantidad": "450 ml",
      "fecha": "20/07/2026"
    },
    {
      "donante": "María López",
      "tipo": "A+",
      "cantidad": "450 ml",
      "fecha": "18/07/2026"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donaciones"),
        backgroundColor: Colors.red,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: donaciones.length,
        itemBuilder: (context, index) {

          final item = donaciones[index];

          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(

              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.bloodtype,
                  color: Colors.white,
                ),
              ),

              title: Text(item["donante"]),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Tipo: ${item["tipo"]}"),

                  Text("Cantidad: ${item["cantidad"]}"),

                  Text("Fecha: ${item["fecha"]}")

                ],
              ),

              trailing: PopupMenuButton<String>(

                onSelected: (value) {

                  if (value == 'ver') {

                  } else if (value == 'editar') {

                  } else if (value == 'eliminar') {

                    setState(() {
                      donaciones.removeAt(index);
                    });

                  }

                },

                itemBuilder: (context) => [

                  const PopupMenuItem(
                    value: 'ver',
                    child: Text('Ver'),
                  ),

                  const PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar'),
                  ),

                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Text('Eliminar'),
                  ),

                ],

              ),

            ),

          );

        },

      ),

    );
  }
}