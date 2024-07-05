import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailSender {
  final List<String> recipients = [
    'eyver.evm@gmail.com',
    'margaritacc7@outlook.com',
  ];
  final String subject = 'Captura, Error/Ayuda App Mi Móvil';
  final String body =
      'Estimados colegas, por favor su colaboración con el siguiente incidente:\n\n';

  Future<void> sendEmail(
    String attachmentPath,
    String additionalMessage,
  ) async {
    final Email email = Email(
      body: '$body$additionalMessage',
      subject: subject,
      recipients: recipients,
      attachmentPaths: [attachmentPath],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      throw Exception('Error al enviar el correo: $error');
    }
  }
}
