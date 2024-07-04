import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _saveForm() {
    print("Name: ${_nameController.text}");
    print("Email: ${_emailController.text}");
    print("Address: ${_addressController.text}");
    print("Phone: ${_phoneController.text}");
    print("Notes: ${_notesController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
          ),
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(labelText: 'Notes'),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _saveForm,
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
