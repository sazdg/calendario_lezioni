import 'dart:convert';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/userpage.dart';
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
        backgroundColor: Colors.lightGreenAccent,
        title: Text('${controller.nomeUtente} prenota una lezione',
        style: TextStyle(color: Colors.black)),
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

  void prenotaLezione(Prenota scelta){

    Map<String, dynamic> prenotaInJson= scelta.toJson(); //crea la stringa json dei dati
    inviaDatiPrenotazione(prenotaInJson); //invia la stringa

  }

  Future<void> inviaDatiPrenotazione(Map<String, dynamic>  jsonDati) async {
    myCntrlPrenotaLezioni.ColorContainer.value = Colors.transparent;
    myCntrlPrenotaLezioni.messaggio.value = '';

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

        if (rispJson['ok'] == 'true') {
          myCntrlPrenotaLezioni.ColorContainer.value = Colors.lightGreenAccent;
          myCntrlPrenotaLezioni.messaggio.value =
          'La lezione ${myCntrlPrenotaLezioni.SceltaMateriaDropDown.value} è stata prenotata con successo';

          //aggiornare la lista lezioni
          myCntrlPrenotaLezioni.listalezioni.value = <Lezione>[];
          UserPage prova = new UserPage();
          prova.getDataListaLezioni();

          //toglie la scelta materia e svuota lista del dropdown
          myCntrlPrenotaLezioni.SceltaMateriaDropDown.value = '';
          myCntrlPrenotaLezioni.listadataorario.value = <Prenota>[];

        }
        else {
          myCntrlPrenotaLezioni.ColorContainer.value = Colors.redAccent;
          myCntrlPrenotaLezioni.messaggio.value ='La tua lezione non è stata prenotata';
        }


      } else {
        print("non ci sono dati");
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {

    myCntrlPrenotaLezioni.ColorContainer.value = Colors.transparent;
    myCntrlPrenotaLezioni.messaggio.value = '';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Text(
                "Scegli la materia che desideri prenotare",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.lightGreenAccent, style: BorderStyle.solid, width: 2.0),
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
                  'Storia',
                  'Informatica',
                  'Inglese',
                  'Elettronica',
                  'Diritto',
                  'Filosofia',
                  'Economia',
                  'Sociologia',
                  'Metodologia'
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
                                      color:Colors.lightGreenAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Row(
                                          children: const [
                                            Icon(Icons.add_circle_outlined,
                                              color: Color(0xFF000000),),
                                            Text("PRENOTA",
                                                style: TextStyle(fontSize: 16, color: Colors.black),
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
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color:myCntrlPrenotaLezioni.ColorContainer.value,
                 ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                  myCntrlPrenotaLezioni.messaggio.value,
                    ),
                  ),
                ),
             ),
            )
          ],
        ),
      ),
    );
  }
}
