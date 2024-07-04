import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final TextEditingController _testAController = TextEditingController();
  final TextEditingController _testBController = TextEditingController();
  final TextEditingController _testCController = TextEditingController();
  final TextEditingController _testDController = TextEditingController();
  final TextEditingController _testEController = TextEditingController();
  final TextEditingController _testFController = TextEditingController();
  final TextEditingController _testGController = TextEditingController();
  final TextEditingController _testHController = TextEditingController();
  final TextEditingController _testIController = TextEditingController();
  final TextEditingController _testJController = TextEditingController();
  final TextEditingController _testKController = TextEditingController();
  final TextEditingController _testLController = TextEditingController();
  final TextEditingController _testMController = TextEditingController();
  final TextEditingController _testNController = TextEditingController();
  final TextEditingController _testOController = TextEditingController();
  final TextEditingController _testPController = TextEditingController();
  final TextEditingController _testQController = TextEditingController();
  final TextEditingController _testRController = TextEditingController();
  final TextEditingController _testSController = TextEditingController();
  final TextEditingController _testTController = TextEditingController();

  FormWidget({super.key});

  void _saveForm() {
    debugPrint("Test A: ${_testAController.text}");
    debugPrint("Test B: ${_testBController.text}");
    debugPrint("Test C: ${_testCController.text}");
    debugPrint("Test D: ${_testDController.text}");
    debugPrint("Test E: ${_testEController.text}");
    debugPrint("Test F: ${_testFController.text}");
    debugPrint("Test G: ${_testGController.text}");
    debugPrint("Test H: ${_testHController.text}");
    debugPrint("Test I: ${_testIController.text}");
    debugPrint("Test J: ${_testJController.text}");
    debugPrint("Test K: ${_testKController.text}");
    debugPrint("Test L: ${_testLController.text}");
    debugPrint("Test M: ${_testMController.text}");
    debugPrint("Test N: ${_testNController.text}");
    debugPrint("Test O: ${_testOController.text}");
    debugPrint("Test P: ${_testPController.text}");
    debugPrint("Test Q: ${_testQController.text}");
    debugPrint("Test R: ${_testRController.text}");
    debugPrint("Test S: ${_testSController.text}");
    debugPrint("Test T: ${_testTController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _testAController,
            decoration: const InputDecoration(labelText: '_testAController'),
          ),
          TextFormField(
            controller: _testBController,
            decoration: const InputDecoration(labelText: '_testBController'),
          ),
          TextFormField(
            controller: _testCController,
            decoration: const InputDecoration(labelText: '_testCController'),
          ),
          TextFormField(
            controller: _testDController,
            decoration: const InputDecoration(labelText: '_testDController'),
          ),
          TextFormField(
            controller: _testEController,
            decoration: const InputDecoration(labelText: '_testEController'),
          ),
          TextFormField(
            controller: _testFController,
            decoration: const InputDecoration(labelText: '_testFController'),
          ),
          TextFormField(
            controller: _testGController,
            decoration: const InputDecoration(labelText: '_testGController'),
          ),
          TextFormField(
            controller: _testHController,
            decoration: const InputDecoration(labelText: '_testHController'),
          ),
          TextFormField(
            controller: _testIController,
            decoration: const InputDecoration(labelText: '_testIController'),
          ),
          TextFormField(
            controller: _testJController,
            decoration: const InputDecoration(labelText: '_testJController'),
          ),
          TextFormField(
            controller: _testKController,
            decoration: const InputDecoration(labelText: '_testKController'),
          ),
          TextFormField(
            controller: _testLController,
            decoration: const InputDecoration(labelText: '_testLController'),
          ),
          TextFormField(
            controller: _testMController,
            decoration: const InputDecoration(labelText: '_testMController'),
          ),
          TextFormField(
            controller: _testNController,
            decoration: const InputDecoration(labelText: '_testNController'),
          ),
          TextFormField(
            controller: _testOController,
            decoration: const InputDecoration(labelText: '_testOController'),
          ),
          TextFormField(
            controller: _testPController,
            decoration: const InputDecoration(labelText: '_testPController'),
          ),
          TextFormField(
            controller: _testQController,
            decoration: const InputDecoration(labelText: '_testQController'),
          ),
          TextFormField(
            controller: _testRController,
            decoration: const InputDecoration(labelText: '_testRController'),
          ),
          TextFormField(
            controller: _testSController,
            decoration: const InputDecoration(labelText: '_testSController'),
          ),
          TextFormField(
            controller: _testTController,
            decoration: const InputDecoration(labelText: '_testTController'),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
