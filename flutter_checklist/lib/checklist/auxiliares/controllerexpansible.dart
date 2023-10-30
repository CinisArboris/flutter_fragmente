import 'package:flutter/foundation.dart';

class ExpandablePanelController {
  // Usar ValueNotifier permite a los interesados suscribirse a los cambios.
  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);

  // Proporciona una forma de saber si el panel está expandido.
  bool get isExpanded => _isExpandedNotifier.value;

  // Método para cambiar el estado y notificar a los oyentes.
  void togglePanel() {
    _isExpandedNotifier.value = !_isExpandedNotifier.value;
  }

  // Permite a los widgets escuchar cambios.
  void addListener(VoidCallback listener) {
    _isExpandedNotifier.addListener(listener);
  }

  // Permite a los widgets dejar de escuchar cambios.
  void removeListener(VoidCallback listener) {
    _isExpandedNotifier.removeListener(listener);
  }
}
