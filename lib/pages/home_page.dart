import 'dart:io';
import 'package:aplicacao_bancodedados/helpers/databaseHelper.dart';
import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../pages/pessoas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();
  List<Pessoa> pessoas = List<Pessoa>();

  @override
  void initState() {
    super.initState();

    /*db.getPessoa().then((lista) {
      print(lista);
    });*/
    _exibeTodasPessoas();
  }

  void _exibeTodasPessoas() {
    db.getPessoa().then((lista) {
      setState(() {
        pessoas = lista;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pessoas'),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: <Widget>[],
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibePessoaPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: pessoas.length,
          itemBuilder: (context, index) {
            return _listaPessoas(context, index);
          }),
    );
  }

  _listaPessoas(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: pessoas[index].imagem != null
                          ? FileImage(File(pessoas[index].imagem))
                          : AssetImage('images/person.png'))),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(pessoas[index].nome ?? '',
                        style: TextStyle(fontSize: 18)),
                    Text(pessoas[index].telefone ?? '',
                        style: TextStyle(fontSize: 18))
                  ],
                )),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _exclusao(context, pessoas[index].id, index);
                }),
          ],
        ),
      )),
      onTap: () {
        _exibePessoaPage(pessoa: pessoas[index]);
      },
    );
  }

  void _exibePessoaPage({Pessoa pessoa}) async {
    final pessoaRecebida = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PessoaPage(pessoa: pessoa)),
    );
    if (pessoaRecebida != null) {
      if (pessoa != null) {
        await db.updatePessoa(pessoaRecebida);
      } else {
        await db.insertPessoa(pessoaRecebida);
      }
      _exibeTodasPessoas();
    }
  }

  void _exclusao(BuildContext context, int pessoaid, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Remover Contato'),
            content: Text('Tem certeza que deseja remover o contato?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Não')),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      pessoas.removeAt(index);
                      db.deletePessoa(pessoaid);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Sim'))
            ],
          );
        });
  }
}
