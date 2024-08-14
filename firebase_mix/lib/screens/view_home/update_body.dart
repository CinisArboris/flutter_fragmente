import 'package:firebase_mix/screens/view_home/part_action_button.dart';
import 'package:firebase_mix/screens/view_home/part_info_card_section.dart';
import 'package:flutter/material.dart';
import 'package:firebase_mix/services/handler_view.dart';

class UpdateBody extends StatelessWidget {
  final HandlerView updateHandler;

  const UpdateBody({
    super.key,
    required this.updateHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InfoCardSection(updateHandler: updateHandler),
          ActionButtonSection(
            updateHandler: updateHandler,
            onUpdate: () => Navigator.of(context).pop(),
            onCancel: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
