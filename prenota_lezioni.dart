import 'dart:math';
import 'dart:convert';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';

class PrenotaLezioni extends StatelessWidget {
  final ControllerLogin controller = Get.find(); //pagina utente autenticato
  final ControllerListaLezioni myCntrlPrenotaLezioni = Get.find();





  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.nomeUtente} prenota una lezione'),
      ),
      body: Center(
        child: FormPrenotaLezioni(),
      ),
    );
  }
}

class FormPrenotaLezioni extends StatelessWidget {
  FormPrenotaLezioni({super.key});

  final ControllerListaLezioni myCntrlPrenotaLezioni = Get.find();

  void getData_E_Orario_Calendario_Settimana() async {
    myCntrlPrenotaLezioni.listadataorario.value = <Prenota>[];
    try {
      var url = Uri.parse('$SERVER/lezione/${myCntrlPrenotaLezioni.SceltaMateriaDropDown.value}');
      print(url);
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

            myCntrlPrenotaLezioni.listadataorario.add(
                Prenota(riga['id_giorno'], riga['id_insegnante'], riga['insegnante'], riga['materia'], riga['inizio_lezione'], riga['fine_lezione'], riga['stato'], riga['cod_lezione'])
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

  Future<void> inviaDatiPrenotazione(Map<String, dynamic>  jsonDati) async {
    try {
      var url = Uri.parse('$SERVER/prenota');

      print(jsonDati);
      var response = await http.post(
          url,
          headers: {
            "Access-Control-Allow-Origin": "*", //"http://localhost",
            "Access-Control-Allow-Credentials": 'true',
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "*",
            'Content-Type': 'application/json',
          },
          body: jsonEncode(jsonDati));

      var rispJson = json.decode(response.body);
      if (response.statusCode == 200) {
        print("Prenotato oppure no");
        if (rispJson['ok'] == 'true') {
          myCntrlPrenotaLezioni.ColorContainer.value = Colors.lightGreenAccent;
          myCntrlPrenotaLezioni.messaggio.value =
          'La tua lezione è stata prenotata con successo';
        }
        else {
          myCntrlPrenotaLezioni.ColorContainer.value = Colors.redAccent;
          myCntrlPrenotaLezioni.messaggio.value =
          'La tua lezione non è stata prenotata';
        }
      } else {
        print("non ci sono dati");
      }
    } catch (e) {
      print(e);
    }
  }

  void prenotaLezione(Prenota scelta){

    Map<String, dynamic> prenotaInJson= scelta.toJson();
    print(prenotaInJson);
    inviaDatiPrenotazione(prenotaInJson);

  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Text(
                "Scegli la materia che desideri prenotare",
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.teal, style: BorderStyle.solid, width: 2.0),
              ),
              child: Obx(() => DropdownButton<String>(
                value: myCntrlPrenotaLezioni.SceltaMateriaDropDown.value,
                //elevation: 5,
                style: const TextStyle(color: Colors.black),
                items: <String>[
                  '',
                  'Italiano',
                  'Matematica',
                  'Flutter',
                  'Calcolo numerico',
                ].map<DropdownMenuItem<String>>((String materia) {
                  return DropdownMenuItem<String>(
                    value: materia,
                    child: Text(materia),
                  );
                }).toList(),
                hint: const Text(
                  "Scegli una materia",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onChanged: (String? value) {
                  myCntrlPrenotaLezioni.SceltaMateriaDropDown.value = value!;
                  getData_E_Orario_Calendario_Settimana();
                },
              )),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Text(
                "Seleziona l'orario e il professore desiderato",
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child:
                Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: myCntrlPrenotaLezioni.listadataorario.value
                        .map(
                          (lezione) =>  Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${giorno[lezione.IdGiorno]} dalle ${lezione.InizioLezione} alle ${lezione.FineLezione}, Professore ${lezione.Insegnante}"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        prenotaLezione(lezione);

                                      },
                                      color:Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Row(
                                          children: const [
                                            Icon(Icons.add_circle_outlined),
                                            Text("PRENOTA",
                                                style: TextStyle(fontSize: 16, color: Colors.white),
                                                textAlign: TextAlign.center),
                                          ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                          ),
                        ),
                    ).toList())),
              ),
            ),
            Obx(() =>
             Padding(
               padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
               child: Container(
                  color:myCntrlPrenotaLezioni.ColorContainer.value ,
                  child: Text(
                  myCntrlPrenotaLezioni.messaggio.value,
            ),
            ),),
            )
          ],
        ),
      ),
    );
  }
}
