
CREATE TABLE DIM_Cliente(
  ID_cliente INTEGER PRIMARY KEY,
  Estado_civil VARCHAR,
  Sexo VARCHAR,
  Bairro VARCHAR
);

CREATE TABLE DIM_Tempo(
  ID_tempo INTEGER PRIMARY KEY,
  Ano INTEGER,
  Mes INTEGER,
  Dia INTEGER,
  Data INTEGER
);

CREATE TABLE DIM_Loja(
  ID_loja INTEGER PRIMARY KEY,
  Cod_loja INTEGER,
  Nm_loja VARCHAR
);

CREATE TABLE DIM_Produto(
  ID_produto INTEGER PRIMARY KEY,
  Cod_produto INTEGER,
  Nm_produto VARCHAR,
  Secao VARCHAR,
  Grupo VARCHAR,
  Subgrupo VARCHAR
);

CREATE TABLE FT_Vendas(
  ID_loja INTEGER,
  ID_produto INTEGER, 
  ID_cliente INTEGER,
  ID_tempo INTEGER,
  Qtde_vendida INTEGER, 
  Receita_venda DECIMAL, 
  Primary Key (ID_loja, ID_produto, ID_cliente, ID_tempo)
  Foreign Key (ID_loja) References DIM_Loja(ID_loja)
  Foreign Key (ID_produto) References DIM_Produto(ID_produto)
  Foreign Key (ID_cliente) References DIM_Cliente(ID_cliente)
  Foreign Key (ID_tempo) References DIM_Tempo(ID_tempo)
);

INSERT INTO DIM_Produto VALUES (1,55,"X","A","1","b");
INSERT INTO DIM_Produto VALUES (2,32,"Y","A","1","b");
INSERT INTO DIM_Produto VALUES (3,120,"Z","A","1","b");
INSERT INTO DIM_Produto VALUES (4,142,"Y","A","1","b");

INSERT INTO DIM_Tempo VALUES (1,2020,4,1,20200401);
INSERT INTO DIM_Tempo VALUES (2,2020,4,10,20200410);
INSERT INTO DIM_Tempo VALUES (3,2020,10,1,20201001);
INSERT INTO DIM_Tempo VALUES (4,2021,2,1,20210201);
INSERT INTO DIM_Tempo VALUES (5,2022,4,1,20210401);
INSERT INTO DIM_Tempo VALUES (6,2021,4,1,20210401);

INSERT INTO DIM_Loja VALUES (1,32,"Loja1");
INSERT INTO DIM_Loja VALUES (2,20,"Loja2");

INSERT INTO DIM_Cliente VALUES (1,"Divorciada","F","Bairro 1");
INSERT INTO DIM_Cliente VALUES (2,"Divorciada","F","Bairro 1");
INSERT INTO DIM_Cliente VALUES (3,"Divorciada","F","Bairro 1");
INSERT INTO DIM_Cliente VALUES (4,"Solteira","F","Bairro 1");
INSERT INTO DIM_Cliente VALUES (5,"Viuva","F","Bairro 1");
INSERT INTO DIM_Cliente VALUES (6,"Divorciada","M","Bairro 1");
INSERT INTO DIM_Cliente VALUES (7,"Solteiro","M","Bairro 1");

INSERT INTO FT_Vendas VALUES (1,4,1,1,5,10);
INSERT INTO FT_Vendas VALUES (2,1,7,2,6,120.5);
INSERT INTO FT_Vendas VALUES (1,2,3,5,1,400);
INSERT INTO FT_Vendas VALUES (2,2,4,6,1,300);
INSERT INTO FT_Vendas VALUES (1,3,5,6,10,1000);
INSERT INTO FT_Vendas VALUES (1,1,6,3,2,70.5);

-- Quantidade de clientes únicos do sexo feminino e estado civil divorciada
SELECT COUNT(ID_cliente) 
FROM DIM_Cliente
WHERE Sexo = "F" AND 
      Estado_civil = "Divorciada";

-- Quantidade vendida no período entre 01/04/2020 a 01/04/2021
SELECT sum(Qtde_vendida)
FROM FT_Vendas 
WHERE ID_tempo IN (SELECT ID_tempo FROM DIM_Tempo WHERE Data BETWEEN 20200401 AND 20210401);


--Buscar os produtos com código 55,120,142 e que tiveram receita maior que R$120,00;
SELECT DIM_Produto.ID_produto, Cod_produto, Nm_produto, Receita_venda
FROM DIM_Produto join FT_Vendas ON DIM_Produto.ID_produto = FT_Vendas.ID_produto
WHERE Receita_venda > 120 AND 
      (Cod_produto = 55 OR Cod_produto = 120 OR Cod_produto = 142)
ORDER BY Cod_produto;

-- Verificar a receita da loja com o código 32 no período igual ou superior a 01/04/2021
SELECT sum(Receita_venda) [RECEITA COD_LOJA 32  (01/04/2021 - ) ]
FROM FT_Vendas
WHERE ID_tempo IN (SELECT ID_tempo FROM DIM_Tempo WHERE (Ano = 2021 AND Mes >= 4) OR Ano >= 2022) AND 
      ID_loja = (SELECT ID_loja FROM DIM_Loja WHERE Cod_loja = 32);


