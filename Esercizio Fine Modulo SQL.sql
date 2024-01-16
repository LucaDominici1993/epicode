-- Descrizione del Caso di Studio --

/*L'azienda di e-commerce vende prodotti elettronici online. 
  Il sistema deve tenere traccia dei clienti, degli ordini, dei prodotti, 
  delle categorie di prodotti e delle spedizioni.*/

-- ===========================================================================

-- Modello ER
-- Cliente: Contiene i dettagli dei clienti.
-- Prodotto: Dettagli dei prodotti elettronici.
-- Categoria: Le categorie dei prodotti (es: Smartphone, TV).
-- Ordine: Registra gli ordini effettuati dai clienti.
-- Spedizione: Dettagli sulla spedizione degli ordini.

-- =============================================================================

-- Relazioni:

-- Un cliente può effettuare più ordini.
-- Un ordine può contenere più prodotti.
-- Ogni prodotto appartiene a una categoria.
-- Ogni ordine ha una spedizione associata.

-- ============================================================================

-- Modello Logico

-- Cliente(\underline{ID_Cliente}, Nome, Email, Indirizzo)
-- Prodotto(\underline{ID_Prodotto}, Nome, Descrizione, Prezzo, ID_Categoria)
-- Categoria(\underline{ID_Categoria}, NomeCategoria)
-- Ordine(\underline{ID_Ordine}, DataOrdine, ID_Cliente, ID_Spedizione)
-- DettaglioOrdine(\underline{ID_Ordine, ID_Prodotto}, Quantità)
-- Spedizione(\underline{ID_Spedizione}, Modalità, DataSpedizione)

-- =============================================================================

-- Progettazione Fisica

-- DDL e DML per creare la base di dati e le tabelle:

CREATE DATABASE ECommerceDB;

USE ECommerceDB;

CREATE TABLE Cliente (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100),
    Indirizzo VARCHAR(200)
);

CREATE TABLE Categoria (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    NomeCategoria VARCHAR(100)
);

CREATE TABLE Prodotto (
    ID_Prodotto INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    Descrizione TEXT,
    Prezzo DECIMAL(10, 2),
    ID_Categoria INT,
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
);

CREATE TABLE Spedizione (
    ID_Spedizione INT AUTO_INCREMENT PRIMARY KEY,
    Modalità VARCHAR(100),
    DataSpedizione DATE
);

CREATE TABLE Ordine (
    ID_Ordine INT AUTO_INCREMENT PRIMARY KEY,
    DataOrdine DATE,
    ID_Cliente INT,
    ID_Spedizione INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Spedizione) REFERENCES Spedizione(ID_Spedizione)
);

CREATE TABLE DettaglioOrdine (
    ID_Ordine INT,
    ID_Prodotto INT,
    Quantità INT,
    PRIMARY KEY (ID_Ordine, ID_Prodotto),
    FOREIGN KEY (ID_Ordine) REFERENCES Ordine(ID_Ordine),
    FOREIGN KEY (ID_Prodotto) REFERENCES Prodotto(ID_Prodotto)
);

-- ===================================================================

-- Interrogazioni

/*Elenca tutti i prodotti di una certa categoria ordinati per prezzo.
Trova il totale delle vendite per ogni categoria.
Elenca i clienti che hanno effettuato più di 5 ordini.
Mostra la cronologia degli ordini di un particolare cliente.
Elenca gli ordini spediti in una certa data.
Trova il prodotto più venduto.
Elenca tutti gli ordini con i dettagli dei prodotti.
Calcola il valore medio degli ordini per cliente.
Trova i clienti che non hanno effettuato ordini negli ultimi 6 mesi.
Elenca i prodotti che non sono mai stati ordinati.*/

-- ======================================================================

-- Elenca tutti i prodotti di una certa categoria ordinati per prezzo:

SELECT p.Nome, p.Prezzo
FROM Prodotto p
JOIN Categoria c ON p.ID_Categoria = c.ID_Categoria
WHERE c.NomeCategoria = 'Smartphone'
ORDER BY p.Prezzo;

-- Trova il totale delle vendite per ogni categoria:

SELECT c.NomeCategoria, SUM(p.Prezzo * d.Quantità) AS TotaleVendite
FROM DettaglioOrdine d
JOIN Prodotto p ON d.ID_Prodotto = p.ID_Prodotto
JOIN Categoria c ON p.ID_Categoria = c.ID_Categoria
GROUP BY c.NomeCategoria;

-- Elenca i clienti che hanno effettuato più di 5 ordini:

SELECT cl.Nome, COUNT(o.ID_Ordine) AS NumeroOrdini
FROM Cliente cl
JOIN Ordine o ON cl.ID_Cliente = o.ID_Cliente
GROUP BY cl.Nome
HAVING COUNT(o.ID_Ordine) > 5;

-- Mostra la cronologia degli ordini di un particolare cliente:

SELECT o.ID_Ordine, o.DataOrdine
FROM Ordine o
WHERE o.ID_Cliente = 1  -- Assumendo 1 come ID del cliente
ORDER BY o.DataOrdine;

-- Elenca gli ordini spediti in una certa data:

SELECT o.ID_Ordine
FROM Ordine o
JOIN Spedizione s ON o.ID_Spedizione = s.ID_Spedizione
WHERE s.DataSpedizione = '2024-01-01';

-- Trova il prodotto più venduto:

SELECT p.Nome, SUM(d.Quantità) AS QuantitàVenduta
FROM DettaglioOrdine d
JOIN Prodotto p ON d.ID_Prodotto = p.ID_Prodotto
GROUP BY p.Nome
ORDER BY SUM(d.Quantità) DESC
LIMIT 1;

-- Elenca tutti gli ordini con i dettagli dei prodotti:

SELECT o.ID_Ordine, p.Nome, d.Quantità
FROM Ordine o
JOIN DettaglioOrdine d ON o.ID_Ordine = d.ID_Ordine
JOIN Prodotto p ON d.ID_Prodotto = p.ID_Prodotto;

-- Calcola il valore medio degli ordini per cliente:

SELECT cl.Nome, AVG(TotaleOrdine) AS ValoreMedioOrdine
FROM Cliente cl
JOIN Ordine o ON cl.ID_Cliente = o.ID_Cliente
JOIN (
  SELECT ID_Ordine, SUM(p.Prezzo * d.Quantità) AS TotaleOrdine
  FROM DettaglioOrdine d
  JOIN Prodotto p ON d.ID_Prodotto = p.ID_Prodotto
  GROUP BY ID_Ordine
) AS TotOrd ON o.ID_Ordine = TotOrd.ID_Ordine
GROUP BY cl.Nome;

-- Trova i clienti che non hanno effettuato ordini negli ultimi 6 mesi:

SELECT cl.Nome
FROM Cliente cl
LEFT JOIN Ordine o ON cl.ID_Cliente = o.ID_Cliente AND o.DataOrdine > DATE_SUB(NOW(), INTERVAL 6 MONTH)
WHERE o.ID_Ordine IS NULL;

-- Elenca i prodotti che non sono mai stati ordinati:

SELECT p.Nome
FROM Prodotto p
LEFT JOIN DettaglioOrdine d ON p.ID_Prodotto = d.ID_Prodotto
WHERE d.ID_Ordine IS NULL;






