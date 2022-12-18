const SERVER = 'http://localhost:3005';

class Lezione {

  late int IdLezione;
  late int IdInsegnante;

  late int IdStudente;
  late String InizioLezione;
  late String FineLezione;
  late int Stato;

  Lezione(int idlezione, int idinsegnante, int idstudente, String iniziolezione,
      String finelezione, int stato) {
    IdLezione = idlezione;
    IdInsegnante = idinsegnante;
    IdStudente = idstudente;
    InizioLezione = iniziolezione;
    FineLezione = finelezione;
    Stato = stato;
  }
}