import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/prenota_lezioni.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';

class ListaLezioniPrenotate extends StatelessWidget {

  final ControllerLogin controller = Get.find(); //pagina utente autenticato
  final ControllerListaLezioni myCntrlListaLezioni = Get.find();

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

  //List<Lezione> lezioni = [];

  final ControllerListaLezioni myCntrlListaLezioni = Get.find();

  @override
  Widget build(BuildContext context) {

    print(myCntrlListaLezioni.listalezioni);

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
      myCntrlListaLezioni.listalezioni.map(
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
                child: const Text(
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


