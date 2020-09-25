import 'dart:ffi';
import 'dart:io';
import 'package:aplicacao_bancodedados/models/pessoa.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';

class PessoaPage extends StatefulWidget {
  final Pessoa pessoa;
  PessoaPage({this.pessoa});

  @override
  PessoaPage_State createState() => PessoaPage_State();
}

class PessoaPage_State extends State<PessoaPage> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool editado = false;
  Pessoa _editaPessoa;

  @override
  void initState() {
    super.initState();
    if (widget.pessoa == null) {
      _editaPessoa = Pessoa(null, '', '', null);
    } else {
      _editaPessoa = Pessoa.fromMap(widget.pessoa.toMap());
      _nomeController.text = _editaPessoa.nome;
      _telefoneController.text = _editaPessoa.telefone;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title:
            Text(_editaPessoa.nome == '' ? 'Novo Contato' : _editaPessoa.nome),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _editaPessoa);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editaPessoa.imagem != null
                            ? FileImage(File(_editaPessoa.imagem))
                            : AssetImage('images/person.png'))),
              ),
            ),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (text) {
                editado = true;
                setState(() {
                  _editaPessoa.nome = text;
                });
              },
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              onChanged: (text) {
                editado = true;
                _editaPessoa.telefone = text;
              },
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }
}
