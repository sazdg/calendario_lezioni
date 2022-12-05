import 'package:calendario_lezioni/login.dart';
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
];

