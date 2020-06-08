import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho/helpers/VeiculosHelper.dart';
import 'package:trabalho/ui/CadastroPage.dart';

class HomePage extends StatefulWidget {
    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    VeiculoHelper veiculoHelper = VeiculoHelper();

    Future<List<dynamic>> _getLista() async {
        return await veiculoHelper.getTodos();
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text("Meus Veiculos", style: TextStyle(fontSize: 32),),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 34,),
                        onPressed: () {
                            _abrirCadastroVeiculo(context, null);
                        },
                    ),
                ],
            ),
            backgroundColor: Color(0xFFEEEEEE),
            body: FutureBuilder(
                future: _getLista(),
                builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                            return Center(
                                child: Container(
                                    width: 200,
                                    height: 200,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        strokeWidth: 5,
                                    ),
                                ),
                            );
                        default:
                            if (snapshot.hasError) {
                                return Column(
                                    children: <Widget>[
                                        Icon(Icons.error_outline, size: 80, color: Colors.red,),
                                        Text("Não foi possível carregar os livros", style: TextStyle(color: Colors.red, fontSize: 20),),
                                    ],
                                );
                            }
                            else {
                                return _criarListagem(context, snapshot);
                            }
                    }
                },
            ),
        );
    }

    Widget _criarListagem(BuildContext context, AsyncSnapshot snapshot) {
        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
                //return _criarItemLista((snapshot.data[index] as Livro));
                return Dismissible(
                    key: UniqueKey(),
                    child: _criarItemLista((snapshot.data[index] as Veiculo)),
                    direction: DismissDirection.endToStart,
                    background: Container(
                        alignment: Alignment(1, 0),
                        color: Colors.red,
                        child: Icon(Icons.delete_forever, color: Colors.white, size: 32,),
                    ),
                    onDismissed: (DismissDirection direction) {
                        VeiculoHelper().apagar((snapshot.data[index] as Veiculo).codigo);
                    },
                    confirmDismiss: (direction) {
                        return showDialog(context: context,
                            builder: (context) {
                                return AlertDialog(
                                    title: Text("Atenção"),
                                    content: Text("Deseja realmente excluir esse livro?"),
                                    actions: <Widget>[
                                        FlatButton(
                                            child: Text("Sim"),
                                            onPressed: () {
                                                Navigator.of(context).pop(true);
                                            },
                                        ),
                                        FlatButton(
                                            child: Text("Não"),
                                            onPressed: () {
                                                Navigator.of(context).pop(false);
                                            },
                                        ),
                                    ],
                                );
                            }
                        );
                    },
                );
            }
        );
    }

    Widget _criarItemLista(Veiculo veiculo) {
        return GestureDetector(
            child: Card(
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                        children: <Widget>[
                            Expanded(
                                child: Text("Marca: " + veiculo.marca ?? "", style: TextStyle(fontSize: 18),),
                            ),
                            Column(
                                children: <Widget>[
                                    Text("Modelo: " + veiculo.modelo ?? ""),
                                    Text("Valor: ${veiculo.valor == null ? "" : veiculo.valor.toString()}"),
                                    Text("Ano: ${veiculo.ano == null ? "" : veiculo.ano.toString()}"),
                                ],
                            ),
                        ],
                    ),
                ),
            ),
            onTap: () {
                _abrirCadastroVeiculo(context, veiculo);
            },
        );
    }

    void _abrirCadastroVeiculo(BuildContext context, Veiculo veiculo) async {
       await Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroPage(veiculo)));
       setState(() {
       });
    }
}