
-- BEGINING OF THE TASK

/*   
The database "sequra" was created using the syntax;
CREATE database sequra;
 */

-- Initialize the use of the database 'sequra'
USE sequra;

-- Creating a table called 'fact_credit_d'.

CREATE TABLE fact_credit_d (
    credit_id INT NOT NULL,
    record_date DATE NOT NULL,
    ext_fin_id INT,
    principal INT,
    interest INT,
    days_unbalance INT,
    CONSTRAINT fact_credit_d_PK PRIMARY KEY (credit_id , record_date),
    FOREIGN KEY (ext_fin_id)
        REFERENCES dim_ext_fin (ext_fin_id)
        ON DELETE CASCADE
);

DESC fact_credit_d;


-- Inserting records into the table 'fact_credit_d'.

INSERT INTO fact_credit_d VALUES (15, '2022-01-05', 1, 100, 3, 0),
(15, '2022-01-06', 1, 100, 3, 0),
(16, '2022-01-06', 1, 80, 2, 1),
(15, '2022-01-07', 1, 100, 3, 0),
(16, '2022-01-07', 1, 80, 2, 1);
INSERT INTO fact_credit_d(credit_id, record_date, ext_fin_id, principal, interest) 
VALUES(17, '2022-01-07', 2, 300, 3);
INSERT INTO fact_credit_d VALUES (18, '2022-01-07', 2, 50, 3, 0),
(15, '2022-01-08', 1, 100, 3, 0),
(16, '2022-01-08', 1, 80, 2, 1);
INSERT INTO fact_credit_d(credit_id, record_date, ext_fin_id, principal, interest) 
VALUES(17, '2022-01-08', 2, 300, 3);
INSERT INTO fact_credit_d VALUES (18, '2022-01-08', 2, 50, 3, 0),
(19, '2022-01-08', 2, 65, 3, 0);

-- Viewing the table and its structure.

SELECT 
    *
FROM
    fact_credit_d;

-- Creating a another table called 'fact_economic_event_d'

CREATE TABLE fact_economic_event_d (
    credit_id INT NOT NULL,
    economic_event INT NOT NULL,
    record_date DATE NOT NULL,
    type VARCHAR(25),
    amount INT,
    CONSTRAINT fact_economic_event_d_pk PRIMARY KEY (credit_id , economic_event , record_date)
);


-- Inserting records into the table 'fact_economic_event_d'.

INSERT INTO fact_economic_event_d VALUES (15, 1, '2022-01-05', 'installment', 5),
(15, 2, '2022-01-05', 'chargeback', 10),
(17, 3, '2022-01-07', 'chargeback', 10),
(18, 4, '2022-01-08', 'payment', 50),
(18, 5, '2022-01-10', 'chargeback', 50),
(19, 6, '2022-01-10', 'payment', 30);

DESC fact_economic_event_d;-- Viewing the structure of the table

SELECT 
    *
FROM
    fact_economic_event_d;-- Viewing the entire table

CREATE TABLE dim_ext_fin (
    ext_fin_id INT PRIMARY KEY,
    name VARCHAR(30),
    start_date DATE
);

DESC dim_ext_fin; -- Viewing the structure of the table

INSERT INTO dim_ext_fin VALUES (1, 'Inv1', '2020-04-18'), -- Inserting records into the table
(2, 'Fund2', '2021-10-11');

SELECT 
    *
FROM
    dim_ext_fin;-- Viewing the entire table


SELECT 
    fact_credit_d.credit_id,
    dim_ext_fin.name,
    YEAR(dim_ext_fin.start_date) AS Year,
    fact_economic_event_d.economic_event,
    fact_economic_event_d.record_date,
    fact_economic_event_d.type,
    fact_economic_event_d.amount
FROM
    dim_ext_fin
        JOIN
    fact_credit_d ON dim_ext_fin.ext_fin_id = fact_credit_d.ext_fin_id
        JOIN
    fact_economic_event_d ON fact_credit_d.credit_id = fact_economic_event_d.credit_id
WHERE
    type = 'chargeback' AND name = 'FUND2'
        AND start_date = '2021-10-11';

-- End of first task



CREATE TABLE dim_merchant (
    merchant_id INT PRIMARY KEY,
    name VARCHAR(30),
    sector VARCHAR(30),
    live_on DATE,
    api_status VARCHAR(30),
    updated_at DATE
);

-- INSERTING RECORDS INTO THE TABLE

INSERT INTO dim_merchant VALUES (1, 'trajesamedida', 'retail', '2020-07-25', 'allowed', '2020-07-25'),
(25, 'decoracionMark', 'home', '2018-06-08', 'allowed', '2021-02-17'),
(4, 'superdiario', 'food', '2018-11-05', 'allowed', '2021-02-17');
INSERT INTO dim_merchant (merchant_id, name, sector, api_status, updated_at) 
VALUES(10, 'ropainterior', 'retail', 'allowed', '2021-02-17');
INSERT INTO dim_merchant VALUES (11, 'proteinasaltorendimiento', 'health', '2018-03-15', 'denied', '2021-02-17'),
(12, 'gimnasioMoreno', 'health', '2019-08-17', 'allowed', '2021-02-17'),
(6, 'cuerpoyvida', 'health', '2021-01-14', 'supervised', '2021-02-20'),
(2, 'dietasana', 'health', '2021-01-15', 'allowed', '2021-02-20'),
(3, 'ropadesalon', 'retail', '2019-01-02', 'supervised', '2021-02-20');
INSERT INTO dim_merchant (merchant_id, name, sector, api_status, updated_at) 
VALUES(13, 'menajecocina', 'home', 'allowed', '2021-02-06');

-- View the table and structure of table 'dim_merchant'.
DESC dim_merchant;
SELECT 
    *
FROM
    dim_merchant;


SELECT 
    YEAR(updated_at) AS Year,
    COUNT(updated_at) AS Numb_merchants_Current_Year,
    COUNT(live_on) AS Numb_merchants_Prev_Year,
    ((COUNT(updated_at) - COUNT(live_on)) / COUNT(live_on) * 100) AS Percentage_Growth_Rate
FROM
    dim_merchant
WHERE
    api_status = 'allowed'
ORDER BY Year;


SELECT 
    merchant_id,
    YEAR(updated_at) AS Year,
    updated_at AS Numb_merchants_Current_Year,
    live_on AS Numb_merchants_Prev_Year,
    (((updated_at - live_on) / live_on) * 100) AS growth_rate
FROM
    dim_merchant
WHERE
    api_status = 'allowed'
ORDER BY Year;

-- End of Second Task
