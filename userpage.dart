import 'dart:convert';
import 'dart:math';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';


class UserPage extends StatelessWidget {

  final ControllerLogin controller = Get.find();//pagina utente autenticato
  final ControllerListaLezioni myCntrlListaLezioni = Get.find();

  void logout(){
    controller.messaggio.value ='' ;
    controller.coloreMex.value = Colors.transparent;
    controller.nomeUtente.value = '';
    controller.nome.text = '';
    controller.password.text = '';
    Get.offAndToNamed('/loginpage');
  }

  void getDataListaLezioni() async {
    try {
      var url = Uri.parse('$SERVER/get-lezioni');
      var response = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'false',
        // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "*",
        'Content-Type': 'application/json',
      });

      var rispJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (rispJson['isTable'] == 'true') {
          for (var i = 0; i < rispJson['data'].length; i++) {
            var riga = rispJson['data'][i];

            myCntrlListaLezioni.listalezioni.add(
                Lezione(riga['id_lezione'], riga['id_insegnante'], riga['insegnante'], riga['materia'],
                    riga['id_studente'], riga['username'], riga['inizio_lezione'],
                    riga['fine_lezione'], riga['stato'])
            );
          }
        }
      } else {
        print("non ci sono dati");
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    myCntrlListaLezioni.listalezioni = [];
    getDataListaLezioni();
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage di ${controller.nomeUtente}'),
      ) ,
      body: Center(
        child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(height: 50, width: 200),
                child: MaterialButton(
                  padding: EdgeInsets.all(10.00),
                  onPressed: () => Get.toNamed('/lezioni-prenotate'),
                  color: RandomColorModel().getColor(),
                  child: Column(
                      children: const [
                        Icon(Icons.view_list_outlined),
                        Text("Lista lezioni prenotate",
                            style: TextStyle(fontSize: 22, color: Colors.black),
                            textAlign: TextAlign.center),
                      ]
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(height: 50, width: 200),
                child: MaterialButton(
                  onPressed: () => Get.toNamed('/prenota'),
                  color: RandomColorModel().getColor(),
                  child: Column(
                      children: const [
                        Icon(Icons.add_box_rounded),
                        Text("Prenota le lezioni",
                            style: TextStyle(fontSize: 22, color: Colors.black),
                            textAlign: TextAlign.center),
                      ]
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(height: 50, width: 200),
                child: MaterialButton(
                  onPressed: () => logout() ,
                  color: RandomColorModel().getColor(),
                  child: Column(
                      children: const [
                        Icon(Icons.logout_rounded),
                        Text("Logout",
                            style: TextStyle(fontSize: 22, color: Colors.black),
                            textAlign: TextAlign.center),
                      ]
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }

}


class RandomColorModel {
  Random random = Random();
  Color getColor() {
    return Color.fromARGB(random.nextInt(300), random.nextInt(300),
        random.nextInt(300), random.nextInt(300));
  }
}
