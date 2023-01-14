# Reverse Polish Notation (ASM)

![MS-DOS logo](https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Msdos-icon.svg/480px-Msdos-icon.svg.png)

---

## [EN]

The program accepts a mathematical operation of up to 25 characters with numbers in the 16-bit range - up to 2^15 and writes them in Reverse Polish Notation (RPN) and then prints the result of this operation.
The executable file (COM) is designed to run on [DosBox](https://www.dosbox.com/download.php?main=1), [DosBox-X](https://dosbox-x.com/) or a regular Dos instance.

The program I created has the following properties:
* 16-bit architecture.
* Calculation of operations:
   * Adding;
   * Subtraction;
   * Multiplication;
   * Dividing.
* Input proofing - prints an error in cases:
   * A character other than a number, space, brackets, or operator;
   * Incorrect notation of the action - forgotten brackets, two operators next to each other.
* Overflow detection - if the result is outside the 16-bit range, an error merrage is printed.
* No support for negative numbers - you can enter a negative number only in the way _(0-x)_

---

## [PL]

Program przyjmuje działanie matematyczne do 25 znaków z liczbami w zakresie 16-bitowym - do 2^15 i wypisuje je w Odwróconej Notacji Polskiej (ONP) po czym wypisuje wynik tego działania.  
Plik wykonywalny (COM) przeznaczony jest do uruchomienia w systemie [DosBox](https://www.dosbox.com/download.php?main=1)ie, [DosBox-X](https://dosbox-x.com/)ie lub zwykłej instancji Dosa.

Program, który stworzyłem posiada następujące właściwości:
* Architektura 16-bitowa.
* Obsługa działań:
  * Dodawanie;
  * Odejmowanie;
  * Mnożenie;
  * Dzielenie.
* Odporne dane wejściowe - wypisuje błąd w wypadkach:
  * Znaku innego niż cyfra, spacja, nawias, lub działanie;
  * Błędnego zapisnia działania - zapomniany nawias, dwa znaki działania przy sobie.
* Wykrywanie przepełnienia - jeśli wynik jest spoza zakresu 16-bit, wypisywany jest błąd.
* Brak obsługi liczb ujemnych - można wprowadzić liczbę ujemną jedynie w sposób _(0-x)_
