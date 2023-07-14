import 'package:flutter/material.dart';

void main() => runApp(QuantasCanecasApp());

class QuantasCanecasApp extends StatefulWidget {
  @override
  _QuantasCanecasAppState createState() => _QuantasCanecasAppState();
}

class _QuantasCanecasAppState extends State<QuantasCanecasApp> {
  int quantidadeCanecas = 0;

  void adicionarCaneca() {
    setState(() {
      quantidadeCanecas++;
    });
  }

  void removerCaneca() {
    setState(() {
      if (quantidadeCanecas > 0) {
        quantidadeCanecas--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
                    padding: EdgeInsets.all(25), backgroundColor: Colors.green),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: removerCaneca,
                child: Icon(Icons.remove),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(25), backgroundColor: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Enviar',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
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
    );
  }
}
