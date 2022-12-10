import 'dart:math';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';


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
          title: Text('Homepage di ${controller.nomeUtente}'),
        ) ,
        body: Center(
          child: GridView.count(
              crossAxisCount: 1,
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                MaterialButton(
                  onPressed: () => Get.offAndToNamed('/...'),
                  color: RandomColorModel().getColor(),
                  child: Column(
                    children: const [
                      Icon(Icons.view_list_outlined),
                    Text("Lista lezioni prenotate",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        textAlign: TextAlign.center),
                    ]
                  )
                ),
                MaterialButton(
                    onPressed: () => Get.offAndToNamed('/...'),
                    color: RandomColorModel().getColor(),
                    child: Column(
                        children: const [
                          Icon(Icons.add_box_rounded),
                          Text("Prenota le lezioni",
                              style: TextStyle(fontSize: 22, color: Colors.black),
                              textAlign: TextAlign.center),
                        ]
                    )
                ),
                MaterialButton(
                    onPressed: () => logout() ,
                    color: RandomColorModel().getColor(),
                    child: Column(
                        children: const [
                          Icon(Icons.logout_rounded),
                          Text("Logout",
                              style: TextStyle(fontSize: 22, color: Colors.black),
                              textAlign: TextAlign.center),
                        ]
                    )
                ),
              ] /*SliverChildListDelegate(

                items.map((data) =>
                    GestureDetector(
                        onTap: (){
                          print("Navigator.of(context).pushNamed(RouteName.GridViewExtent)");

                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: data.color,
                          child: Column(
                            children: [
                              data.icon,
                              Text(data.title,
                                  style: const TextStyle(fontSize: 22, color: Colors.black),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        )),
                ).toList(),
              )),*/
        ),
        ),
    );
  }
/*  List<GridListItems> items = [
    GridListItems('Lista lezioni prenotate', const Icon(Icons.view_list_outlined)),
    GridListItems('Prenotazione lezioni', const Icon(Icons.add_box_rounded)),
    GridListItems('Logout', const Icon(Icons.logout_rounded)),
  ];*/
}

/*class GridListItems {

  Color color = RandomColorModel().getColor();
  String title = "";
  Icon icon = const Icon(Icons.contact_mail);

  //Function myFunction = logout();


  GridListItems(String titolo, Icon icona) {
    title = titolo;
    icon = icona;
  }
}*/

class RandomColorModel {
  Random random = Random();
  Color getColor() {
    return Color.fromARGB(random.nextInt(300), random.nextInt(300),
        random.nextInt(300), random.nextInt(300));
  }
}
