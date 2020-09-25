import 'dart:async';
import 'dart:io';
import 'package:aplicacao_bancodedados/models/pessoa.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String pessoaTable = 'pessoa';
  String colId = 'id';
  String colNome = 'nome';
  String colTelefone = 'telefone';
  String colImagem = 'imagem';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pessoa2.db';

    var pessoaDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return pessoaDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $pessoaTable ($colId INTEGER PRIMARY KEY, $colNome TEXT, $colTelefone TEXT, $colImagem TEXT)');
  }

  Future<int> insertPessoa(Pessoa pessoa) async {
    Database db = await this.database;
    var resultado = await db.insert(pessoaTable, pessoa.toMap());
    return resultado;
  }

  Future<List<Pessoa>> getPessoa() async {
    Database db = await this.database;
    var resultado = await db.query(pessoaTable);

    List<Pessoa> lista = resultado.isNotEmpty
        ? resultado.map((c) => Pessoa.fromMap(c)).toList()
        : [];
    return lista;
  }

  Future<int> updatePessoa(Pessoa pessoa) async {
    var db = await this.database;
    var resultado = await db.update(pessoaTable, pessoa.toMap(),
        where: '$colId = ?', whereArgs: [pessoa.id]);
    return resultado;
  }

  Future<int> deletePessoa(int id) async {
    var db = await this.database;
    int resultado =
        await db.delete(pessoaTable, where: '$colId == ?', whereArgs: [id]);
    return resultado;
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
