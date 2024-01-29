SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'mydb';

-- Se il database non esiste, crea il database e le tabelle
IF @@ROWCOUNT = 0 THEN
    CREATE DATABASE mydb;
    USE mydb;

    -- Crea le tabelle e inserisci dati di esempio
    CREATE TABLE mytable (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
    INSERT INTO mytable (name) VALUES ('John');

    -- Puoi aggiungere ulteriori comandi SQL qui se necessario

    -- Stampa un messaggio di conferma
    SELECT 'Database inizializzato con successo.';
END IF;
