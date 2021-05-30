-- usando LIKE % para trazer os clientes que possuem o ultimo nome Mattos
SELECT * FROM tabela_de_clientes WHERE NOME LIKE '%MATTOS';

-- usando DISTINCT para trazer quais bairros do RJ possuem clientes
SELECT DISTINCT BAIRRO, CIDADE FROM tabela_de_clientes
WHERE ESTADO = 'RJ';

-- usando LIMIT para trazer as 10 primeiras vendas do dia 01/01/2017
SELECT * FROM notas_fiscais
WHERE DATA_VENDA = '2017-01-01'
LIMIT 10;

-- usando o ORDER BY para trazer qual (ou quais) foi (foram) a(s) maior(es) venda(s) do produto “Linha Refrescante - 1 Litro - Morango/Limão”, em quantidade
SELECT * FROM tabela_de_produtos
WHERE NOME_DO_PRODUTO = 'Linha Refrescante - 1 Litro - Morango/Limão';

SELECT * FROM itens_notas_fiscais
WHERE CODIGO_DO_PRODUTO = '1101035'
ORDER BY QUANTIDADE DESC;

-- com base no exercício anterior, quantos itens de venda existem com a maior quantidade do produto 1101035?
SELECT COUNT(CODIGO_DO_PRODUTO) FROM itens_notas_fiscais
WHERE CODIGO_DO_PRODUTO = '1101035' AND QUANTIDADE = 99
ORDER BY QUANTIDADE DESC;

-- usando o HAVING para trazer quais foram os clientes que fizeram mais de 2000 compras em 2016
SELECT CPF, COUNT(CPF) FROM notas_fiscais
WHERE YEAR(DATA_VENDA) = '2016'
GROUP BY CPF
HAVING COUNT(CPF) > 2000;

-- usando o CASE para trazer o ano de nascimento dos clientes e classifique-os como:
-- Nascidos antes de 1990 são velhos, nascidos entre 1990 e 1995 são jovens e nascidos depois de 1995 são crianças. 
-- Liste o nome do cliente e esta classificação.
SELECT NOME, DATA_DE_NASCIMENTO,
CASE
	WHEN YEAR(DATA_DE_NASCIMENTO) < '1990' THEN 'VELHO'
    WHEN YEAR(DATA_DE_NASCIMENTO) <= '1995' AND YEAR(DATA_DE_NASCIMENTO) >= '1990' THEN 'JOVEM'
    ELSE 'CRIANÇA'
END AS 'TIPO'
FROM tabela_de_clientes;

-- Obtenha o faturamento anual da empresa. Leve em consideração que o valor financeiro das vendas consiste em multiplicar a quantidade pelo preço.
-- Fazer o Join só pra ver os campos
SELECT *
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
WHERE NF.NUMERO = INF.NUMERO;

-- Selecionar apenas os campos que preciso e fazer o cálculo
SELECT YEAR(DATA_VENDA) as ANO, ROUND(SUM(INF.QUANTIDADE * INF.PRECO), 2) as FATURAMENTO
FROM notas_fiscais NF
INNER JOIN itens_notas_fiscais INF
WHERE NF.NUMERO = INF.NUMERO
GROUP BY YEAR(DATA_VENDA);

-- Faça uma consulta listando o nome do cliente e o endereço completo (Com rua, bairro, cidade e estado).
SELECT NOME, concat(ENDERECO_1, ', ', BAIRRO, ', ', CIDADE, ' - ', ESTADO) AS ENDERECO FROM tabela_de_clientes;

-- Crie uma consulta que mostre o nome e a idade atual dos clientes.
SELECT NOME, DATA_DE_NASCIMENTO, ROUND(DATEDIFF(CURDATE(), DATA_DE_NASCIMENTO) / 365) AS DATA_ATUAL FROM tabela_de_clientes;

SELECT NOME, TIMESTAMPDIFF (YEAR, DATA_DE_NASCIMENTO, CURDATE()) AS    IDADE
FROM  tabela_de_clientes;

-- Na tabela de notas fiscais temos o valor do imposto. Já na tabela de itens temos a quantidade e o faturamento.
-- Calcule o valor do imposto pago no ano de 2016 arredondando para o menor inteiro.
SELECT YEAR(NF.DATA_VENDA), ROUND(SUM(NF.IMPOSTO * INF.FATURAMENTO), 2) AS IMPOSTO_PAGO FROM notas_fiscais NF
INNER JOIN
(SELECT NUMERO, ROUND(QUANTIDADE * PRECO, 2) AS FATURAMENTO FROM itens_notas_fiscais) AS INF
ON NF.NUMERO = INF.NUMERO
GROUP BY YEAR(NF.DATA_VENDA);

-- Queremos construir um SQL cujo resultado seja, para cada cliente:
-- “O cliente João da Silva faturou 120000 no ano de 2016”.
-- Somente para o ano de 2016.

SELECT CONCAT('O cliente ', TC.NOME, ' gastou ', CAST(ROUND((SUM(INF.QUANTIDADE * INF.PRECO)), 2) AS CHAR(20)), ' no ano de 2016')
FROM itens_notas_fiscais INF
	INNER JOIN notas_fiscais NF
	ON INF.NUMERO = NF.NUMERO
	INNER JOIN tabela_de_clientes TC
	ON NF.CPF = TC.CPF
WHERE YEAR(NF.DATA_VENDA) = 2016
GROUP BY TC.NOME;

-- 1.Queremos contruir um relatório que apresente os clientes que tiveram vendas inválidas.
-- 2.Complemente este relatório listando somente os que tiveram vendas inválidas e calculando a diferença entre o limite de venda máximo e o realizado, em percentuais.

SELECT X.NOME, X.CPF, X.DATA, X.QNTD_COMPRA, X.LIMITE, X.SALDO, X.SALDO_PERCENTUAL, X.STATUS FROM
(SELECT TC.NOME, NF.CPF, date_format(DATA_VENDA, '%Y-%m') AS DATA, SUM(INF.QUANTIDADE) AS QNTD_COMPRA, MAX(TC.VOLUME_DE_COMPRA) AS LIMITE, (TC.VOLUME_DE_COMPRA - SUM(INF.QUANTIDADE)) AS SALDO,
ROUND(((SUM(INF.QUANTIDADE) / TC.VOLUME_DE_COMPRA) *100),2) AS SALDO_PERCENTUAL,
CASE 
	WHEN (TC.VOLUME_DE_COMPRA - SUM(INF.QUANTIDADE)) < 0 THEN 'INVALIDO'
    ELSE 'VALIDO'
    END AS STATUS
FROM notas_fiscais NF
	INNER JOIN itens_notas_fiscais INF
	ON NF.NUMERO = INF.NUMERO
	INNER JOIN tabela_de_clientes TC
	ON TC.CPF = NF.CPF
GROUP BY NF.CPF, date_format(DATA_VENDA, '%Y-%m')
ORDER BY NF.CPF, date_format(DATA_VENDA, '%Y-%m')) X
WHERE X.STATUS = 'INVALIDO';

-- Queremos construir um relatório com as vendas no ano de 2016 por tamanho, com uma coluna com os tamanhos, depois o ano, tudo ordenado do maior para o menor,
-- onde eu tenho as quantidade em litros vendidas no ano todo, e no final um percentual de participação.
SELECT VENDA_TAMANHO.TAMANHO, VENDA_TAMANHO.ANO, VENDA_TAMANHO.QNTD, ROUND(((VENDA_TAMANHO.QNTD / VENDA_TOTAL.QNTD) * 100), 2) AS PERCENTUAL FROM 
	(SELECT TP.TAMANHO, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QNTD
	FROM tabela_de_produtos TP
	INNER JOIN itens_notas_fiscais INF
	ON INF.CODIGO_DO_PRODUTO = TP.CODIGO_DO_PRODUTO
	INNER JOIN notas_fiscais NF
	ON NF.NUMERO = INF.NUMERO
	WHERE YEAR(NF.DATA_VENDA) = 2016
	GROUP BY TP.TAMANHO, YEAR(NF.DATA_VENDA)) VENDA_TAMANHO
INNER JOIN
	(SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QNTD
	FROM tabela_de_produtos TP
	INNER JOIN itens_notas_fiscais INF
	ON INF.CODIGO_DO_PRODUTO = TP.CODIGO_DO_PRODUTO
	INNER JOIN notas_fiscais NF
	ON NF.NUMERO = INF.NUMERO
	WHERE YEAR(NF.DATA_VENDA) = 2016
	GROUP BY YEAR(NF.DATA_VENDA)) VENDA_TOTAL
    ON VENDA_TOTAL.ANO = VENDA_TAMANHO.ANO
ORDER BY PERCENTUAL DESC;
 
SELECT * FROM tabela_de_clientes;
SELECT * FROM notas_fiscais;
SELECT * FROM itens_notas_fiscais;
SELECT * FROM tabela_de_produtos;