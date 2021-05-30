-- Criando Stored Procedures e Variáveis
DELIMITER $$
CREATE PROCEDURE Ex1 ()
BEGIN
	DECLARE Cliente VARCHAR(10);
	DECLARE Idade INT;
	DECLARE DataNascimento DATE;
	DECLARE Custo FLOAT;
    
    SET Cliente = 'João';
    SET Idade = 30;
    SET DataNascimento = 20210523;
    SET Custo = 10.23;
	
    SELECT Cliente;
    SELECT Idade;
    SELECT DataNascimento;
    SELECT Custo;
END $$
DELIMITER ;

CALL Ex1;

-- Criando uma SP que atualiza a idade dos Clientes
SELECT * FROM tabela_de_clientes;

DELIMITER $$
CREATE PROCEDURE AtualizaIdade()
BEGIN
    UPDATE tabela_de_clientes SET IDADE = TIMESTAMPDIFF(YEAR, data_de_nascimento, CURDATE());
END $$
DELIMITER ;

CALL AtualizaIdade();
SELECT * FROM tabela_de_clientes;

-- Crie uma Stored procedure para reajustar o % de comissão dos vendedores. Inclua como parâmetro da SP o %, expresso em valor (Ex: 0,90).
DELIMITER $$
CREATE PROCEDURE Reajuste_Comissao (Comissao FLOAT)
BEGIN
	UPDATE tabela_de_vendedores SET PERCENTUAL_COMISSAO = PERCENTUAL_COMISSAO * (1 + Comissao);
END $$
DELIMITER ;

-- Crie uma variável chamada NUMNOTAS e atribua a ela o número de notas fiscais do dia 01/01/2017
-- Mostre na saída do script o valor da variável. (Chame esta Stored Procedure de Quantidade_Notas).

-- PRIMEIRO FAZER UM SELECT QUE TENHA ESSA INFO
SELECT COUNT(*) FROM notas_fiscais WHERE DATA_VENDA = '2017-01-01';

-- AGORA CRIAR A SP
DELIMITER $$
CREATE PROCEDURE QntdNotas (DataNf date)
BEGIN
	DECLARE NUMNOTAS INT;
    SELECT COUNT(*) INTO NUMNOTAS FROM notas_fiscais WHERE DATA_VENDA = DataNf;
    SELECT NUMNOTAS;
END $$
DELIMITER ;

CALL QntdNotas('2017-01-01');

-- Crie uma Stored Procedure que, baseado em uma data, contamos o número de notas fiscais.
-- Se houverem mais que 70 notas exibimos a mensagem: ‘Muita nota’. Senão, ‘Pouca nota’.
-- Também exibir o número de notas. Chame esta Stored Procedure de Testa_Numero_Notas.
-- A data a ser usada para testar a nota será um parâmetro da Stored Procedure.

DELIMITER $$
CREATE PROCEDURE Testa_Numero_Notas (vData DATE)
BEGIN
	DECLARE vQntd INT;
    DECLARE vInfo VARCHAR(40);
	SELECT COUNT(*) INTO vQntd FROM notas_fiscais WHERE DATA_VENDA = vDATA;
    IF vQntd >= 70
		THEN SET vInfo = 'Muita nota';
		ELSE SET vInfo = 'Pouca nota';
    END IF;
    SELECT vQntd, vInfo;  
END $$
DELIMITER ;

CALL Testa_Numero_Notas ('20150101');

/* Desafio! Veja a consulta abaixo:
	SELECT SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA FROM 
	NOTAS_FISCAIS A INNER JOIN ITENS_NOTAS_FISCAIS B
	ON A.NUMERO = B.NUMERO
	WHERE A.DATA_VENDA = '20170301'
Construa uma Stored Procedure chamada Comparativo_Vendas que compara as vendas em duas datas (Estas duas datas serão parâmetros da SP).
Se a variação percentual destas vendas for maior que 10% a resposta deve ser ‘Verde’.
Se for entre -10% e 10% deve retornar ‘Amarela'. Se o retorno form menor que -10% deve retornar ‘Vermelho’. */

DELIMITER $$
CREATE PROCEDURE Comparativo_Vendas (vData1 DATE, vDAta2 DATE)
BEGIN
	DECLARE vR1 FLOAT;
	DECLARE vR2 FLOAT;
    DECLARE vRFINAL FLOAT;
    DECLARE vVARIACAO VARCHAR(10);
		SELECT SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA INTO vR1 FROM 
		NOTAS_FISCAIS A INNER JOIN ITENS_NOTAS_FISCAIS B
		ON A.NUMERO = B.NUMERO
		WHERE A.DATA_VENDA = vData1;		
        
        SELECT SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA INTO vR2 FROM 
		NOTAS_FISCAIS A INNER JOIN ITENS_NOTAS_FISCAIS B
		ON A.NUMERO = B.NUMERO
		WHERE A.DATA_VENDA = vData2;
        
	SET vRFINAL = ROUND(100 - ((vR1/vR2) * 100), 2);
    
    IF vRFINAL > 10.0
		THEN SET vVARIACAO = 'VERDE';
	ELSEIF vRFINAL <= 10.0 AND vRFINAL >= -10.0
		THEN SET vVARIACAO = 'AMARELO';
	ELSE SET vVARIACAO = 'VERMELHO';
    END IF;
    SELECT vRFINAL, vVARIACAO;
END $$
DELIMITER ;

CALL Comparativo_Vendas ('20150101', '20170301');

-- Implemente a Stored Procedure do exercício anterior, agora usando CASE CONDICIONAL. Chame de Comparativo_Vendas_Case_Cond.

DELIMITER $$
CREATE PROCEDURE Comparativo_Vendas_Case_Cond (vData1 DATE, vDAta2 DATE)
BEGIN
	DECLARE vR1 FLOAT;
	DECLARE vR2 FLOAT;
    DECLARE vRFINAL FLOAT;
    DECLARE vVARIACAO VARCHAR(10);
		SELECT SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA INTO vR1 FROM 
		NOTAS_FISCAIS A INNER JOIN ITENS_NOTAS_FISCAIS B
		ON A.NUMERO = B.NUMERO
		WHERE A.DATA_VENDA = vData1;		
        
        SELECT SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA INTO vR2 FROM 
		NOTAS_FISCAIS A INNER JOIN ITENS_NOTAS_FISCAIS B
		ON A.NUMERO = B.NUMERO
		WHERE A.DATA_VENDA = vData2;
        
	SET vRFINAL = ROUND(100 - ((vR1/vR2) * 100), 2);
    
    CASE
    WHEN vRFINAL > 10 THEN SET vVARIACAO = 'VERDE';
    WHEN vRFINAL <= 10 AND vRFINAL >= -10 THEN SET vVARIACAO = 'AMARELO';
	WHEN vRFINAL < -10 THEN SET vVARIACAO = 'VERMELHO';
    END CASE;
    SELECT vRFINAL, vVARIACAO;
END $$
DELIMITER ;

CALL Comparativo_Vendas_Case_Cond ('20150101', '20170301');

/*Sabendo que a função abaixo soma de 1 dia uma data:
SELECT ADDDATE(DATA_VENDA, INTERVAL 1 DAY);
Faça uma Stored Procedure que,a partir do dia 01/01/2017, iremos contar o número de notas fiscais até o dia 10/01/2017.
Devemos imprimir a data e o número de notas fiscais dia a dia. Chame esta Stored Procedure de Soma_Dias_Notas. */

DELIMITER $$
CREATE PROCEDURE Soma_Dias_Notas (vDATA1 DATE, vDATA2 DATE)
BEGIN
	DECLARE vLOOP INT;
    DECLARE vQNTD INT;
    WHILE vDATA1 <= vDATA2
    DO
		SELECT COUNT(*) INTO vQNTD FROM notas_fiscais WHERE DATA_VENDA = vDATA1;
		SET vDATA1 = ADDDATE(vDATA1, INTERVAL 1 DAY);
		SELECT vDATA1, vQNTD;
    END WHILE;
END $$
DELIMITER ;

CALL Soma_Dias_Notas ('20170101', '20170110');

/* Veja a Stored Procedure abaixo:
	CREATE PROCEDURE `sp_numero_notas` ()
	BEGIN
		DECLARE NUMNOTAS INT;
		SELECT COUNT(*) INTO NUMNOTAS FROM notas_fiscais WHERE DATA_VENDA = '20170101';
		SELECT NUMNOTAS;
	END
Transforme esta SP em uma função onde passamos como parâmetro da data e retornamos o número de notas.
Chame esta função de NumeroNotas. Após a criação da função teste seu uso com um SELECT. */

SET GLOBAL log_bin_trust_function_creators=1 -- para liberar o workbench a criar funções

DELIMITER $$
CREATE FUNCTION f_NumeroNotas (vData DATE)
RETURNS INTEGER
BEGIN
	DECLARE vNotas INT;
	SELECT COUNT(*) INTO vNotas FROM notas_fiscais WHERE DATA_VENDA = vData;
	RETURN vNotas;
END $$
DELIMITER ;

SELECT f_NumeroNotas ("20150101");

/*Crie uma tabela chamada TABELA_ALEATORIOS. O comando para cria-la é mostrado abaixo:
CREATE TABLE TABELA_ALEATORIOS(NUMERO INT);
Faça uma SP (Chame-a de Tabela_Numeros) que use um loop para gravar nesta tabela 100 números aleatórios entre 0 e 1000. Depois liste numa consulta esta tabela.
(Use a função f_numero_aleatorio criado no vídeo desta aula). */
DELIMITER $$
CREATE FUNCTION f_numero_aleatorio (Min INT, Max INT)
RETURNS INT
BEGIN
	DECLARE vRetorno INT;
    SELECT FLOOR(RAND() * (Max - Min + 1) + Min) INTO vRetorno;
RETURN vRetorno;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS Tabela_Numeros;
DELIMITER $$
CREATE PROCEDURE Tabela_Numeros ()
BEGIN
    DECLARE vContador INT;
    SET vContador = 1;
	DROP TABLE IF EXISTS TABELA_ALEATORIOS;
	CREATE TABLE TABELA_ALEATORIOS(NUMERO INT);
    WHILE vContador <= 100
    DO
		INSERT INTO TABELA_ALEATORIOS (NUMERO)
        VALUES (f_numero_aleatorio(1, 1000));
        SET vContador = vContador + 1;
    END WHILE;
    SELECT NUMERO FROM TABELA_ALEATORIOS
		ORDER BY NUMERO ASC;
END $$
DELIMITER ;

CALL Tabela_Numeros();

-- No vídeo desta aula criamos uma função para obter o cliente através da função de número aleatório. 
-- Neste exercício crie outra função para obter o produto também usando a função aleatório.
DELIMITER $$
CREATE FUNCTION f_produto_aleatorio()
RETURNS VARCHAR(10)
BEGIN
	DECLARE vRetorno VARCHAR(10);
    DECLARE num_max INT;
    DECLARE num_randon INT;
    SELECT COUNT(*) INTO num_max FROM tabela_de_produtos;
    SET num_randon = f_numero_aleatorio(1, num_max);
	SET num_randon = num_randon -1;
	SELECT CODIGO_DO_PRODUTO INTO vRetorno FROM tabela_de_produtos LIMIT num_randon, 1;
RETURN vRetorno;
END $$
DELIMITER ;

SELECT f_produto_aleatorio();

-- Crie outra função para obter o vendedor também usando a função aleatório.
DELIMITER $$
CREATE FUNCTION f_vendedor_aleatorio()
RETURNS VARCHAR(5)
BEGIN
	DECLARE vRetorno VARCHAR(5);
    DECLARE num_max INT;
    DECLARE num_randon INT;
    SELECT COUNT(*) INTO num_max FROM tabela_de_vendedores;
    SET num_randon = f_numero_aleatorio(1, num_max);
	SET num_randon = num_randon -1;
	SELECT MATRICULA INTO vRetorno FROM tabela_de_vendedores LIMIT num_randon, 1;
RETURN vRetorno;
END $$
DELIMITER ;

SELECT f_vendedor_aleatorio();

-- Crie outra função para obter o cliente aleatório.
DELIMITER $$
CREATE FUNCTION f_cliente_aleatorio()
RETURNS VARCHAR(11)
BEGIN
	DECLARE vRetorno VARCHAR(11);
    DECLARE num_max INT;
    DECLARE num_randon INT;
    SELECT COUNT(*) INTO num_max FROM tabela_de_clientes;
    SET num_randon = f_numero_aleatorio(1, num_max);
	SET num_randon = num_randon -1;
	SELECT CPF INTO vRetorno FROM tabela_de_clientes LIMIT num_randon, 1;
RETURN vRetorno;
END $$
DELIMITER ;

SELECT f_cliente_aleatorio();

-- Criando uma Procedure para incluir uma venda aleatória (tant em notas_fiscais, como em itens_notas_fiscais)
DROP procedure IF EXISTS p_inserir_venda;
DELIMITER $$
USE sucos_vendas$$
CREATE DEFINER=root@localhost PROCEDURE p_inserir_venda(vData DATE, max_itens INT, max_quantidade INT)
BEGIN
	DECLARE vCliente VARCHAR(11);
	DECLARE vProduto VARCHAR(10);
	DECLARE vVendedor VARCHAR(5);
	DECLARE vQuantidade INT;
	DECLARE vPreco FLOAT;
	DECLARE vItens INT;
	DECLARE vNumeroNota INT;
	DECLARE vContador INT DEFAULT 1;
	DECLARE vNumItensNota INT;
	SELECT MAX(numero) + 1 INTO vNumeroNota from notas_fiscais;
	SET vCliente = f_cliente_aleatorio();
	SET vVendedor = f_vendedor_aleatorio();
	INSERT INTO notas_fiscais (CPF, MATRICULA, DATA_VENDA, NUMERO, IMPOSTO)
	VALUES (vCliente, vVendedor, vData, vNumeroNota, 0.18);
	SET vItens = f_numero_aleatorio(1, max_itens);
	WHILE vContador <= vItens
	DO
	   SET vProduto = f_produto_aleatorio();
	   SELECT COUNT(*) INTO vNumItensNota FROM itens_notas_fiscais
	   WHERE NUMERO = vNumeroNota AND CODIGO_DO_PRODUTO = vProduto;
	   IF vNumItensNota = 0 THEN
		  SET vQuantidade = f_numero_aleatorio(10, max_quantidade);
		  SELECT PRECO_DE_LISTA INTO vPreco FROM tabela_de_produtos
		  WHERE CODIGO_DO_PRODUTO = vProduto;
		  INSERT INTO itens_notas_fiscais (NUMERO, CODIGO_DO_PRODUTO,
		  QUANTIDADE, PRECO) VALUES (vNumeroNota, vProduto, vQuantidade, vPreco);
	   END IF;
	   SET vContador = vContador + 1;
	END WHILE;
END$$
DELIMITER ;

Call p_inserir_venda('20200528', 3, 100);
SELECT f_NumeroNotas('20200528');

Call p_inserir_venda('20200528', 10, 100);
Call p_inserir_venda('20200528', 10, 100);
SELECT f_NumeroNotas('20200528');

SELECT * FROM notas_fiscais WHERE DATA_VENDA = '20200528';
SELECT * FROM itens_notas_fiscais WHERE NUMERO IN (87977, 87978, 87979);

-- Ajustando o codigo das Triggers para ser uma SP e facilitar a manutençãOPTIMIZE
DROP procedure IF EXISTS p_calculo_faturamento;
DELIMITER $$
CREATE PROCEDURE p_calculo_faturamento()
BEGIN
  DELETE FROM TAB_FATURAMENTO;
  INSERT INTO TAB_FATURAMENTO
  SELECT A.DATA_VENDA, SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA
	FROM NOTAS_FISCAIS A
    INNER JOIN ITENS_NOTAS_FISCAIS B
	ON A.NUMERO = B.NUMERO
	GROUP BY A.DATA_VENDA;
END$$
DELIMITER ;

CREATE TABLE TAB_FATURAMENTO
(DATA_VENDA DATE NULL, TOTAL_VENDA FLOAT);

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_INSERT AFTER INSERT ON ITENS_NOTAS_FISCAIS
FOR EACH ROW BEGIN
  Call p_calculo_faturamento;
END//

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_UPDATE AFTER UPDATE ON ITENS_NOTAS_FISCAIS
FOR EACH ROW BEGIN
  Call p_calculo_faturamento;
END//

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_DELETE AFTER DELETE ON ITENS_NOTAS_FISCAIS
FOR EACH ROW BEGIN
  Call p_calculo_faturamento;
END//