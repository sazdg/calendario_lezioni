import 'dart:async';
import 'dart:convert';

import 'package:calendario_lezioni/userpage.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'costanti.dart';




void main() {
  final cntrl = Get.put(ControllerLogin());
  final cntrlLista = Get.put(ControllerListaLezioni());
  final cntrlDettagli = Get.put(ControllerDettagliLezione());
  runApp(MyApp());

}


class MyApp extends StatelessWidget {

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType){
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CALENDARIO LEZIONI',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:Login(),
          getPages: funzioneRouting(), //FATTA CON GETPAGES

        );
      },
    );
  }
}

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return LoginPage();
  }
}

class LoginPage extends StatelessWidget {//pagina utente non autenticato, quindi LOGIN
  final ControllerLogin controller = Get.find();

  void login() async{
    if (controller.nome.text != '' && controller.password.text != '') {
      print(controller.nome.text);
      print(controller.password.text);

      if (await checkLogin(controller.nome.text, controller.password.text)){
        //vai alla pagina userPage
        controller.messaggio.value ='Credenziali corrette, verrai reindirizzato alla tua pagina' ;
        controller.coloreMex.value = Colors.lightGreenAccent;
        controller.nomeUtente.value = controller.nome.text;
        Timer(const Duration(seconds: 2), ()=> Get.off(() => UserPage()));

      } else {
        controller.messaggio.value = 'Credenziali sbagliate';
        controller.coloreMex.value = Colors.redAccent;
      }
    }
  }

  Future<bool> checkLogin(String nome, String pwd) async {
    var risposta = false;
    Map credenziali = {
      'user' : nome,
      'password' : pwd
    };
    var credenzialiJson = json.encode(credenziali);

    try {
      var url = Uri.parse('$SERVER/check-login');
      var response = await http.post(url, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":"Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "*",
        'Content-Type': 'application/json',
      }, body: credenzialiJson);

      var rispJson = json.decode(response.body);
      if (response.statusCode == 200) {

        if (rispJson['isUser'] == 'true'){
          controller.idUtente.value = rispJson['id_studente'];
          risposta = true;
        }

      } else {
        print('errorejson');
      }

    } catch(e) {
      print(e);
      return risposta;
    }
    return risposta;
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
          backgroundColor: Colors.blue,
        ) ,
        body: Center(
          child: Column(
              children:<Widget>[
                 const Spacer(),
                const Text('Username'),
                 Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: TextField(autofocus: true,
                textAlign: TextAlign.center,
                controller: controller.nome,
                  decoration:const InputDecoration(
                  border: OutlineInputBorder(),
                  ),
                ),
                ),
                const Text('Password'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  child: TextField(autofocus: false,
                    textAlign: TextAlign.center,
                    controller: controller.password,
                    decoration:const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Spacer(),
                  MaterialButton(
                    onPressed: () => login(),
                    color:Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text("LOGIN",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                        ),
                    ),
                const Spacer(),
                Obx(() =>
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: controller.coloreMex.value,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            controller.messaggio.string,
                          ),
                        ),
                      ),
                    ),
                ),
                const Spacer(),
              ]
          ),
        )
    );
  }
}

class ControllerLogin extends GetxController{
  var idUtente = 0.obs;
  var nome = TextEditingController();
  var password = TextEditingController();
  var messaggio = ''.obs;
  var coloreMex = Colors.transparent.obs;
  var nomeUtente = "".obs;
}

class ControllerListaLezioni extends GetxController {
  final listalezioni = <Lezione>[].obs;
  var SceltaMateriaDropDown = ''.obs;
  final listadataorario = <Prenota>[].obs;
  var messaggio = ''.obs;
  var ColorContainer = Colors.transparent.obs;
  var idLezione = 0.obs;
  var codLezione = 0.obs;
}

class ControllerDettagliLezione extends GetxController {
  var idLezione = 0.obs;
  var codLezione = 0.obs;
  var idInsegnante = 0.obs;
  var idStudente = 0.obs;
  var inizioLezione = ''.obs;
  var fineLezione = ''.obs;
  var materia = ''.obs;
  var insegnante = ''.obs;
  var note = ''.obs;
  var stato = 0.obs;
  var orarioInserimento = ''.obs;

  var messaggioFeedback = ''.obs;
  var coloreFeedback = Colors.transparent.obs;
  var bottoneDisabilitato = false.obs;
  var coloreBottoneEffettuato = Colors.yellow.obs;
  var coloreBottoneDisdetto = Colors.red.obs;

}
