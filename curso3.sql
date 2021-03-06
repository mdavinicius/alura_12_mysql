-- CRIANDO DB
CREATE DATABASE vendas_sucos;

USE vendas_sucos;

-- CRIANDO 3 TABELAS
CREATE TABLE CLIENTES (
	CPF VARCHAR(11) NOT NULL,
	NOME VARCHAR(100) NULL,
	ENDERECO VARCHAR(150) NULL,
	BAIRRO VARCHAR(50) NULL,
	CIDADE VARCHAR(50) NULL,
	ESTADO VARCHAR(50) NULL,
	CEP VARCHAR(8) NULL,
	DATA_NASCIMENTO DATE NULL,
	IDADE SMALLINT NULL,
	SEXO VARCHAR(1) NULL,
	LIMITE_CREDITO FLOAT NULL,
	VOLUME_COMPRA FLOAT NULL,
	PRIMEIRA_COMPRA BIT(1) NULL,
	PRIMARY KEY (CPF)
);

CREATE TABLE PRODUTOS (
	CODIGO VARCHAR(10) NOT NULL,
	DESCRITOR VARCHAR(100) NULL,
	SABOR VARCHAR(50) NULL,
	TAMANHO VARCHAR(50) NULL,
	EMBALAGEM VARCHAR(50) NULL,
	PRECO_LISTA FLOAT NULL,
	PRIMARY KEY (CODIGO)
);

CREATE TABLE VENDEDORES (
	MATRICULA VARCHAR(5) NOT NULL,
    NOME VARCHAR(100) NULL,
    BAIRRO VARCHAR(50) NULL,
    COMISSAO FLOAT NULL,
    DATA_ADIMISSAO DATE NULL,
    FERIAS BIT(1) NULL,
    PRIMARY KEY (MATRICULA)
);

ALTER TABLE vendedores RENAME COLUMN DATA_ADIMISSAO TO DATA_ADMISSAO;

-- CRIANDO TABELA E ADICIONANDO 2 FK
CREATE TABLE NOTAS (
	NUMERO VARCHAR(5) NOT NULL,
    DATA_VENDA DATE NULL,
    CPF VARCHAR(11) NOT NULL,
    MATRICULA VARCHAR(5) NOT NULL,
    IMPOSTO FLOAT NULL,
    PRIMARY KEY (NUMERO)
);

ALTER TABLE NOTAS ADD CONSTRAINT FK_CLIENTES
FOREIGN KEY (CPF) REFERENCES clientes (CPF);

ALTER TABLE NOTAS ADD CONSTRAINT FK_VENDEDORES
FOREIGN KEY (MATRICULA) REFERENCES vendedores (MATRICULA);

-- CRIANDO TABELA E ADICIONANDO +2 FK
CREATE TABLE ITENS_NOTAS (
NUMERO VARCHAR(5) NOT NULL,
CODIGO VARCHAR(10) NOT NULL,
QUANTIDADE INT,
PRECO FLOAT,
PRIMARY KEY (NUMERO, CODIGO)
);

ALTER TABLE itens_notas ADD CONSTRAINT FK_PRODUTOS
FOREIGN KEY (CODIGO) REFERENCES produtos (CODIGO);

ALTER TABLE itens_notas ADD CONSTRAINT FK_NOTAS
FOREIGN KEY (NUMERO) REFERENCES notas (NUMERO);

-- INSERINDO DADOS
INSERT INTO PRODUTOS (CODIGO, DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_LISTA)
VALUES ('1040107', 'Light - 350 ml - Melância', 'Melância', '350 ml', 'Lata', 4.56),
	   ('1040108', 'Light - 350 ml - Graviola', 'Graviola', '350 ml', 'Lata', 4.00),
	   ('1040109', 'Light - 350 ml - Açai', 'Açai', '350 ml', 'Lata', 5.60);

INSERT INTO clientes
VALUES ('1471156710', 'Érica Carvalho', 'R. Iriquitia', 'Jardins', 'São Paulo', 'SP', '80012212', 1990-09-01, 27, 'F', 170000, 24500, 0),
	   ('19290992743', 'Fernando Cavalcante', 'R. Dois de Fevereiro', 'Água Santa', 'Rio de Janeiro', 'RJ', '22000000', 2000-02-12, 18, 'M', 100000, 20000, 1),
       ('2600586709', 'César Teixeira', 'Rua Conde de Bonfim', 'Tijuca', 'Rio de Janeiro', 'RJ', '22020001', 2000-03-12, 18, 'M', 120000, 22000, 0);


-- Vamos alterar o preço de lista de um dos produtos
UPDATE produtos SET PRECO_DE_LISTA = 5 WHERE CODIGO = '100889'; 

-- Copiando os dados de uma tabela em outro DB para a tabela de 'produtos'
INSERT INTO produtos
SELECT CODIGO_DO_PRODUTO AS CODIGO, NOME_DO_PRODUTO AS DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_DE_LISTA AS PRECO_LISTA
FROM sucos_vendas.tabela_de_produtos
WHERE CODIGO_DO_PRODUTO NOT IN (SELECT CODIGO FROM PRODUTOS);

INSERT INTO clientes
SELECT CPF, NOME, ENDERECO_1 AS ENDERECO, BAIRRO, CIDADE, ESTADO, CEP, DATA_DE_NASCIMENTO AS DATA_NASCIMENTO, IDADE, SEXO, LIMITE_DE_CREDITO AS LIMITE_CREDITO, VOLUME_DE_COMPRA AS VOLUME_COMPRA, PRIMEIRA_COMPRA
FROM sucos_vendas.tabela_de_clientes
WHERE CPF NOT IN (SELECT CPF FROM clientes);

-- Alterando um item da tabela
UPDATE produtos SET PRECO_LISTA = 5 WHERE CODIGO = '1000889';

-- Alterando um item em lote
UPDATE produtos SET EMBALAGEM = 'PET', TAMANHO = '1 Litro', DESCRITOR = 'Sabor da Montanha - 1 Litro - Uva' WHERE CODIGO = '1000889';

-- Alterando um item da tabela usando o mesmo campo na formula
UPDATE produtos SET PRECO_LISTA = PRECO_LISTA * 1.10 WHERE SABOR = 'Maracujá';

-- Alterando dados da tabela com base em outra tabela
UPDATE vendedores A
INNER JOIN sucos_vendas.tabela_de_vendedores B
ON A.MATRICULA = substring(B.MATRICULA, 3, 3)
SET A.FERIAS = B.DE_FERIAS;

-- Inserindo mais dados na tabela
INSERT INTO PRODUTOS (CODIGO,DESCRITOR,SABOR,TAMANHO,EMBALAGEM,PRECO_LISTA)
     VALUES ('1001001','Sabor dos Alpes 700 ml - Manga','Manga','700 ml','Garrafa',7.50),
            ('1001000','Sabor dos Alpes 700 ml - Melão','Melão','700 ml','Garrafa',7.50),
            ('1001002','Sabor dos Alpes 700 ml - Graviola','Graviola','700 ml','Garrafa',7.50),
            ('1001003','Sabor dos Alpes 700 ml - Tangerina','Tangerina','700 ml','Garrafa',7.50),
			('1001004','Sabor dos Alpes 700 ml - Abacate','Abacate','700 ml','Garrafa',7.50),
			('1001005','Sabor dos Alpes 700 ml - Açai','Açai','700 ml','Garrafa',7.50),
			('1001006','Sabor dos Alpes 1 Litro - Manga','Manga','1 Litro','Garrafa',7.50),
			('1001007','Sabor dos Alpes 1 Litro - Melão','Melão','1 Litro','Garrafa',7.50),
			('1001008','Sabor dos Alpes 1 Litro - Graviola','Graviola','1 Litro','Garrafa',7.50),
			('1001009','Sabor dos Alpes 1 Litro - Tangerina','Tangerina','1 Litro','Garrafa',7.50),
			('1001010','Sabor dos Alpes 1 Litro - Abacate','Abacate','1 Litro','Garrafa',7.50),
			('1001011','Sabor dos Alpes 1 Litro - Açai','Açai','1 Litro','Garrafa',7.50);

-- Apagando dados
DELETE FROM produtos WHERE CODIGO = '1001000';

DELETE FROM PRODUTOS WHERE TAMANHO = '1 Litro' AND SUBSTRING(DESCRITOR,1,15) = 'Sabor dos Alpes';

DELETE FROM PRODUTOS WHERE CODIGO NOT IN (SELECT CODIGO_DO_PRODUTO FROM SUCOS_VENDAS.TABELA_DE_PRODUTOS);

-- Criando tabela alternativa e copiando dados
CREATE TABLE `produtos2` (
  `CODIGO` varchar(10) NOT NULL,
  `DESCRITOR` varchar(100) DEFAULT NULL,
  `SABOR` varchar(50) DEFAULT NULL,
  `TAMANHO` varchar(50) DEFAULT NULL,
  `EMBALAGEM` varchar(50) DEFAULT NULL,
  `PRECO_LISTA` float DEFAULT NULL,
  PRIMARY KEY (`CODIGO`)
) ;

INSERT INTO produtos2
SELECT * FROM produtos;

-- Fazendo update em lote
UPDATE produtos2 SET PRECO_LISTA = 8;

-- Apagando tudo
DELETE FROM produtos2;
DROP TABLE produtos2;

-- Usando transaction, rollback e commit
START TRANSACTION;
SELECT * FROM vendedores;

UPDATE vendedores SET COMISSAO = COMISSAO * 1.15;
SELECT * FROM vendedores;

ROLLBACK;
SELECT * FROM vendedores;

START TRANSACTION;
SELECT * FROM vendedores;

UPDATE vendedores SET COMISSAO = COMISSAO * 1.15;
SELECT * FROM vendedores;

COMMIT;
SELECT * FROM vendedores;

-- usando autoincremento
CREATE TABLE TAB_IDENTITY (
	ID INT AUTO_INCREMENT,
    DESCRITOR VARCHAR(20),
    PRIMARY KEY (ID)
);

SELECT * FROM TAB_IDENTITY;

INSERT INTO tab_identity (DESCRITOR) VALUES ('CLIENTE 1');
INSERT INTO tab_identity (DESCRITOR) VALUES ('CLIENTE 2');
INSERT INTO tab_identity (DESCRITOR) VALUES ('CLIENTE 3');
INSERT INTO tab_identity (DESCRITOR) VALUES ('CLIENTE 4');

SELECT * FROM tab_identity;

DELETE FROM tab_identity WHERE ID = 2;
INSERT INTO tab_identity (ID, DESCRITOR) VALUES (NULL, 'CLIENTE 5');
SELECT * FROM tab_identity;

INSERT INTO tab_identity (ID, DESCRITOR) VALUES (100, 'CLIENTE 5');
DELETE FROM tab_identity WHERE ID = 5;
INSERT INTO tab_identity (DESCRITOR) VALUES ('CLIENTE 6');
SELECT * FROM tab_identity;

-- Campos default
CREATE TABLE TAB_PADRAO (
	ID INT AUTO_INCREMENT,
	DESCRITOR VARCHAR(20),
	ENDERECO VARCHAR(100) NULL,
	CIDADE VARCHAR(50) DEFAULT 'Rio de Janeiro',
	DATA_CRIACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY(ID)
);

INSERT INTO TAB_PADRAO (DESCRITOR, ENDERECO, CIDADE, DATA_CRIACAO)
VALUES ('CLIENTE X', 'RUA PROJETADA A', 'SÃO PAULO', '2019-01-01');
SELECT * FROM TAB_PADRAO;

INSERT INTO TAB_PADRAO (DESCRITOR) VALUES ('CLIENTE Y');
SELECT * FROM TAB_PADRAO;

-- Trigger
CREATE TABLE TAB_FATURAMENTO (DATA_VENDA DATE NULL, TOTAL_VENDA FLOAT);

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_INSERT AFTER INSERT ON ITENS_NOTAS
FOR EACH ROW BEGIN
  DELETE FROM TAB_FATURAMENTO;
  INSERT INTO TAB_FATURAMENTO
  SELECT A.DATA_VENDA, SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA FROM
  NOTAS A INNER JOIN ITENS_NOTAS B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.DATA_VENDA;
END//

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0100', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0100', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0100', '1002334', 100, 10);

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0101', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0101', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0101', '1002334', 100, 10);

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0103', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0103', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0103', '1002334', 100, 10);

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0104', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0104', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0104', '1002334', 100, 10);

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0105', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0105', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0105', '1002334', 100, 10);

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0106', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0106', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0106', '1002334', 100, 10);

SELECT * FROM TAB_FATURAMENTO;

-- Trigger para quando houver registro apagado ou atualizado
DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_UPDATE AFTER UPDATE ON ITENS_NOTAS
FOR EACH ROW BEGIN
  DELETE FROM TAB_FATURAMENTO;
INSERT INTO TAB_FATURAMENTO
  SELECT A.DATA_VENDA, SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA FROM
  NOTAS A INNER JOIN ITENS_NOTAS B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.DATA_VENDA;
END//

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_DELETE AFTER DELETE ON ITENS_NOTAS
FOR EACH ROW BEGIN
  DELETE FROM TAB_FATURAMENTO;
INSERT INTO TAB_FATURAMENTO
  SELECT A.DATA_VENDA, SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA FROM
  NOTAS A INNER JOIN ITENS_NOTAS B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.DATA_VENDA;
END//

INSERT INTO NOTAS (NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES ('0107', '2019-05-08', '1471156710' , '235', 0.10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0107', '1000889', 100, 10);

INSERT INTO ITENS_NOTAS (NUMERO, CODIGO, QUANTIDADE, PRECO)
VALUES ('0107', '1002334', 100, 10);

SELECT * FROM TAB_FATURAMENTO;

DELETE FROM ITENS_NOTAS WHERE NUMERO = '0107' AND CODIGO = '1002334';
UPDATE ITENS_NOTAS SET QUANTIDADE = 400
WHERE NUMERO = '0100' AND CODIGO = '1002334';
SELECT * FROM TAB_FATURAMENTO;