class Pessoa {
  int id;
  String nome;
  String telefone;
  String imagem;

  Pessoa(this.id, this.nome, this.telefone, this.imagem);

  Map<String, dynamic> toMap() {
    var mapPessoa = <String, dynamic>{
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'imagem': imagem
    };
    return mapPessoa;
  }

  Pessoa.fromMap(Map<String, dynamic> mapPessoa) {
    id = mapPessoa['id'];
    nome = mapPessoa['nome'];
    telefone = mapPessoa['telefone'];
    imagem = mapPessoa['imagem'];
  }

  @override
  String toString() {
    return 'Pessoa => (id: $id, nome: $nome, telefone: $telefone, imagem $imagem)';
  }
}
