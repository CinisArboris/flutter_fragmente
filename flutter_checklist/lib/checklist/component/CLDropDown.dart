import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist/auxiliares/controllerexpansible.dart';
import 'package:flutter_checklist/checklist/objetos/cldocumentos.dart';

class CustomExpandablePanel extends StatefulWidget {
  final ExpandablePanelController controller;
  final String title;
  final List<CLDocumento> documentos;

  const CustomExpandablePanel({
    Key? key,
    required this.controller,
    required this.title,
    required this.documentos,
  }) : super(key: key);

  @override
  _CustomExpandablePanelState createState() => _CustomExpandablePanelState();
}

class _CustomExpandablePanelState extends State<CustomExpandablePanel> {
  @override
  void initState() {
    super.initState();

    // Escuchar cambios en el controlador para saber cuándo reconstruir
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          // El estado del panel ha cambiado, necesitamos reconstruir
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        // Esto debería llamar a un método en tu ExpandablePanelController
        widget.controller.togglePanel();
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(widget.title));
          },
          body: Column(
            children: widget.documentos.map((doc) {
              return ListTile(
                title: Text(doc.nombre),
                subtitle: Text('Código: ${doc.codigo} - ${doc.descripcion}'),
              );
            }).toList(),
          ),
          isExpanded: widget.controller.isExpanded,
        ),
      ],
    );
  }
}
