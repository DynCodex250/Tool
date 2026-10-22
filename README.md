source(file.path(repo_path, "check_duty_against_role.R"))

result <- check_duty_against_role(
  con         = cnn,
  source_role = "_WIBU_VERKAUF_INNENDIENST_MITARBEITER",   # Rolle mit der Aufgabe
  duty        = "RetailDiscountOfferMaintain",              # die Aufgabe
  target_role = "5CDA51EB-9559-4B27-88C4-14601045B1F0",     # Ihre SCM-Rolle
  license     = "Supply Chain Management",                  # Lizenz, bei der es bleiben soll
  export_path = file.path(export_folder, "Pruefung_RetailDiscountOfferMaintain.xlsx")
)

result$Summary       # Objekte nach Gruppe und Zustand
result$NotClosable   # Lücken, die kein Recht schließen kann
Sie sehen zuerst eine Zeile wie „28 gaps … 19 privileges … close 27 of the 28 gaps". Die Excel-Datei hat vier Blätter:

Blatt	Inhalt
Summary	die Übersichtstabelle
Gaps	jede Lücke mit dem Recht, das sie schließt
Privileges	alle Rechte der Aufgabe; CAN_BE_ADDED = TRUE heißt: dieses Recht in die Rolle aufnehmen
NotClosable	was übrig bleibt
Hinweise:

Die Lizenz muss so geschrieben sein wie in D365, also "Supply Chain Management", nicht "SCM". Bei einem falschen Namen zählt die Fehlermeldung die gültigen auf.
Die Funktion passt auf jede Aufgabe, Rolle und Lizenz, zum Beispiel eine Finance-Aufgabe gegen eine Finance-Rolle mit license = "Finance".
Nach dem Einpflegen der 19 Rechte einfach noch einmal aufrufen: Dann sollte nur noch eine Lücke übrig sein, RETAILPRICINGPRIORITYTABLE.
