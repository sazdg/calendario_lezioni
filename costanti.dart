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

  Lezione(int idlezione, int idinsegnante, String insegnante, String materia, int idstudente, String username, String iniziolezione,
      String finelezione, int stato) {
    IdLezione = idlezione;
    IdInsegnante = idinsegnante;
    Insegnante = insegnante;
    Materia = materia;
    IdStudente = idstudente;
    Username = username;
    InizioLezione = iniziolezione;
    FineLezione = finelezione;
    Stato = stato;
  }
}