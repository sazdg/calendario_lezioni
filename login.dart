import 'dart:async';
import 'dart:convert';

import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';




void main() {
  final cntrl = Get.put(ControllerLogin());
 runApp(MyApp());

}


class MyApp extends StatelessWidget {

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CALENDARIO LEZIONI',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:Login(),
      getPages: funzioneRouting(), //QUELLA FATTA CON GETPAGES

    );
  }
}

class Login extends StatelessWidget {


 //final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
   // Map argumentData = Get.arguments ?? Map();
    // print('argomenti login = $argumentData');
    //if (true) { //se sei autenticato
   //   Future.delayed(Duration(seconds: 5), () {
        // cancella la pagina dopo 5 secondi
     //   Navigator.of(context).pop();
      // });
      //return UserPage();
    //} else { //se non sei autenticato
      return LoginPage();
    //}
  }
}

class UserPage extends StatelessWidget {
  final ControllerLogin controller = Get.find();//pagina utente autenticato
  void logout(){
    controller.messaggio.value ='' ;
    controller.coloreMex.value = Colors.transparent;
    controller.nomeUtente.value = '';
    controller.nome.text = '';
    controller.password.text = '';
    Get.offAndToNamed('/loginpage');



  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina utente autenticato'),
      ) ,
      body: Center(
        child: Column(
          children:<Widget>[
            const Spacer(),
            Text('Benvenuto ${controller.nomeUtente}'),
            const Spacer(),
            MaterialButton(
                onPressed: () => logout() ,
              color:Colors.green,
              child: const Text(
                "LOGOUT"
              ),
            ),
            const Spacer(),
          ]
        ),
      )
    );
  }
}


class LoginPage extends StatelessWidget {//pagina utente non autenticato, quindi LOGIN
  final ControllerLogin controller = Get.find();
  void login() async{
    print('Non sei autenticato, quindi sei alla pagina di login');
    if (controller.nome.text != '' && controller.password.text != '') {
      print(controller.nome.text);
      print(controller.password.text);

      if (await checkLogin(controller.nome.text, controller.password.text)){
        //vai alla pagina userPage
        controller.messaggio.value ='Credenziali corrette, verrai reindirizzato alla tua pagina' ;
        controller.coloreMex.value = Colors.green;
        controller.nomeUtente.value = controller.nome.text;
        Timer(const Duration(seconds: 2), ()=> Get.off(() =>UserPage()));

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
        ) ,
        body: Center(
          child: Column(
              children:<Widget>[
                 const Spacer(),
                const Text('Username'),
                TextField(autofocus: true,
                textAlign: TextAlign.center,
                controller: controller.nome,
                ),
                const Spacer(),
                const Text('Password'),
                TextField(autofocus: false,
                textAlign: TextAlign.center,
                controller: controller.password,
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () =>login() ,
                  color:Colors.green,
                  child: const Text(
                      "LOGIN"
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                  controller.messaggio.string,
                  style: TextStyle(
                    color: controller.coloreMex.value,
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
  var nome = TextEditingController();
  var password = TextEditingController();
  var messaggio = ''.obs;
  var coloreMex = Colors.transparent.obs;
  var nomeUtente = "Ciao".obs;
}


