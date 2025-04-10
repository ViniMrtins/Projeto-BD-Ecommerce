Projeto E-commerce - Vinicius Martins- 

Fiz tabelas separadas para clientes PF e PJ
Para o pagamento fiz uma tabela contendo os dados do cartao


Resultados das querys estão em arquivo de excel.






Exemplos de querys

1. Quantos pedidos foram feitos por cada cliente?
query:

SELECT 
  Cliente_PF_idCliente_PF AS id_cliente,
  NULL AS id_loja,
  'PF' AS tipo_cliente,
  COUNT(*) AS quantidade_pedidos
FROM Pedido
WHERE Cliente_PF_idCliente_PF IS NOT NULL
GROUP BY Cliente_PF_idCliente_PF

UNION ALL

SELECT 
  NULL AS id_cliente,
  Cliente_PJ_idCliente_PJ AS id_loja,
  'PJ' AS tipo_cliente,
  COUNT(*) AS quantidade_pedidos
FROM Pedido
WHERE Cliente_PJ_idCliente_PJ IS NOT NULL
GROUP BY Cliente_PJ_idCliente_PJ;






2. Relação de produtos fornecedores e estoques
query:

SELECT 
  p.idProduto,
  p.Nome AS Nome_Produto,
  f.Razão_Social AS Fornecedor,
  pf.Quantidade AS Quantidade_Fornecida,
  e.Localização AS Local_Estoque,
  e.Quantidade AS Quantidade_Estoque
FROM Produto p
JOIN Produto_has_Fornecedor pf ON p.idProduto = pf.Produto_idProduto
JOIN Fornecedor f ON pf.Fornecedor_idFornecedor = f.idFornecedor
JOIN Estoque e ON p.idProduto = e.Produto_idProduto
ORDER BY p.idProduto, f.Razão_Social;






3. Relação de nomes dos fornecedores e nomes dos produtos
query:

SELECT 
  f.Razão_Social AS Nome_Fornecedor,
  p.Nome AS Nome_Produto
FROM Fornecedor f
JOIN Produto_has_Fornecedor pf ON f.idFornecedor = pf.Fornecedor_idFornecedor
JOIN Produto p ON pf.Produto_idProduto = p.idProduto
ORDER BY f.Razão_Social, p.Nome;






4. Quanto de cada produto foi vendido
query:

SELECT 
  p.idProduto,
  p.Nome AS Nome_Produto,
  SUM(CAST(pp.Quantidade AS UNSIGNED)) AS Total_Vendido
FROM Produto p
JOIN Produto_has_Pedido pp ON p.idProduto = pp.Produto_idProduto
WHERE pp.Quantidade REGEXP '^[0-9]+$'
GROUP BY p.idProduto, p.Nome
HAVING Total_Vendido > 0
ORDER BY Total_Vendido DESC;
