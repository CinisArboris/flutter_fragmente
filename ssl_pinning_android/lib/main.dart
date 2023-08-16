import 'package:flutter/material.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:dio/dio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String? _webContent;

  _fetchAndSetWebContent(String url) async {
    var dio = Dio();
    var response = await dio.get(url);
    setState(() {
      _webContent = response.data.toString().substring(0, 500);
    });
  }

  check(String url, String fingerprint, SHA sha, int timeout) async {
    List<String> allowedShA1FingerprintList = [];
    allowedShA1FingerprintList.add(fingerprint);

    try {
      String checkMsg = await HttpCertificatePinning.check(
          serverURL: url,
          sha: sha,
          allowedSHAFingerprints: allowedShA1FingerprintList,
          timeout: timeout);

      if (!mounted) return;

      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(checkMsg),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
      _fetchAndSetWebContent(url);
    } catch (e) {
      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void submit() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      check(
        'https://www.nasa.gov/',
        '06:B5:E2:55:E5:DC:CF:7A:13:CF:8B:D9:24:77:AF:CC:93:6A:A7:3D:68:66:37:A3:FD:DB:2A:72:17:86:8E:BC',
        SHA.SHA256,
        60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ssl Pinning Plugin'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: () => submit(),
                        child: const Text(
                          'Check',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (_webContent != null) ...[
                      Divider(),
                      Text('Web Content:'),
                      Text(_webContent!),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
