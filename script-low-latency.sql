DROP DATABASE IF EXISTS lowLatency;

CREATE DATABASE lowLatency;  

-- drop database lowLatency;

USE lowLatency;

CREATE TABLE empresa( 
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(100) NOT NULL,
nome_fantasia VARCHAR(100) NOT NULL,
apelido VARCHAR(60) NOT NULL,
cnpj CHAR(14) NOT NULL UNIQUE
);

CREATE TABLE cargo(
id_cargo INT PRIMARY KEY AUTO_INCREMENT,
descricao VARCHAR(45) NOT NULL
);

CREATE TABLE usuario(
id_usuario INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(60) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
email VARCHAR(80),
senha VARCHAR(255) NOT NULL,
fk_empresa INT NOT NULL,
fk_cargo INT NOT NULL, 

CONSTRAINT fk_usuario_empresa 
	FOREIGN KEY (fk_empresa) 	
		REFERENCES empresa(id_empresa),

CONSTRAINT fk_usuario_cargo 
	FOREIGN KEY (fk_cargo) 	
		REFERENCES cargo(id_cargo)
);

CREATE TABLE tipo_contato(
id_tipo_contato INT PRIMARY KEY AUTO_INCREMENT,
descricao VARCHAR(30) NOT NULL
);

CREATE TABLE contato(
id_contato INT  PRIMARY KEY AUTO_INCREMENT,
descricao VARCHAR(45),
fk_empresa INT, 
fk_usuario INT, 
fk_tipo_contato INT NOT NULL, 

CONSTRAINT fk_contato_empresa
	FOREIGN KEY(fk_empresa)
		REFERENCES empresa(id_empresa),

CONSTRAINT fk_contato_usuario
	FOREIGN KEY(fk_usuario)
		REFERENCES usuario(id_usuario),
        
CONSTRAINT fk_contato_tipo
	FOREIGN KEY (fk_tipo_contato)
        REFERENCES tipo_contato(id_tipo_contato),
        
CONSTRAINT chk_contato_dono
    CHECK ((fk_empresa IS NOT NULL AND fk_usuario IS NULL) OR
		   (fk_empresa IS NULL AND fk_usuario IS NOT NULL))
);

CREATE TABLE endereco(
id_endereco INT PRIMARY KEY AUTO_INCREMENT,
cep CHAR(8) NOT NULL,
endereco VARCHAR(100) NOT NULL,
numero INT NOT NULL,
complemento VARCHAR(20),
cidade VARCHAR(30) NOT NULL,
UF CHAR(2) NOT NULL,
fk_empresa INT NOT NULL,

CONSTRAINT fk_endereco_empresa
	FOREIGN KEY (fk_empresa)
		REFERENCES empresa(id_empresa)
);

CREATE TABLE status_servidor(
id_status INT PRIMARY KEY AUTO_INCREMENT, 
descricao VARCHAR(45)
);

CREATE TABLE sistema_operacional(
id_sistema_operacional INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE servidor(
id_servidor INT AUTO_INCREMENT PRIMARY KEY,
hostname VARCHAR(50),
mac_adress VARCHAR(45),
fk_sistema_operacional INT NOT NULL,
fk_empresa INT NOT NULL,
fk_status INT NOT NULL, 

CONSTRAINT fk_servidor_sistema_operacional
	FOREIGN KEY (fk_sistema_operacional)
        REFERENCES sistema_operacional(id_sistema_operacional),

CONSTRAINT fk_servidor_status
	FOREIGN KEY (fk_status) 
		REFERENCES status_servidor(id_status),
        
CONSTRAINT fk_servidor_empresa
	FOREIGN KEY(fk_empresa)
		REFERENCES empresa(id_empresa)
);

CREATE TABLE componente(
id_componente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL
);

CREATE TABLE servidor_componente(
fk_servidor INT NOT NULL, 
fk_componente INT NOT NULL,

FOREIGN KEY (fk_servidor) 
	REFERENCES servidor(id_servidor), 
        
FOREIGN KEY (fk_componente)
	REFERENCES componente(id_componente),

PRIMARY KEY(fk_servidor, fk_componente)
);

CREATE TABLE metrica(
id_metrica INT PRIMARY KEY AUTO_INCREMENT, 
descricao VARCHAR(45) NOT NULL
);

CREATE TABLE componente_metrica(
fk_componente INT NOT NULL, 
fk_metrica INT NOT NULL, 

FOREIGN KEY (fk_componente)
	REFERENCES componente(id_componente),

FOREIGN KEY (fk_metrica)
	REFERENCES metrica(id_metrica),
    
PRIMARY KEY(fk_componente, fk_metrica)
);

CREATE TABLE alerta (
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(45) NOT NULL,
    cor VARCHAR(20) NOT NULL
);

CREATE TABLE limite(
id_limite INT AUTO_INCREMENT PRIMARY KEY,
fk_servidor INT NOT NULL,
fk_componente INT NOT NULL,
fk_metrica INT NOT NULL,
fk_alerta INT NOT NULL,
valor DECIMAL(10,2) NOT NULL,

CONSTRAINT fk_limite_servidor_componente
    FOREIGN KEY (fk_servidor, fk_componente)
      REFERENCES servidor_componente(fk_servidor, fk_componente),

CONSTRAINT fk_limite_componente_metrica
    FOREIGN KEY (fk_componente, fk_metrica)
      REFERENCES componente_metrica(fk_componente, fk_metrica),

 CONSTRAINT fk_limite_alerta
    FOREIGN KEY (fk_alerta)
		REFERENCES alerta(id_alerta)
);

CREATE TABLE unidade_medida(
id_unidade INT PRIMARY KEY AUTO_INCREMENT , 
descricao VARCHAR(45)
);

CREATE TABLE leitura(
id_leitura INT AUTO_INCREMENT PRIMARY KEY,
fk_servidor INT NOT NULL,
fk_componente INT NOT NULL,
fk_metrica INT NOT NULL,
valor DECIMAL(10,2) NOT NULL,
fk_unidade_medida INT NOT NULL, 
dia_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
fk_alerta INT NOT NULL, 

CONSTRAINT fk_leitura_alerta
    FOREIGN KEY (fk_alerta)
		REFERENCES alerta(id_alerta),

CONSTRAINT fk_leitura_servidor_componente
    FOREIGN KEY (fk_servidor, fk_componente)
        REFERENCES servidor_componente(fk_servidor, fk_componente),

CONSTRAINT fk_leitura_componente_metrica
    FOREIGN KEY (fk_componente, fk_metrica)
        REFERENCES componente_metrica(fk_componente, fk_metrica),

CONSTRAINT fk_leitura_unidade_medida
    FOREIGN KEY (fk_unidade_medida)
        REFERENCES unidade_medida(id_unidade)
);

CREATE TABLE empresa_componente(
    fk_empresa INT NOT NULL,
    fk_componente INT NOT NULL,

    PRIMARY KEY (fk_empresa, fk_componente),

    CONSTRAINT fk_empresa_componente_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa(id_empresa),

    CONSTRAINT fk_empresa_componente_componente
        FOREIGN KEY (fk_componente)
        REFERENCES componente(id_componente)
);


INSERT INTO empresa (razao_social, nome_fantasia, apelido, cnpj) 
VALUES ('B3 S.A. - Brasil, Bolsa, Balcao', 'B3', 'Bolsa BR', '09346601000125');

INSERT INTO cargo (descricao) VALUES ('Gestor');
INSERT INTO cargo (descricao) VALUES ('Analista de Infraestrutura');

INSERT INTO tipo_contato (descricao) VALUES ('Celular');
INSERT INTO tipo_contato (descricao) VALUES ('Telefone Fixo');

INSERT INTO usuario (nome, cpf, email, senha, fk_empresa, fk_cargo) 
VALUES ('Gestor de Operacoes', '11122233344', 'gestor@b3.com.br', '12345', 1, 1);

INSERT INTO contato (fk_empresa, fk_usuario, fk_tipo_contato) 
VALUES (NULL, 1, 1);

insert into sistema_operacional values (default, 'linux'),
(default, 'windows'),
(default, 'mac_os');

insert into status_servidor values
	(default, 'ativo'),
    (default, 'inativo'),
    (default, 'manutenção');
    
    
 
insert into servidor values 
(default, 'matching-engine-01', '02F1031522A9', 1, 1, 1),
(default, 'market-data-01', '18C10D153B9F', 1, 1, 1);

insert into metrica values 
(default, 'uso em %'),
(default, 'frequencia em GHz'),
(default, 'qtd pacotes recebidos em KB'),
(default, 'qtd pacotes enviados em KB');

insert into componente values
(default, 'cpu'),
(default, 'ram'),
(default, 'disco'),
(default, 'rede');

insert into alerta values 
(default, 'normal', 'verde'),
(default, 'alerta', 'laranja'),
(default, 'critico', 'vermelho');

insert into unidade_medida values 
(default, '%'),
(default, 'GHz'),
(default, 'KB');

INSERT INTO servidor_componente (fk_servidor, fk_componente) VALUES 
(1, 4), 
(2, 4);

INSERT INTO componente_metrica (fk_componente, fk_metrica) VALUES 
(4, 3), 
(4, 4);


CREATE USER IF NOT EXISTS 'client_java'@'%' IDENTIFIED BY 'Sptech#2026';
GRANT INSERT ON lowLatency.leitura TO 'client_java'@'%';
FLUSH PRIVILEGES;    

CREATE USER IF NOT EXISTS 'script_python'@'%' IDENTIFIED BY 'Sptech#2026';
GRANT INSERT ON lowLatency.leitura TO 'script_python'@'%';
FLUSH PRIVILEGES; 

select * from servidor_componente;
select * from empresa_componente;
select * from componente_metrica;
select * from limite;
select * from servidor;
select * from leitura;







