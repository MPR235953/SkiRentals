```diff
@@ TODO @@

Projekt obiektowej bazy danych powinien zawierać opracowaną strukturę składającą się z:

+ definicji typów obiektowych  (łącznie z przewidzianymi niezbędnymi do ich obsługi metodami) ,
+ definicji tabel obiektowych w których składowane będą obiekty wierszowe  i kolumnowe 
- zastosowana zostanie referencja  (wskaźnikiem do rekordu tabeli obiektowej) i dereferencja pozwalająca na wprowadzenie relacji występujących między obiektami,
- wstawianie danych do tabeli z referencją,
+ tworzenie i użytkowanie typu VARRY/ NESTED TABLE - do modelowania relacji jeden do wielu, gdzie po stronie "wiele" występuje kolekcja obiektów,
+ implementacja z zastosowaniem języka PL/SQL logiki biznesowej w postaci pakietów (a w nich procedur/funkcji) umożliwiającej obsługę bazy obiektowej (kursory, ref kursory, obsługa błędów, wyzwalacze itp.)
! przykład obsługi obiektowej bazy danych od strony opracowanych funkcjonalności.


Dodatkowo proszę przygotować sprawozdanie w którym opisane zostaną założenia projektowe:

- opis projektu,
- opis realizacji założeń i przyjętych ograniczeń,
- przyjęte role użytkowników z podziałem na funkcjonalności
- podanie "Diagramu Relacji obiektów" wykorzystanych do stworzenia tabel

Opis

- Właściciel dodaje klienta

+ Właścicel wypożyczalni ma możliwość dodania, edytowania bądź usunięcia sprzętu oraz zobaczenia zawartości tabeli ze sprzętem i szczegółami wypożyczeń
   
+ Klient ma możliwość wypożyczenia sprzętu, oddania go, zobaczenia swoich wypożyczeń oraz dobrania odpowiednich nart
  
+ Jednorazowo klient może wypożyczyć jeden zestaw składający się z nart, butów i kasku. 

+ Klient musi podać swoje dane, aby wypożyczyć sprzęt tj. imię, nazwisko, adres, numer telefonu i email

+ Nie można wypożyczyć sprzętu, który jest aktualnie wypożyczony.
  
! Po zwróceniu sprzętu wyświetlana jest cena do zapłaty, wyliczana na podstawie ceny, czasu wypożyczenia i ewentualnej kary za przekroczenie zadeklarowanego czasu dzierżawy.

- Klient ma możliwość wcześniejszego zwrotu sprzętu, odpowiednio opłata zostanie zmniejszona

- Klient może wydłużyć okres wypożyczenia

+ Narty wybierane są na podstawie wzrostu klienta, płci oraz typu

+ Sprzęt posiada cenę, typ, stan wypożyczenia, [buty] rozmiar, [kask] rozmiar, [narty] długość, [narty] typ (allride, allmountain, race)
  
- Właściciel nie może usunąć przedmiotu który jest aktualnie wypożyczony
  
+ Klient może wypożyczyć dany sprzęt na minimum 1 dzień lub maximum 2 tygodnie
```


<h1>Projekt bazy danych dla wypożyczalni sprzętu narciarskiego</h1>

<h2>Opis projektu</h2>
Projekt jest przykładową prostą bazą danych stworzoną na potrzeby wypożyczalni sprzętu narciarskiego. <b>
Baza zawiera dane o sprzęcie jakim dysponuje wypożyczalnia oraz o jej klientach. Obie te tabele łączy tabela ze szczegółami wypożyczeń. 

<b>Założenia projektu:</b>
<ul>
  <li>Właścicel wypożyczalni ma możliwość dodania, edytowania bądź usunięcia sprzętu oraz zobaczenia zawartości tabeli ze sprzętem i szczegółami wypożyczeń </li> 
   
  <li>Klient ma możliwość wypożyczenia sprzętu, oddania go, zobaczenia swoich wypożyczeń oraz dobrania odpowiednich nart </li> 
  
  <li>Jednorazowo klient może wypożyczyć jeden zestaw składający się z nart, butów i kasku. </li> 

  <li>Klient musi podać swoje dane, aby wypożyczyć sprzęt tj. imię, nazwisko, adres, numer telefonu i email </li> 

  <li>Nie można wypożyczyć sprzętu, który jest aktualnie wypożyczony.  </li> 
  
  <li>Po zwróceniu sprzętu wyświetlana jest cena do zapłaty, wyliczana na podstawie ceny, czasu wypożyczenia i ewentualnej kary za przekroczenie zadeklarowanego czasu dzierżawy. </li> 

  <li>Klient ma możliwość wcześniejszego zwrotu sprzętu, odpowiednio opłata zostanie zmniejszona </li> 

  <li>Klient może wydłużyć okres wypożyczenia </li> 

  <li>Narty wybierane są na podstawie wzrostu klienta, płci oraz typu </li> 

  <li>Sprzęt posiada cenę, typ, stan wypożyczenia, płeć docelową, [buty] rozmiar, [kask] rozmiar, [narty] długość, [narty] typ (allride, allmountain, race) </li> 
  
  <li>Właściciel nie może usunąć przedmiotu który jest aktualnie wypożyczony</li>
  
  <li>Klient może wypożyczyć dany sprzęt na minimum 1 dzień lub maximum 2 tygodnie</li>
</ul>

  
<b>Schemat relacji </b>
 

<b>Typy </b>


<b>Pakiety </b>

 

<b>Kod </b>
