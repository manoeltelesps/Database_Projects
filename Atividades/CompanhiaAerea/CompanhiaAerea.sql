CREATE DATABASE IF NOT EXISTS CompanhiaArea;
USE CompanhiaArea;

-- Tabelas

CREATE TABLE IF NOT EXISTS Pessoa(
	idPessoa INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(200) NOT NULL,
	documento VARCHAR(200) NOT NULL UNIQUE,
	endereco VARCHAR(500) NOT NULL,
	telefone VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS Aeroporto(
	idAeroporto INT PRIMARY KEY AUTO_INCREMENT,
    fusoHorario VARCHAR(64) NOT NULL,
	nome VARCHAR(150) NOT NULL,
    cidade VARCHAR(150) NOT NULL,
    pais VARCHAR(150) NOT NULL,
	
    UNIQUE KEY ux_aeroporto (nome, cidade, pais)
);

CREATE TABLE IF NOT EXISTS Passageiro(
	nacionalidade VARCHAR(100) NOT NULL,
	dataNascimento DATE NOT NULL,
    
    idPassageiro INT PRIMARY KEY,
    
    CONSTRAINT FK_Passageiro_Pessoa FOREIGN KEY (idPassageiro) REFERENCES Pessoa(idPessoa)
	ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Funcionario(
	matricula VARCHAR(100) NOT NULL,
	cargo VARCHAR(50) NOT NULL,
    
    idFuncionario INT PRIMARY KEY,
	idFuncionario_Aeroporto INT NOT NULL,
    
    CONSTRAINT FK_Funcionario_Pessoa FOREIGN KEY (idFuncionario) REFERENCES Pessoa(idPessoa)
	ON UPDATE CASCADE ON DELETE RESTRICT,
    
	CONSTRAINT FK_Funcionario_Aeroporto FOREIGN KEY (idFuncionario_Aeroporto) REFERENCES Aeroporto(idAeroporto)
	ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS Aeronave(
	idAeronave INT PRIMARY KEY AUTO_INCREMENT,
	modelo VARCHAR(100) NOT NULL,
	fabricante VARCHAR(100) NOT NULL,
	capacidade INT NOT NULL,
	statusAeronave ENUM('ATIVA','MANUTENCAO','INATIVA') NOT NULL
);

-- Rota
CREATE TABLE IF NOT EXISTS Rota(
	idRota INT PRIMARY KEY AUTO_INCREMENT,
	distanciaKm INT NOT NULL
);

-- Destino (liga Rota a Aeroporto com papel: ORIGEM ou DESTINO)
CREATE TABLE IF NOT EXISTS Destino(
	idDestino_Rota INT NOT NULL,
	idDestino_Aeroporto INT NOT NULL,
	tipo ENUM('ORIGEM','DESTINO') NOT NULL,

	-- por rota so pode existir 1 ORIGEM e 1 DESTINO
	PRIMARY KEY (idDestino_Rota, tipo),
    UNIQUE KEY ux_rota_aeroporto (idDestino_Rota, idDestino_Aeroporto),

	CONSTRAINT FK_Destino_Rota FOREIGN KEY (idDestino_Rota) REFERENCES Rota(idRota)
	ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT FK_Destino_Aeroporto FOREIGN KEY (idDestino_Aeroporto) REFERENCES Aeroporto(idAeroporto)
	ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Voo(
	idVoo INT PRIMARY KEY AUTO_INCREMENT,
    duracaoPrevista  TIME,
    
	idVoo_Rota INT NOT NULL,
	idVoo_Aeronave INT NOT NULL,
    
    CONSTRAINT FK_Voo_Rota FOREIGN KEY (idVoo_Rota) REFERENCES Rota(idRota)
	ON UPDATE CASCADE ON DELETE RESTRICT,
    
    CONSTRAINT FK_Voo_Aeronave FOREIGN KEY (idVoo_Aeronave) REFERENCES Aeronave(idAeronave)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Bilhete(
	idBilhete INT PRIMARY KEY AUTO_INCREMENT,
	statusBilhete ENUM('ATIVO','DESATIVADO') NOT NULL,
	lugar INT NOT NULL,
    
	idPassageiro INT NOT NULL,
	idVoo INT NOT NULL,

	-- um assento existe somente dentro de um voo
	UNIQUE KEY ux_voo_lugar      (idVoo, lugar),
	-- um passageiro nao compra 2 bilhetes para o mesmo voo
	UNIQUE KEY ux_voo_passageiro (idVoo, idPassageiro),

	CONSTRAINT FK_Bilhete_Passageiro FOREIGN KEY (idPassageiro) REFERENCES Passageiro(idPassageiro)
	ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT FK_Bilhete_Voo FOREIGN KEY (idVoo) REFERENCES Voo(idVoo)
	ON UPDATE CASCADE ON DELETE CASCADE
);


