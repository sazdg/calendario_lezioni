import 'dart:async';
import 'dart:convert';

import 'package:calendario_lezioni/userpage.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:calendario_lezioni/lista_lezioni_prenotate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'costanti.dart';


class DettagliLezione extends StatelessWidget {


  //final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return DettagliLezionePage();
  }
}

class DettagliLezionePage extends StatelessWidget {//pagina utente non autenticato, quindi LOGIN
  final ControllerDettagliLezione controller = Get.find();

  void dettagliLezione() async{

  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(' Dettagli Lezione di ${controller.nomeUtente} '),
        ) ,
        body: Center(
        )
    );
  }
}

class ControllerDettagliLezione extends GetxController {
  var id_lezione = 0.obs;
  var id_insegnante = 0.obs;
  var id_studente = 0.obs;
  var inizio_lezione = ''.obs;
  var fine_lezione = ''.obs;
  var stato = 0.obs;
  var nome = TextEditingController();
  var nomeUtente = "Ciao".obs;

}