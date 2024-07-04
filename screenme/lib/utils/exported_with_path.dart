import 'package:screen_recorder/screen_recorder.dart';

class ExporterWithPath extends Exporter {
  String? _path;

  Future<String?> get path async {
    // Implementa la lógica para obtener la ruta del archivo grabado
    return _path;
  }

  @override
  void onNewFrame(Frame frame) {
    // Implementa la lógica para manejar el nuevo frame y guardar la ruta
    // _path = la ruta del archivo grabado;
    super.onNewFrame(frame);
  }
}
