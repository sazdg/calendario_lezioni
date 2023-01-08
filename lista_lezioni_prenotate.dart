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
        backgroundColor: Colors.orangeAccent,
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
  final ControllerDettagliLezione myCntrlMostraLezione = Get.find();

  void MostraDettagliLezione(int id, int cod) async {
    try {
      var url = Uri.parse('$SERVER/DettagliLezione/${id}');
     // print(url);
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
      if (rispJson['ok'] == 'true') {
        myCntrlMostraLezione.idLezione.value = rispJson['data'][0]['id_lezione'];
        myCntrlMostraLezione.codLezione.value = rispJson['data'][0]['cod_lezione'];
        myCntrlMostraLezione.idInsegnante.value = rispJson['data'][0]['id_insegnante'];
        myCntrlMostraLezione.inizioLezione.value = rispJson['data'][0]['inizio_lezione'];
        myCntrlMostraLezione.fineLezione.value = rispJson['data'][0]['fine_lezione'];
        myCntrlMostraLezione.stato.value = rispJson['data'][0]['stato'];
        myCntrlMostraLezione.materia.value = rispJson['data'][0]['materia'];
        myCntrlMostraLezione.insegnante.value = rispJson['data'][0]['insegnante'];
        myCntrlMostraLezione.orarioInserimento.value = rispJson['data'][0]['orario_inserimento'];
        vaiADettagliLezione(myCntrlMostraLezione.idLezione.value,myCntrlMostraLezione.codLezione.value);


      }else {
        myCntrlMostraLezione.coloreFeedback.value = Colors.redAccent;
        myCntrlMostraLezione.messaggioFeedback.value = 'Ops...qualcosa è andato storto';
      }

    } catch (e) {
      print(e);
    }
  }
  void vaiADettagliLezione(int id, int cod){
    myCntrlListaLezioni.idLezione.value = id;
    myCntrlListaLezioni.codLezione.value = cod;
    Get.to(() => DettagliLezione());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        child: DataTable(
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
              DataCell(Text(elemento.Username.toString())),
              DataCell(Text(elemento.InizioLezione)),
              DataCell(Text(elemento.FineLezione)),
              DataCell(Text(stato[elemento.Stato])), //array per far spuntare lo stato (0=libero, ecc..)
              DataCell(Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: MaterialButton(
                  onPressed: () =>{
                    MostraDettagliLezione(elemento.IdLezione, elemento.CodLezione),},
                  color:Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_sharp,
                        color: Color(0xFF000000),
                      ),
                      Text("DETTAGLI",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              ),
            ],
          ),
        ).toList(),
      ),
      ),
      ),
    ),
    );

  }
}



