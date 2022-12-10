import 'dart:convert';
import 'dart:math';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';


class ListaLezioniPrenotate extends StatelessWidget {

  final ControllerLogin controller = Get.find(); //pagina utente autenticato


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista lezioni prenotate di ${controller.nomeUtente}'),
      ),
      body: Center(
        child: TabellaLezioniPrenotate(),
      ),
    );
  }
}




class TabellaLezioniPrenotate extends StatelessWidget {

  TabellaLezioniPrenotate({super.key});

  List<Lezione> lezioni = [];

  void getData() async {
    try {
      var url = Uri.parse('$SERVER/get-lezioni');
      var response = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":'false', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":"Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "*",
        'Content-Type': 'application/json',
      });

      var rispJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (rispJson['isTable'] == 'True'){

          for(var i = 0; i < rispJson['data'].length; i++) {
            var riga = rispJson['data'][i];

            lezioni.add(
                Lezione(riga['id_lezione'], riga['id_insegnante'], riga['id_studente'], riga['inizio_lezione'], riga['fine_lezione'], riga['stato'])
            );
          }
        }
      } else {
        print('non ci sono dati');
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'id_lezione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'id_insegnante',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'id_studente',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'inizio_lezione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'fine_lezione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'stato',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'bottone',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows:
       lezioni.map(
          (elemento) => DataRow(
            cells: <DataCell>[
              DataCell(Text(elemento.IdLezione.toString())),
              DataCell(Text(elemento.IdInsegnante.toString())),
              DataCell(Text(elemento.IdStudente.toString())),
              DataCell(Text(elemento.InizioLezione)),
              DataCell(Text(elemento.FineLezione)),
              DataCell(Text(elemento.Stato.toString())),
              DataCell(MaterialButton(
                onPressed: () => print('prova'),
                color:Colors.teal,
                child: Text(
                    "Scopri stato"
                  ),
                ),
              ),
            ],
          ),
        ).toList(),
      /*<DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(
              MaterialButton(
                onPressed: () => getData() ,
                color:Colors.teal,
                child: const Text(
                    "preleva dati"
                ),
              ),
            ),
          ],
        ),
      ],*/
    );
  }
}

class Lezione {

  late int IdLezione;
  late int IdInsegnante ;
  late int IdStudente;
  late String InizioLezione;
  late String FineLezione;
  late int Stato;

  Lezione(int idlezione, int idinsegnante, int idstudente, String iniziolezione, String finelezione, int stato) {
    IdLezione = idlezione;
    IdInsegnante = idinsegnante;
    IdStudente = idstudente;
    InizioLezione = iniziolezione;
    FineLezione = finelezione;
    Stato = stato;
  }


}

