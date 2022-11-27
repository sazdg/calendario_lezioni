import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;



void main() {
  final cntrl = Get.put(ControllerLogin());
 runApp(MyApp());

}


class MyApp extends StatelessWidget {

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CALENDARIO LEZIONI',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:Login(),
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
    print ('logout');

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina utente autenticato'),
      ) ,
      body: Center(
        child: Column(
          children:<Widget>[
            Text('Benvenuto ${controller.nomeUtente}'),
            MaterialButton(
                onPressed: () =>logout() ,
              color:Colors.green,
              child: const Text(
                "LOGOUT"
              ),
            )
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
        controller.messaggio.value ='Credenziali corrette' ;
        controller.coloreMex.value = Colors.green;
        print("fdsfds");
      } else {
        controller.messaggio.value = 'Credenziali sbagliate';
        controller.coloreMex.value = Colors.redAccent;
        print("nop");
      }
    }
  }
  Future<bool> checkLogin(String nome, String pwd) async {
    //TODO inserire le credenziali qui e mandarle all'api
    var risposta = false;
    try {
      var url = Uri.parse('http://localhost:3005/check-login');
      var response = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":"Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "*",
        'Content-Type': 'application/json',
      });

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


