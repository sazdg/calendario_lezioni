import 'package:calendario_lezioni/login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
const SERVER = 'http://localhost:3005';

class Lezione {

  late int IdLezione;
  late int IdInsegnante;
  late String Insegnante;
  late String Materia;
  late int IdStudente;
  late String Username;
  late String InizioLezione;
  late String FineLezione;
  late int Stato;
  late int CodLezione;

  Lezione(int idlezione, int idinsegnante, String insegnante, String materia, int idstudente, String username, String iniziolezione,
      String finelezione, int stato, int codlezione) {
    IdLezione = idlezione;
    IdInsegnante = idinsegnante;
    Insegnante = insegnante;
    Materia = materia;
    IdStudente = idstudente;
    Username = username;
    InizioLezione = iniziolezione;
    FineLezione = finelezione;
    Stato = stato;
    CodLezione = codlezione;
  }
}

class Prenota {

  late int IdGiorno;
  late int IdInsegnante;
  late String Insegnante;
  late String Materia;
  late String InizioLezione;
  late String FineLezione;
  late int Stato;
  late int CodLezione;
  final ControllerLogin controller = Get.find();

  Prenota(int idgiorno, int idinsegnante, String insegnante, String materia, String iniziolezione,
      String finelezione, int stato, int codlezione) {
    IdGiorno = idgiorno;
    IdInsegnante = idinsegnante;
    Insegnante = insegnante;
    Materia = materia;
    InizioLezione = iniziolezione;
    FineLezione = finelezione;
    Stato = stato;
    CodLezione = codlezione;
  }

  Map<String, dynamic> toJson() => {
    'id_giorno': IdGiorno,
    'id_insegnante': IdInsegnante,
    'insegnante' : Insegnante,
    'materia': Materia,
    'inizio_lezione' : InizioLezione,
    'fine_lezione' : FineLezione,
    'stato' : Stato,
    'id_studente' : controller.idUtente.value,
    'cod_lezione' : CodLezione
  };

}

final List<String> giorno = ["Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"];
final List<String> stato = ["Libero", "Prenotato", "Effettuata", "Disdetta"];
