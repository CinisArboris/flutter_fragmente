import 'package:flutter/material.dart';
import 'package:firebase_mix/widgets/w_info_card.dart';
import 'package:firebase_mix/services/handler_view.dart';

class InfoCardSection extends StatelessWidget {
  final HandlerView updateHandler;

  const InfoCardSection({
    super.key,
    required this.updateHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const InfoCard(
          title: 'Detalle',
          subtitle: 'Modulos disponibles : 15',
        ),
        const SizedBox(height: 20),
        InfoCard(
          title: 'Versión instalada en el dispositivo',
          subtitle: updateHandler.localVersion,
        ),
        const SizedBox(height: 20),
        InfoCard(
          title: 'Descripción de la APK',
          subtitle: updateHandler.remoteDetail,
        ),
        const SizedBox(height: 20),
        InfoCard(
          title: 'Versión disponible en el servidor',
          subtitle: updateHandler.remoteVersion,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
