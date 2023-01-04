import 'dart:async';
import 'dart:convert';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/userpage.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:calendario_lezioni/lista_lezioni_prenotate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'costanti.dart';


class DettagliLezione extends StatelessWidget {
  const DettagliLezione({super.key});


  //final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return DettagliLezionePage();
  }
}

class DettagliLezionePage extends StatelessWidget {
  final ControllerDettagliLezione controller = Get.find();
  final ControllerLogin ctrlLogin = Get.find();
  final ControllerListaLezioni ctrlLezione = Get.find();

  void dettagliLezione() async{

  }

  void effettuaLezione() async {

    try {
      var url = Uri.parse('$SERVER/effettuata/${ctrlLezione.idLezione.value}');
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
        if (rispJson['ok'] == 'true') {

        }
      } else {
        print("non ci sono dati");
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    print(ctrlLezione.idLezione);
    return Scaffold(
        appBar: AppBar(
          title: Text('Dettagli Lezione di ${ctrlLogin.nomeUtente.value} '),
        ) ,
        body: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                child: Text('Scegli se effettuare o disdire la lezione'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: MaterialButton(
                      onPressed: () {
                        print('');
                      },
                      color:Colors.yellow.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle,
                          color: Color(0xFFFFFFFF),
                          ),
                          Text("EFFETTUA",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: MaterialButton(
                      onPressed: () {
                        effettuaLezione();
                      },
                      color:Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.cancel_rounded,
                          color: Color(0xFFFFFFFF),
                          ),
                          Text("DISDICI",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
    );
  }
}

class ControllerDettagliLezione extends GetxController {
  var idLezione = 0.obs;
  var idInsegnante = 0.obs;
  var idStudente = 0.obs;
  var inizioLezione = ''.obs;
  var fineLezione = ''.obs;
  var note = ''.obs;
  var stato = 0.obs;

  var messaggioFeedback = ''.obs;
  var coloreFeedback = ''.obs;

}