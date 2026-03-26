import 'package:gerenciador_tarefas/database/database_provider.dart';
import 'package:gerenciador_tarefas/model/tarefa.dart';

class TarefaDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Tarefa tarefa) async {
    final db = await dbProvider.database;
    final valores = tarefa.toMap();

    if (tarefa.id == null) {
      tarefa.id = await db.insert(Tarefa.NOME_TABELA, valores);
      return true;
    } else {
      final registrosAtualizados = await  db.update(
        Tarefa.NOME_TABELA,
        valores,
        where: '${Tarefa.CAMPO_ID} = ?',
        whereArgs: [tarefa.id]
      );

      return registrosAtualizados > 0;
    }
  }

  Future<bool> excluir(int id) async {
    final db = await dbProvider.database;
    final registrosAtualizados = await db.delete(
      Tarefa.NOME_TABELA,
      where: '${Tarefa.CAMPO_ID} = ?',
      whereArgs: [id]
    );

    return registrosAtualizados > 0;
  }

  Future<List<Tarefa>> listar({
    String filtro = '',
    String campoOrdenacao = Tarefa.CAMPO_ID,
    bool usarOrdemDecrescente = false
  }) async {
    String?  where;

    if (filtro.isNotEmpty) {
      where = "UPPER(${Tarefa.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}%'";
    }

    var orderBy = campoOrdenacao;

    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }

    final db = await dbProvider.database;
    final resultado = await db.query(
      Tarefa.NOME_TABELA,
      columns: [Tarefa.CAMPO_ID, Tarefa.CAMPO_DESCRICAO, Tarefa.CAMPO_PRAZO],
      where: where,
      orderBy: orderBy
    );

    return resultado.map((m) => Tarefa.fromMap(m)).toList();
  }
}