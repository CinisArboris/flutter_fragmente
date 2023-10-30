import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist/objetos/wsresponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_checklist/checklist/objetos/clparticipante.dart';
import 'package:flutter_checklist/checklist/objetos/cldocumentos.dart';
import 'package:flutter_checklist/checklist/auxiliares/controllerexpansible.dart';
import 'package:flutter_checklist/checklist/component/CLDropDown.dart'; // Asegúrate de que este import es correcto

class CLChecklist extends StatefulWidget {
  const CLChecklist({Key? key}) : super(key: key);

  @override
  _CLChecklistState createState() => _CLChecklistState();
}

class _CLChecklistState extends State<CLChecklist> {
  late Future<WSResponse> futureResponse;
  CLParticipante?
      selectedParticipant; // El participante seleccionado actualmente

  // Definir los títulos de los paneles desplegables
  final List<String> panelTitles = [
    'Documentos Nivel 1',
    'Documentos Nivel 2',
    'Documentos Nivel 3',
    'Documentos Nivel 4',
  ];

  @override
  void initState() {
    super.initState();
    futureResponse = _fetchData();
  }

  Future<WSResponse> _fetchData() async {
    final response = await http.get(Uri.parse('https://www.google.com'));

    if (response.statusCode == 200) {
      Random random = Random();
      List<CLParticipante> participantes =
          List.generate(random.nextInt(5) + 1, (index) {
        List<List<CLDocumento>> documentosPorNivel = List.generate(4, (nivel) {
          // 4 niveles
          return List.generate(random.nextInt(6) + 1, (docIndex) {
            // documentos aleatorios por nivel
            return CLDocumento()
              ..codigo = (100 + random.nextInt(900)).toString()
              ..nombre = [
                'FOTOCOPIA LUZ',
                'FOTOCOPIA AGUA',
                'MALLA CURRICULAR',
                'PASAPORTE'
              ][random.nextInt(4)]
              ..descripcion = 'Descripción ${random.nextInt(100)}';
          });
        });

        return CLParticipante()
          ..codigo = (1000 + random.nextInt(9000)).toString()
          ..nombres = 'Nombre ${random.nextInt(100)}'
          ..tipoParticipante =
              ['TITULAR', 'CODEUDOR', 'GARANTE'][random.nextInt(3)]
          ..documentosPorNivel = documentosPorNivel;
      });

      return WSResponse()..listaParticipantes = participantes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist con datos dinámicos'),
      ),
      body: FutureBuilder<WSResponse>(
        future: futureResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data'));
          } else {
            var participantes = snapshot.data!.listaParticipantes;

            return Column(
              children: [
                DropdownButton<CLParticipante>(
                  hint: Text("Selecciona un participante"),
                  items: participantes.map((CLParticipante participante) {
                    return DropdownMenuItem<CLParticipante>(
                      value: participante,
                      child: Text(participante.nombres),
                    );
                  }).toList(),
                  onChanged: (CLParticipante? nuevoParticipanteSeleccionado) {
                    setState(() {
                      selectedParticipant = nuevoParticipanteSeleccionado;
                      // Puedes imprimir los documentos del participante seleccionado para depuración
                      print(selectedParticipant?.documentosPorNivel);
                    });
                  },
                  value: selectedParticipant,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: panelTitles.length, // Cuatro niveles
                    itemBuilder: (context, index) {
                      // Obtener los documentos del nivel actual, si hay un participante seleccionado
                      List<CLDocumento> documentosNivel = selectedParticipant ==
                              null
                          ? [] // Si no hay participante seleccionado, la lista está vacía
                          : selectedParticipant!.documentosPorNivel[index];

                      // Crear un controlador para cada panel expandible
                      var panelController = ExpandablePanelController();

                      // Asegurarse de que los paneles se reconstruyan con nuevos datos
                      Key key =
                          UniqueKey(); // crear una clave única para forzar la reconstrucción

                      return CustomExpandablePanel(
                        key: key, // usar la clave aquí
                        controller: panelController,
                        title: panelTitles[index], // Título del panel
                        documentos: documentosNivel, // Documentos de este nivel
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
