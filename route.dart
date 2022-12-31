import 'package:calendario_lezioni/login.dart';
import 'package:calendario_lezioni/userpage.dart';
import 'package:calendario_lezioni/lista_lezioni_prenotate.dart';
import 'package:calendario_lezioni/prenota_lezioni.dart';
import 'package:calendario_lezioni/dettagli_lezione.dart';

import 'package:get/get.dart';




funzioneRouting() => [
  GetPage(
    name: '/loginpage',
    page: () => LoginPage(),
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/userpage',
    page: () => UserPage(),
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/logout',
    page: () => LoginPage(),
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/lezioni-prenotate',
    page: () => ListaLezioniPrenotate(),
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/prenota',
    page: () => PrenotaLezioni(),
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/dettagli',
    page: () => DettagliLezione(),
    transition: Transition.noTransition,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];

