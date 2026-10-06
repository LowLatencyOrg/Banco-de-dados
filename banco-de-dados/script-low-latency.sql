CREATE DATABASE lowLatency;

-- drop database lowLatency;

USE lowLatency;

CREATE TABLE empresa( 
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(100) NOT NULL,
nome_fantasia VARCHAR(100) NOT NULL,
apelido VARCHAR(60) NOT NULL,
cnpj CHAR(14) NOT NULL UNIQUE,
email VARCHAR(80)
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
numero VARCHAR(20),
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

CREATE TABLE servidor(
id_servidor INT AUTO_INCREMENT PRIMARY KEY,
hostname VARCHAR(50),
sistema_operacional VARCHAR(100),
fk_empresa INT NOT NULL,
fk_status INT NOT NULL, 

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

CREATE TABLE limite(
id_limite INT AUTO_INCREMENT PRIMARY KEY,
fk_servidor INT NOT NULL,
fk_componente INT NOT NULL,
fk_metrica INT NOT NULL,
valor DECIMAL(10,2) NOT NULL,

UNIQUE (fk_servidor, fk_componente, fk_metrica),

CONSTRAINT fk_limite_servidor_componente
    FOREIGN KEY (fk_servidor, fk_componente)
      REFERENCES servidor_componente(fk_servidor, fk_componente),

CONSTRAINT fk_limite_componente_metrica
    FOREIGN KEY (fk_componente, fk_metrica)
      REFERENCES componente_metrica(fk_componente, fk_metrica)
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
alerta BOOLEAN,

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





