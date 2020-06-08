import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho/Funcoes.dart';
import 'package:trabalho/helpers/VeiculosHelper.dart';

class CadastroPage extends StatefulWidget {
    final Veiculo _veiculoData;

    CadastroPage(this._veiculoData);

    @override
    _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

    VeiculoHelper veiculoHelper = VeiculoHelper();

    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    final valorController = TextEditingController();
    final anoController = TextEditingController();

    @override
    void initState() {
        super.initState();
        if (widget._veiculoData != null) {
            marcaController.text = widget._veiculoData.marca ?? "";
            modeloController.text = widget._veiculoData.modelo ?? "";
            valorController.text = widget._veiculoData.valor == null ? "" : widget._veiculoData.valor.toString();
            anoController.text = widget._veiculoData.ano == null ? "" : widget._veiculoData.ano.toString();
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text("Cadastro de Veiculos"),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        criarCampoTexto(marcaController, "Marca: ", TextInputType.text),
                        criarCampoTexto(modeloController, "Modelo: ", TextInputType.text),
                        criarCampoTexto(valorController, "Valor", TextInputType.number),
                        criarCampoTexto(anoController, "Ano: ", TextInputType.number),
                        criarBotao("Salvar", Colors.green[900], salvarVeiculo),
                        criarBotaoExcluir(),
                    ],
                ),
            ),
        );
    }

    void salvarVeiculo() {
        if (modeloController.text.isEmpty) {
            Funcoes().mostrarMensagem(context, "Atenção", "Digite o nome do veiculo!");
            return;
        }

        Veiculo veiculo = Veiculo();
        veiculo.marca = marcaController.text;
        veiculo.modelo = modeloController.text;
        veiculo.valor = valorController.text.isNotEmpty ? double.parse(valorController.text) : null;
        veiculo.ano = anoController.text.isNotEmpty ? int.parse(anoController.text) : null;

        if (widget._veiculoData == null) {
            veiculoHelper.inserir(veiculo);
        }
        else {
            veiculo.codigo = widget._veiculoData.codigo;
            veiculoHelper.alterar(veiculo);
        }

        Navigator.pop(context);

    }

    void excluirVeiculo() {
        Funcoes().mostrarPergunta(context, "Atenção",
            "Deseja realmente excluir esse Veiculo?", "Sim", "Não",
            confirmarExclusao, () {});
    }

    void confirmarExclusao() {
        veiculoHelper.apagar(widget._veiculoData.codigo);
        Navigator.pop(context);
    }

    Widget criarCampoTexto(TextEditingController c, String texto, TextInputType teclado) {
        return Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                controller: c,
                decoration: InputDecoration(
                    labelText: texto,
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                ),
                keyboardType: teclado,
            ),
        );
    }

    Widget criarBotao(String texto, Color cor, clique) {
        return Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
                color: cor,
                child: Text(texto, style: TextStyle(color: Colors.white, fontSize: 22),),
                onPressed: clique,
            ),
        );
    }

    Widget criarBotaoExcluir() {
        if (widget._veiculoData != null)
            return criarBotao("Excluir", Colors.red[900], excluirVeiculo);
        else
            return Container();
    }
}
