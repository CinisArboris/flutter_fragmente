import 'package:flutter/material.dart';

class CLChecklist extends StatefulWidget {
  const CLChecklist({Key? key}) : super(key: key);

  @override
  DefaultState createState() => DefaultState();
}

class DefaultState extends State<CLChecklist> {
  // Definiendo las variables de estado en el nivel de la clase de estado
  List<String> _dropdownValues = [
    'Uno',
    'Dos',
    'Tres',
    'Cuatro'
  ]; // Valores para los dropdowns
  List<String> _listItems = []; // Lista de ítems
  String _inputValue = ''; // Valor ingresado en el campo de texto

  void _addItem() {
    if (_inputValue.isNotEmpty) {
      setState(() {
        _listItems.add(_inputValue);
        _inputValue = ''; // Limpiar el input después de agregar el ítem
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _listItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CLChecklist'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Asegurándonos de que los dropdowns se construyan y manejen dentro del método build
            ...List.generate(
                4,
                (index) => DropdownButton<String>(
                      value: _dropdownValues[
                          index], // Accediendo a _dropdownValues aquí
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValues[index] = newValue!;
                        });
                      },
                      items:
                          _dropdownValues // Usando los valores definidos en la variable de estado
                              .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
            SizedBox(height: 20),
            // Campo de texto y lógica para agregar nuevos ítems
            TextField(
              onChanged: (value) {
                _inputValue =
                    value; // Actualizar _inputValue con el texto ingresado
              },
              decoration: InputDecoration(
                labelText: 'Nuevo ítem',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed:
                      _addItem, // Llama a _addItem cuando se presiona el botón
                ),
              ),
            ),
            SizedBox(height: 20),
            // Construyendo la lista de ítems agregados
            Expanded(
              child: ListView.builder(
                itemCount: _listItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_listItems[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _removeItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Agregar ítem',
        child: Icon(Icons.add),
      ),
    );
  }
}
