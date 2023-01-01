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
import 'package:calendario_lezioni/dettagli_lezione.dart';


import 'costanti.dart';

class ListaLezioniPrenotate extends StatelessWidget {

  final ControllerLogin controller = Get.find(); //pagina utente autenticato
  final ControllerListaLezioni myCntrlListaLezioni = Get.find();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('Lista lezioni prenotate di ${controller.nomeUtente}'),
      ),
      body:  Center(
        child: Column(
            children:<Widget>[
              Expanded(
                child:TabellaLezioniPrenotate(),
              ),
              Spacer(),
            ]
        ),
      ),
    );
  }
}




class TabellaLezioniPrenotate extends StatelessWidget {
  TabellaLezioniPrenotate({super.key});

  final ControllerListaLezioni myCntrlListaLezioni = Get.find();

  @override
  Widget build(BuildContext context) {

    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'N Lezione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Insegnante',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Materia',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Matricola',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Studente',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Inizio lezione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Fine lezione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Stato',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Azioni',
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
              DataCell(Text(elemento.Insegnante.toString())),
              DataCell(Text(elemento.Materia.toString())),
              DataCell(Text(elemento.IdStudente.toString())),
              DataCell(Text(elemento.Username.toString())),
              DataCell(Text(elemento.InizioLezione)),
              DataCell(Text(elemento.FineLezione)),
              DataCell(Text(elemento.Stato.toString())),
              DataCell(MaterialButton(
                onPressed: ()=> Get.to(() => DettagliLezione()),
                color:Colors.teal,
                child: const Text(
                    "Dettagli"
                  ),
                ),
              ),
            ],
          ),
        ).toList(),
    );
  }
}



