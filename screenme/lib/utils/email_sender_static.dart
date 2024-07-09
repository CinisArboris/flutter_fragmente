import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailSenderStatic {
  static final List<String> recipients = [
    'eyver.evm@gmail.com',
    'margaritacc7@outlook.com',
  ];
  static const String subject = 'Captura, Error/Ayuda App Mi Móvil';
  static const String body =
      'Estimados colegas, por favor su colaboración con el siguiente incidente:\n\n'
      'Usuario: \n'
      'Descripción: \n\n';

  static Future<void> sendEmail(String attachmentPath) async {
    final Email email = Email(
      body: body,
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
