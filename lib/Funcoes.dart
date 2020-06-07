import 'package:flutter/material.dart';

class Funcoes {
    void mostrarMensagem(BuildContext context, String titulo, String texto) {
        showDialog(context: context,
            builder: (context) {
                return AlertDialog(
                    title: Text(titulo),
                    content: Text(texto),
                    actions: <Widget>[
                        FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                                Navigator.pop(context);
                            },
                        ),
                    ],
                );
            }
        );
    }

    void mostrarPergunta(BuildContext context, String titulo, String texto, String txtSim, String txtNao, funcSim, funcNao) {
        showDialog(context: context,
            builder: (context) {
                return AlertDialog(
                    title: Text(titulo),
                    content: Text(texto),
                    actions: <Widget>[
                        FlatButton(
                            child: Text(txtSim),
                            onPressed: () {
                                funcSim();
                                Navigator.pop(context);
                            },
                        ),
                        FlatButton(
                            child: Text(txtNao),
                            onPressed: () {
                                funcNao();
                                Navigator.pop(context);
                            },
                        ),
                    ],
                );
            }
        );
    }
}