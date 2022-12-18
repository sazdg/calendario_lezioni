import 'dart:math';

import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'costanti.dart';

class PrenotaLezioni extends StatelessWidget {
  final ControllerLogin controller = Get.find(); //pagina utente autenticato

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.nomeUtente} prenota una lezione'),
      ),
      body: Center(
        child: FormPrenotaLezioni(),
      ),
    );
  }
}

class FormPrenotaLezioni extends StatelessWidget {
  FormPrenotaLezioni({super.key});

  final ControllerListaLezioni myCntrlListaLezioni = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Text(
              "Scegli una materia",
            ),
            Obx(() => DropdownButton<String>(
                  value: myCntrlListaLezioni.SceltaMateriaDropDown.value,
                  //elevation: 5,
                  style: const TextStyle(color: Colors.black),
                  items: <String>[
                    '',
                    'Italiano',
                    'Matematica',
                    'Flutter',
                    'Calcolo numerico',
                  ].map<DropdownMenuItem<String>>((String materia) {
                    return DropdownMenuItem<String>(
                      value: materia,
                      child: Text(materia),
                    );
                  }).toList(),
                  hint: const Text(
                    "Scegli una materia",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (String? value) {
                    myCntrlListaLezioni.SceltaMateriaDropDown.value = value!;
                    print(
                        "scelta ${myCntrlListaLezioni.SceltaMateriaDropDown.value}");
                  },
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
