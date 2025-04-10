CREATE DATABASE IF NOT EXISTS Ecommerce;
USE Ecommerce;

CREATE TABLE IF NOT EXISTS Cartão(
  idCartão INT AUTO_INCREMENT NOT NULL,
  Nome VARCHAR(45),
  Número VARCHAR(45),
  Validade VARCHAR(45),
  CVV VARCHAR(3),
  PRIMARY KEY (idCartão)
);

CREATE TABLE IF NOT EXISTS Pagamento(
  idPagamento INT AUTO_INCREMENT NOT NULL,
  TipoPagamento VARCHAR(15),
  Cartão_idCartão INT NOT NULL DEFAULT 1,
  PRIMARY KEY (idPagamento, Cartão_idCartão),
  INDEX fk_Pagamento_Cartão1_idx (Cartão_idCartão),
  CONSTRAINT fk_Pagamento_Cartão1 FOREIGN KEY (Cartão_idCartão) REFERENCES Cartão(idCartão)
);

CREATE TABLE IF NOT EXISTS Cliente_PF(
  idCliente_PF INT AUTO_INCREMENT NOT NULL,
  Nome VARCHAR(45),
  Sobrenome VARCHAR(45),
  Contato VARCHAR(45),
  Endereço VARCHAR(99),
  Pagamento_idPagamento INT NOT NULL DEFAULT 1,
  PRIMARY KEY (idCliente_PF, Pagamento_idPagamento),
  INDEX fk_Cliente_PF_Pagamento1_idx (Pagamento_idPagamento),
  CONSTRAINT fk_Cliente_PF_Pagamento1 FOREIGN KEY (Pagamento_idPagamento) REFERENCES Pagamento(idPagamento)
);

CREATE TABLE IF NOT EXISTS Cliente_PJ(
  idCliente_PJ INT AUTO_INCREMENT NOT NULL,
  Razão_social VARCHAR(45),
  Contato VARCHAR(45),
  Endereço VARCHAR(99),
  Pagamento_idPagamento INT NOT NULL DEFAULT 1,
  PRIMARY KEY (idCliente_PJ, Pagamento_idPagamento),
  INDEX fk_Cliente_PJ_Pagamento_idx (Pagamento_idPagamento),
  CONSTRAINT fk_Cliente_PJ_Pagamento FOREIGN KEY (Pagamento_idPagamento) REFERENCES Pagamento(idPagamento)
);

CREATE TABLE IF NOT EXISTS Pedido(
  idPedido INT AUTO_INCREMENT NOT NULL,
  Status ENUM('Em processamento', 'Confirmado', 'Enviado', 'A caminho', 'Entregue') DEFAULT 'Em processamento',
  Descrição VARCHAR(45),
  Frete VARCHAR(45),
  Pagamento ENUM('Pago', 'Não pago'),
  Pagamento_idPagamento INT NOT NULL DEFAULT 1,
  Cliente_PF_idCliente_PF INT DEFAULT 1,
  Cliente_PJ_idCliente_PJ INT DEFAULT 1,
  PRIMARY KEY (idPedido, Cliente_PF_idCliente_PF, Cliente_PJ_idCliente_PJ),
  INDEX fk_Pedido_Pagamento1_idx (Pagamento_idPagamento),
  INDEX fk_Pedido_Cliente_PF1_idx (Cliente_PF_idCliente_PF),
  INDEX fk_Pedido_Cliente_PJ1_idx (Cliente_PJ_idCliente_PJ),
  CONSTRAINT fk_Pedido_Pagamento1 FOREIGN KEY (Pagamento_idPagamento) REFERENCES Pagamento(idPagamento),
  CONSTRAINT fk_Pedido_Cliente_PF1 FOREIGN KEY (Cliente_PF_idCliente_PF) REFERENCES Cliente_PF(idCliente_PF),
  CONSTRAINT fk_Pedido_Cliente_PJ1 FOREIGN KEY (Cliente_PJ_idCliente_PJ) REFERENCES Cliente_PJ(idCliente_PJ)
);

CREATE TABLE IF NOT EXISTS Produto(
  idProduto INT AUTO_INCREMENT NOT NULL,
  Nome VARCHAR(45),
  Categoria VARCHAR(45),
  Avaliação FLOAT,
  Tamanho VARCHAR(45),
  PRIMARY KEY (idProduto)
);

CREATE TABLE IF NOT EXISTS Produto_has_Pedido(
  Produto_idProduto INT NOT NULL,
  Pedido_idPedido INT NOT NULL,
  Quantidade VARCHAR(45),
  Status VARCHAR(45),
  PRIMARY KEY (Produto_idProduto, Pedido_idPedido),
  INDEX fk_Produto_has_Pedido_Pedido1_idx (Pedido_idPedido),
  INDEX fk_Produto_has_Pedido_Produto1_idx (Produto_idProduto),
  CONSTRAINT fk_Produto_has_Pedido_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
  CONSTRAINT fk_Produto_has_Pedido_Pedido1 FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
  );

CREATE TABLE IF NOT EXISTS Fornecedor(
  idFornecedor INT auto_increment NOT NULL,
  Razão_Social VARCHAR(45),
  CNPJ VARCHAR(45),
  Contato VARCHAR(45),
  Endereço VARCHAR(99),
  PRIMARY KEY (idFornecedor)
);

CREATE TABLE IF NOT EXISTS Produto_has_Fornecedor(
  Produto_idProduto INT NOT NULL,
  Fornecedor_idFornecedor INT NOT NULL,
  Quantidade VARCHAR(45),
  PRIMARY KEY (Produto_idProduto, Fornecedor_idFornecedor),
  INDEX fk_Produto_has_Fornecedor_Fornecedor1_idx (Fornecedor_idFornecedor),
  INDEX fk_Produto_has_Fornecedor_Produto1_idx (Produto_idProduto),
  CONSTRAINT fk_Produto_has_Fornecedor_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
  CONSTRAINT fk_Produto_has_Fornecedor_Fornecedor1 FOREIGN KEY (Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor)
  );

CREATE TABLE IF NOT EXISTS Estoque(
  idEstoque INT auto_increment NOT NULL,
  Localização VARCHAR(99),
  Quantidade VARCHAR(45),
  Produto_idProduto INT NOT NULL,
  CONSTRAINT fk_Estoque_Produto FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
  PRIMARY KEY (idEstoque)
);

CREATE TABLE IF NOT EXISTS Produto_has_Estoque(
  Produto_idProduto INT NOT NULL DEFAULT 1,
  Estoque_idEstoque INT NOT NULL DEFAULT 1,
  Local VARCHAR(45),
  PRIMARY KEY (Produto_idProduto, Estoque_idEstoque),
  INDEX fk_Produto_has_Estoque_Estoque1_idx (Estoque_idEstoque),
  INDEX fk_Produto_has_Estoque_Produto1_idx (Produto_idProduto),
  CONSTRAINT fk_Produto_has_Estoque_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
  CONSTRAINT fk_Produto_has_Estoque_Estoque1 FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque(idEstoque)
);

CREATE TABLE IF NOT EXISTS Vendedor(
  idVendedor INT auto_increment NOT NULL,
  Razão_Social VARCHAR(45),
  CNPJ VARCHAR(45),
  CPF VARCHAR(45),
  Contato VARCHAR(45),
  Localização VARCHAR(99),
  PRIMARY KEY (idVendedor)
);

CREATE TABLE IF NOT EXISTS Produto_has_Vendedor(
  Produto_idProduto INT NOT NULL DEFAULT 1,
  Vendedor_idVendedor INT NOT NULL DEFAULT 1,
  Quantidade VARCHAR(45),
  PRIMARY KEY (Produto_idProduto, Vendedor_idVendedor),
  INDEX fk_Produto_has_Vendedor_Vendedor1_idx (Vendedor_idVendedor),
  INDEX fk_Produto_has_Vendedor_Produto1_idx (Produto_idProduto),
  CONSTRAINT fk_Produto_has_Vendedor_Produto1 FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
  CONSTRAINT fk_Produto_has_Vendedor_Vendedor1 FOREIGN KEY (Vendedor_idVendedor) REFERENCES Vendedor(idVendedor)
);

CREATE TABLE IF NOT EXISTS Envio(
  idEnvio INT auto_increment NOT NULL,
  Transportadora VARCHAR(45),
  Previsão DATE,
  Status ENUM('Em transito', 'Saiu para entrega', 'A caminho') DEFAULT 'A caminho',
  Código_de_rastreio VARCHAR(45),
  Pedido_idPedido INT NOT NULL DEFAULT 1,
  Pedido_Cliente_PF_idCliente_PF INT NOT NULL DEFAULT 1,
  Pedido_Cliente_PJ_idCliente_PJ INT NOT NULL DEFAULT 1,
  PRIMARY KEY (idEnvio, Pedido_idPedido, Pedido_Cliente_PF_idCliente_PF, Pedido_Cliente_PJ_idCliente_PJ),
  INDEX fk_Envio_Pedido1_idx (Pedido_idPedido ASC, Pedido_Cliente_PF_idCliente_PF ASC, Pedido_Cliente_PJ_idCliente_PJ),
  CONSTRAINT fk_Envio_Pedido1 FOREIGN KEY (Pedido_idPedido, Pedido_Cliente_PF_idCliente_PF, Pedido_Cliente_PJ_idCliente_PJ) REFERENCES Pedido(idPedido, Cliente_PF_idCliente_PF, Cliente_PJ_idCliente_PJ)
);