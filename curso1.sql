-- Criando BD
CREATE DATABASE sucos;

-- Criando tabela
CREATE TABLE tbcliente (
	CPF VARCHAR(11),
    NOME VARCHAR(100),
    ENDERECO1 VARCHAR(150),
    ENDERECO2 VARCHAR(150),
    BAIRRO VARCHAR(50),
    CIDADE VARCHAR(50),
    ESTADO VARCHAR(50),
    CEP VARCHAR(8),
    IDADE SMALLINT,
    SEXO VARCHAR(1),
    LIMITE_CREDITO FLOAT,
    VOLUME_COMPRA FLOAT,
    PRIMEIRA_COMPRA BIT(1)
);

-- Criando tabela
CREATE TABLE TABELA_DE_VENDEDORES (
	MATRICULA VARCHAR(5),
	NOME VARCHAR(100),
	PERCENTUAL_COMISSAO FLOAT
);

-- Inserindo dados na tabela
INSERT INTO tabela_de_vendedores (
	MATRICULA,
    NOME,
    PERCENTUAL_COMISSAO) VALUES (
    '00233', 'João Geraldo da Fonseca', 0.10);

-- Inserindo múltiplos dados na tabela
INSERT INTO tabela_de_vendedores(
	MATRICULA, NOME, PERCENTUAL_COMISSAO) VALUES (
    '00235', 'Márcio Almeida Silva', 0.08),
    ('00236', 'Cláudia Morais', 0.08);

-- Atualizando dados já inseridos
UPDATE tabela_de_vendedores
SET PERCENTUAL_COMISSAO = 0.11
WHERE MATRICULA = '00236';

UPDATE tabela_de_vendedores
SET NOME = 'José Geraldo da Fonseca Junior'
WHERE MATRICULA = '00233';

-- Excluindo dados da tabela
DELETE FROM tabela_de_vendedores
WHERE MATRICULA = '00233';

-- Criando uma PK
ALTER TABLE tabela_de_vendedores ADD PRIMARY KEY (MATRICULA);

-- Inserindo uma coluna nova
ALTER TABLE tabela_de_vendedores ADD COLUMN (DATA_ADMISSAO DATE);
ALTER TABLE tabela_de_vendedores ADD COLUMN (DE_FERIAS BIT);

UPDATE tabela_de_vendedores
SET DATA_ADMISSAO = '2014-08-15', DE_FERIAS = 0
WHERE MATRICULA = '00235';

UPDATE tabela_de_vendedores
SET DATA_ADMISSAO = '2013-09-17', DE_FERIAS = 1
WHERE MATRICULA = '00236';

INSERT INTO tabela_de_vendedores (
	MATRICULA, NOME, PERCENTUAL_COMISSAO, DATA_ADMISSAO, DE_FERIAS) VALUES (
    '00237', 'Roberta Martins', 0.11, '2017-03-18', 1);
    
INSERT INTO tabela_de_vendedores (
	MATRICULA, NOME, PERCENTUAL_COMISSAO, DATA_ADMISSAO, DE_FERIAS) VALUES (
    '00238', 'Péricles Alves', 0.11, '2016-08-21', 0);

SELECT * FROM tabela_de_vendedores;

-- adicionando itens na tabela de produtos
INSERT INTO tbproduto (
PRODUTO,  NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES (
'1040107', 'Light - 350 ml - Melância', 'Lata', '350 ml', 'Melância', 4.56),
('1037797', 'Clean - 2 Litros - Laranja', 'PET', '2 Litros', 'Laranja', 16.01),
('1000889', 'Sabor da Montanha - 700 ml - Uva', 'Garrafa', '700 ml', 'Uva', 6.31),
('1004327', 'Videira do Campo - 1,5 Litros - Melância', 'PET', '1,5 Litros', 'Melância', 19.51);

INSERT INTO tbproduto (
PRODUTO,  NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES (
'544931', 'Frescor do Verão - 350 ml - Limão', 'Lata', '350 ml','Limão',2.46);

INSERT INTO tbproduto (
PRODUTO,  NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES (
'1078680', 'Frescor do Verão - 470 ml - Manga', 'Garrafa', '470 ml','Manga',5.18);

-- deletando uma linha
DELETE FROM tbproduto WHERE PRODUTO = '1078680';

-- adicionando PK
ALTER TABLE tbproduto ADD PRIMARY KEY (PRODUTO);

INSERT INTO tbproduto (
PRODUTO,  NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES (
'1078680', 'Frescor do Verão - 470 ml - Manga', 'Lata', '470 ml','Manga',5.18);

UPDATE tbproduto SET EMBALAGEM = 'Garrafa'
WHERE PRODUTO = '1078680';

SELECT * FROM tbproduto;

-- adicionando PK em Clientes
ALTER TABLE tbcliente ADD PRIMARY KEY (CPF);

-- adicionando Coluna
ALTER TABLE tbcliente ADD COLUMN (DATA_NASCIMENTO DATE);

-- inserindo dados
INSERT INTO tbcliente (
CPF, NOME, ENDERECO1, ENDERECO2, BAIRRO, CIDADE, ESTADO, CEP, IDADE, SEXO, LIMITE_CREDITO, VOLUME_COMPRA, PRIMEIRA_COMPRA, DATA_NASCIMENTO) VALUES (
'00388934505','João da Silva','Rua projetada A número 10','', 'VILA ROMAN', 'CARATINGA', 'AMAZONAS','2222222',30,'M', 10000.00, 2000, 0, '1989-10-05');


