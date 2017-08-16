sed -i "1 s/Buchungstag/DATE/; s/Verwendungszweck/MEMO/; s/Beguenstigter\/Zahlungspflichtiger/PAYEE/; s/Betrag/AMOUNT/" "$1"
