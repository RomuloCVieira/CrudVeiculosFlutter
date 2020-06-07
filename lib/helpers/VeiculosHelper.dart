import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String nomeBancoDados = "banco_dados.db";

final String tabelaVeiculo = "TbVeiculo";
final String codigoColumn = "codigo";
final String marcaColumn = "marca";
final String modeloColumn = "modelo";
final String valorColumn = "valor";
final String anoColumn = "ano";

class Veiculo {
    int codigo;
    String modelo;
    String marca;
    double valor;
    int ano;

    Veiculo();

    Veiculo.fromMap(Map map) {
        this.codigo = map[codigoColumn];
        this.marca = map[marcaColumn];
        this.modelo = map[modeloColumn];
        this.valor = map[valorColumn];
        this.ano = map[anoColumn];
    }

    Map toMap() {
        Map<String, dynamic> map = {
            codigoColumn: this.codigo,
            marcaColumn: this.marca,
            modeloColumn: this.modelo,
            valorColumn: this.valor,
            anoColumn: this.ano
        };

        return map;
    }

    @override
    String toString() {
        return "Veiculo: (Cod: ${this.codigo}, Marca: ${this.marca} Modelo: ${this.modelo}, Valor: ${this.valor}, Ano: ${this.ano})";
    }
}

class VeiculoHelper {
    static final VeiculoHelper _instance = VeiculoHelper.internal();
    factory VeiculoHelper() => _instance;
    VeiculoHelper.internal();

    Database _db;
    Future<Database> get db async {
        if (_db == null)
            _db = await initDb();
        return _db;
    }

    Future<Database> initDb() async {
        final path = await getDatabasesPath();
        final caminhoBanco = join(path, nomeBancoDados);

        return await openDatabase(caminhoBanco, version: 1, onCreate: (Database db, int newVersion) async {
            await db.execute("CREATE TABLE $tabelaVeiculo ("
                "$codigoColumn INTEGER PRIMARY KEY,"
                "$marcaColumn TEXT,"
                "$modeloColumn TEXT,"
                "$valorColumn DOUBLE,"
                "$anoColumn INTEGER)");
        });
    }

    Future<Veiculo> inserir(Veiculo veiculo) async {
        Database dbVeiculo = await db;
        veiculo.codigo = await dbVeiculo.insert(tabelaVeiculo, veiculo.toMap());
        return veiculo;
    }

    Future<int> alterar(Veiculo veiculo) async {
        Database dbVeiculo = await db;
        return await dbVeiculo.update(tabelaVeiculo, veiculo.toMap(), where: "$codigoColumn = ?", whereArgs: [veiculo.codigo]);
    }

    Future<int> apagar(int codigo) async {
        Database dbVeiculo = await db;
        return await dbVeiculo.delete(tabelaVeiculo, where: "$codigoColumn = ?", whereArgs: [codigo]);
    }

    Future<List> getTodos() async {
        Database dbVeiculo = await db;

        List listaMap = await dbVeiculo.rawQuery("SELECT * FROM $tabelaVeiculo");

        List<Veiculo> listaVeiculo = List();

        for (Map m in listaMap)
            listaVeiculo.add(Veiculo.fromMap(m));

        return listaVeiculo;
    }

    Future<Veiculo> getVeiculo(int codigo) async {
        Database dbVeiculo = await db;

        List<Map> maps = await dbVeiculo.query(
            tabelaVeiculo,
            columns: [codigoColumn, marcaColumn, modeloColumn, valorColumn, anoColumn],
            where: "$codigoColumn = ?",
            whereArgs: [codigo]
        );

        if (maps.length > 0)
            return Veiculo.fromMap(maps.first);
        else
            return null;
    }

    Future<int> getTotal() async {
        Database dbVeiculo = await db;
        return Sqflite.firstIntValue(
            await dbVeiculo.rawQuery("SELECT COUNT(*) FROM $tabelaVeiculo")
        );
    }

    Future close() async {
        Database dbVeiculo = await db;
        dbVeiculo.close();
    }
}