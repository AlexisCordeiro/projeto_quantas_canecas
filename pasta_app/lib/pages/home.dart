import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quantas canecas?'),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: QuantasCanecasApp(),
      ),
    );
  }
}

class QuantasCanecasApp extends StatefulWidget {
  @override
  _QuantasCanecasAppState createState() => _QuantasCanecasAppState();
}

class _QuantasCanecasAppState extends State<QuantasCanecasApp> {
  int quantidadeCanecas = 0;
  int valorEnviado = 0;
  int valorAdicionado = 0;
  late IO.Socket socket;

  Future<int> fetchQuantidadeCanecas() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/quantidade-canecas'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['quantidadeCanecas'];
    } else {
      throw Exception('Falha ao obter a quantidade de canecas');
    }
  }

  Future<void> updateQuantidadeCanecas(int quantidadeCanecas) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/quantidade-canecas'),
      body: {'quantidadeCanecas': quantidadeCanecas.toString()},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] != true) {
        throw Exception('Falha ao atualizar a quantidade de canecas');
      }
      // Emitir a nova quantidade de canecas via socket
      socket.emit('quantidadeCanecas', quantidadeCanecas);
    } else {
      throw Exception('Falha ao atualizar a quantidade de canecas');
    }
  }

  void adicionarCaneca() {
    setState(() {
      quantidadeCanecas++;
      valorAdicionado++;
    });
  }

  void removerCaneca() {
    setState(() {
      if (quantidadeCanecas > 0) {
        quantidadeCanecas--;
        valorAdicionado--;
      }
    });
  }

  Future<void> enviarValor() async {
    setState(() {
      valorEnviado += valorAdicionado;
      quantidadeCanecas = valorEnviado;
      valorAdicionado = 0;
    });

    try {
      await updateQuantidadeCanecas(valorEnviado);
    } catch (e) {
      print('Erro ao atualizar a quantidade de canecas: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://127.0.0.1:8000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Conectado ao servidor de websockets');
    });

    socket.on('quantidadeCanecas', (data) {
      setState(() {
        quantidadeCanecas = data;
        valorEnviado = data;
      });
    });

    getQuantidadeCanecas();
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  Future<void> getQuantidadeCanecas() async {
    try {
      final quantidade = await fetchQuantidadeCanecas();
      setState(() {
        quantidadeCanecas = quantidade;
        valorEnviado = quantidade;
      });
    } catch (e) {
      print('Erro ao obter a quantidade de canecas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Text(
            'Quantidade Atual de canecas: $valorEnviado',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/mug.png',
                width: 80,
                height: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Quantidade de canecas:',
                style: TextStyle(fontSize: 28),
              ),
              Text(
                quantidadeCanecas.toString(),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: adicionarCaneca,
                    child: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(25),
                        backgroundColor: Colors.green),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: removerCaneca,
                    child: Icon(Icons.remove),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(25),
                        backgroundColor: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: enviarValor,
                child: Text(
                  'Enviar',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Text(
                'Feito por Aléxis Cordeiro',
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
        ],
      ),
    );
  }
}
