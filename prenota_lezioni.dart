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

  void getData_E_Orario_Calendario_Settimana() async {
    myCntrlPrenotaLezioni.listadataorario = [];
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
                Prenota(riga['id_giorno'], riga['id_insegnante'], riga['materia'],
                    riga['inizio_lezione'],
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
                  print(
                      "scelta ${myCntrlPrenotaLezioni.SceltaMateriaDropDown.value}");
                  print("funzione query /lezione/:materia");
                },
              )),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Text(
                "Scegli l'orario desiderato",
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child:Column(
              children: myCntrlPrenotaLezioni.listadataorario
              .map((i) => ListTile(title: Text(i.toString())))
              .toList()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
