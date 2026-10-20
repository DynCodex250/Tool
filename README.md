Betreff: Grobe Schätzung: Lizenzen und Datenbank-Speicher für die neue Gesellschaft

Hallo Christian,

wie gewünscht schicke ich dir eine grobe Schätzung für die neue Gesellschaft. Die Zahlen sind ein erster Stand. Im Projekt können sie sich noch ändern.

1. Benutzer und Lizenzen

Wir rechnen im Moment mit 185 Benutzern:

115 Servicetechniker: Activity-Lizenz für 46,80 € → 5.382,00 € im Monat
25 Mitarbeiter im Innendienst: SCM + Finance + Commerce für 227,00 € → 5.675,00 € im Monat
30 Mitarbeiter aus Logistik, Disposition, Prüfdokumentation, Support, Artikelstammdaten, Shop und QM/QS: SCM + Finance für 195,80 € → 5.874,00 € im Monat
15 Mitarbeiter im Vertrieb: SCM + Finance + Commerce für 227,00 € → 3.405,00 € im Monat
Zusammen sind das etwa 20.300 € im Monat, also etwa 244.000 € im Jahr. Die Kosten beginnen mit dem Go-Live im Juni 2027.

Bei den Servicetechnikern wissen wir noch nicht genau, was sie im System machen werden. Wenn sie nur Daten ansehen müssen, reicht eine Team-Member-Lizenz für 7,50 €. Dann sinken die Kosten auf etwa 15.800 € im Monat.

2. Speicherplatz für die Datenbank

Microsoft gibt uns für unsere Datenbanken einen festen Speicherplatz von knapp 700 GB. Davon nutzen wir heute schon etwa 630 GB, für das Produktivsystem und unsere drei Testsysteme.

Für das Projekt kommt jetzt ein weiteres Testsystem für die Datenübernahme dazu, das Migrationssystem. Es ist ungefähr so groß wie unser Produktivsystem, also etwa 210 GB. Dadurch liegen wir ab jetzt bis zum Go-Live über unserem Speicherplatz.

Microsoft erlaubt uns, den Speicherplatz dreimal innerhalb von 365 Tagen für jeweils 45 Tage kostenlos zu erweitern. Die erste Erweiterung läuft gerade und endet Mitte November.

[Bild 1: Kapazitätserweiterung im Admin Center]

Die zwei übrigen Erweiterungen wollen wir direkt vor den Go-Live legen, von Mitte März bis Mitte Juni 2027, denn dann ist der Bedarf am größten. Würden wir sie früher nutzen, wäre es etwa 4.500 € teurer.

Von Mitte November bis Mitte März, also etwa vier Monate, haben wir keine kostenlose Erweiterung. In dieser Zeit müssen wir Speicherplatz kaufen (30 € pro GB und Monat) oder Platz frei machen. Was das kostet, hängt davon ab, wie viel Platz wir vorher frei machen:

Ohne weitere Maßnahmen: ca. 22.000 bis 26.000 €
Strategie 1: Wir bereinigen das Projektsystem und das Migrationssystem so, wie wir es schon beim Testsystem INT gemacht haben. Das heißt, wir löschen alte Batch-Protokolle und die Batch-Historie. Kosten dann: ca. 5.500 bis 9.500 €
Strategie 2: Wie Strategie 1, und zusätzlich kopieren wir das Migrationssystem ohne Buchungsdaten, so wie das Testsystem TST. Das geht nur, wenn die Datenübernahme ohne diese Daten funktioniert. Kosten dann: ca. 500 bis 2.500 €
Das ist der Betrag für die ganze Zeit bis zum Go-Live, keine dauerhaften Kosten. Wichtig ist: Die Bereinigung muss fertig sein, bevor die laufende Erweiterung Mitte November endet.

[Bild 2: Größe der Systeme und die zwei Strategien zur Bereinigung]

Strategie 3: Archivierung (Long-Term Data Retention)

Es gibt noch einen dritten Weg. Alte, abgeschlossene Daten, zum Beispiel Buchungen aus früheren Jahren, können wir aus der Datenbank des Produktivsystems in einen günstigeren Langzeitspeicher von Microsoft verschieben. Die Daten gehen nicht verloren und können weiter angesehen werden. Sie brauchen aber keinen Platz mehr in der Datenbank.

Der Vorteil: Unsere Testsysteme sind Kopien des Produktivsystems. Deshalb werden sie bei der nächsten Kopie auch kleiner.

Die Einrichtung braucht aber Zeit und muss mit den Fachbereichen und den Aufbewahrungsfristen abgestimmt werden. Das hilft uns deshalb eher langfristig, nicht schon in den nächsten Monaten. Wie viel Platz wir damit sparen und was der Langzeitspeicher kostet, prüfen wir noch.

Nach dem Go-Live

Nach dem Go-Live sieht es besser aus. Mit den neuen Lizenzen bekommen wir automatisch etwa 465 GB mehr Speicherplatz. Einen Monat nach dem Go-Live löschen wir außerdem das Projektsystem und das Migrationssystem. Danach ist der Stand gleich, egal welche Strategie wir vorher gewählt haben.

Nach heutiger Rechnung reicht der Platz dann bis etwa Herbst 2028. Bekommen die Techniker die günstigere Team-Member-Lizenz, bringt das weniger Platz; dann reicht er bis etwa Mitte 2028. Bis dahin erwarten wir keine weiteren Kosten für Speicherplatz.

3. Kurz zusammengefasst

Lizenzen: ca. 20.300 € im Monat ab Juni 2027 (ca. 15.800 €, wenn die Techniker nur Daten ansehen)
Speicherplatz bis zum Go-Live: einmalig zwischen ca. 500 € und 26.000 €, je nach Strategie
Mein Vorschlag: Wir setzen Strategie 1 bis Mitte November um und prüfen parallel, ob Strategie 2 für die Datenübernahme möglich ist. Die Archivierung (Strategie 3) planen wir für später.
Zwei Punkte sind noch offen. Die Preise kommen aus unserer ersten Planung und müssen noch mit dem Angebot abgeglichen werden. Außerdem haben vielleicht einige der 185 Benutzer schon heute eine Lizenz, weil sie bereits für eine andere Gesellschaft arbeiten. Für diese Benutzer kommen keine neuen Lizenzkosten dazu.

Ich hoffe, das hilft dir für die Budgetplanung. Wenn etwas unklar ist, sag gerne Bescheid.

Viele Grüße
Cedric
