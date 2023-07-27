import 'dart:convert';

import 'package:app_cep_turma/service/via_cep_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String? _result;
  dynamic responseCep;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm(),
            // _clearForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: _searchCep,
          child: _loading ? _circularLoading() : Text('Consultar'),
        ));
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    

    final cep = _searchCepController.text;

    if (cep != '') {
      _searching(true);
      print(cep);
      final resultCep = await ViaCepService.fetchCep(cep: cep);
      print(resultCep.localidade); // Exibindo somente a localidade no terminal

      setState(() {
        _result = resultCep.toJson();
        responseCep = jsonDecode(resultCep.toJson());
      });

      _searching(false);

      _searchCepController.clear();
    }
  }

  Widget _buildResultForm() {
    if (responseCep != null) {
      final TextEditingController cepController =
          TextEditingController(text: responseCep['cep']);
      final TextEditingController logradouroController =
          TextEditingController(text: responseCep['logradouro']);
      final TextEditingController complementoController =
          TextEditingController(text: responseCep['complemento']);
      final TextEditingController bairroController =
          TextEditingController(text: responseCep['bairro']);
      final TextEditingController localidadeController =
          TextEditingController(text: responseCep['localidade']);
      final TextEditingController ufController =
          TextEditingController(text: responseCep['uf']);
      final TextEditingController ibgeController =
          TextEditingController(text: responseCep['ibge']);
      final TextEditingController giaController =
          TextEditingController(text: responseCep['gia']);
      return Column(
        children: [
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'CEP'),
            controller: cepController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'Logradouro'),
            controller: logradouroController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'Complemento'),
            controller: complementoController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'Bairro'),
            controller: bairroController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'Localidade'),
            controller: localidadeController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'UF'),
            controller: ufController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'IBGE'),
            controller: ibgeController,
          ),
          TextField(
            autofocus: true,
            enabled: false,
            decoration: const InputDecoration(labelText: 'GIA'),
            controller: giaController,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    responseCep = null;
                    cepController.clear();
                    logradouroController.clear();
                    complementoController.clear();
                    bairroController.clear();
                    localidadeController.clear();
                    ufController.clear();
                    ibgeController.clear();
                    giaController.clear();
                  },
                  child: const Text('Limpar Formulário'))),
        ],
      );
    }
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(_result ?? ''),
    );
  }
}
