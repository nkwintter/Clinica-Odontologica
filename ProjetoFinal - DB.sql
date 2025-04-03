--Criação do Database e Schema
--Lembre-se de após criar o Database, conectar no mesmo para continuar rodando o Script

CREATE DATABASE clinica_odontologica;

CREATE SCHEMA IF NOT EXISTS tf;

------------------------------------------------------------------------------------------

-- Tabela de Cidades
CREATE TABLE IF NOT EXISTS tf.Cidade (
    id_cidade SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    estado VARCHAR(50) NOT NULL
);

-- Tabela de Bairros
CREATE TABLE IF NOT EXISTS tf.Bairro (
    id_bairro SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela de Tipos de Logradouro
CREATE TABLE IF NOT EXISTS tf.Tipo_Logradouro (
    id_tipo_logradouro SERIAL PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL UNIQUE
);

-- Tabela de CEPs
CREATE TABLE IF NOT EXISTS tf.CEP (
    id_cep SERIAL PRIMARY KEY,
    cep VARCHAR(15) NOT NULL UNIQUE
);

-- Tabela de Endereços
CREATE TABLE IF NOT EXISTS tf.Endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_tipo_logradouro INT REFERENCES tf.Tipo_Logradouro(id_tipo_logradouro) ON DELETE SET NULL,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    id_bairro INT REFERENCES tf.Bairro(id_bairro) ON DELETE CASCADE,
    id_cep INT REFERENCES tf.CEP(id_cep) ON DELETE CASCADE
);

-- Tabela de Pacientes
CREATE TABLE IF NOT EXISTS tf.Pacientes (
    id_paciente SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
	cpf VARCHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    id_endereco INT REFERENCES tf.Endereco(id_endereco) ON DELETE SET NULL
);

-- Tabela de Dentistas
CREATE TABLE IF NOT EXISTS tf.Dentistas (
    id_dentista SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    cro VARCHAR(20) UNIQUE NOT NULL,
    especialidade VARCHAR(100) UNIQUE NOT NULL,
    id_endereco INT REFERENCES tf.Endereco(id_endereco) ON DELETE SET NULL
);

-- Tabela de Telefones
CREATE TABLE IF NOT EXISTS tf.Telefones (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
	id_paciente INT REFERENCES tf.Pacientes(id_paciente) ON DELETE CASCADE,
	id_dentista INT REFERENCES tf.Dentistas(id_dentista) ON DELETE CASCADE,
    principal BOOLEAN NOT NULL DEFAULT FALSE
);

-- Tabela de E-mails
CREATE TABLE IF NOT EXISTS tf.Email (
    id_email SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    principal BOOLEAN NOT NULL DEFAULT FALSE,
	id_paciente INT REFERENCES tf.Pacientes(id_paciente) ON DELETE CASCADE,
	id_dentista INT REFERENCES tf.Dentistas(id_dentista) ON DELETE CASCADE
);

-- Tabela de Horários dos Atendimento
CREATE TABLE IF NOT EXISTS tf.Horarios_Atendimento (
    id_horario SERIAL PRIMARY KEY,
    id_dentista INT REFERENCES tf.Dentistas(id_dentista) ON DELETE CASCADE,
    dia_semana VARCHAR(20) NOT NULL,
    horario_inicio TIME NOT NULL,
    horario_fim TIME NOT NULL
);

-- Tabela de Procedimentos Odontológicos
CREATE TABLE IF NOT EXISTS tf.Procedimentos (
    id_procedimento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    duracao_minutos INT NOT NULL DEFAULT 60
);

-- Tabela de Consultas
CREATE TABLE IF NOT EXISTS tf.Consultas (
    id_consulta SERIAL PRIMARY KEY,
    id_paciente INT REFERENCES tf.Pacientes(id_paciente) ON DELETE CASCADE,
    id_dentista INT REFERENCES tf.Dentistas(id_dentista) ON DELETE CASCADE,
	id_procedimento INT REFERENCES tf.Procedimentos(id_procedimento) ON DELETE CASCADE,
	id_horario INT REFERENCES tf.Horarios_Atendimento(id_horario) ON DELETE CASCADE,
    data_consulta DATE NOT NULL,
    descricao TEXT,
    prescricao TEXT
);

------------------------------------------------------------------------------------------
-- Inserção de dados no Banco:

INSERT INTO tf.Cidade (nome, estado) VALUES
('São Paulo', 'SP'),
('Rio de Janeiro', 'RJ'),
('Belo Horizonte', 'MG'),
('Curitiba', 'PR'),
('Porto Alegre', 'RS'),
('Salvador', 'BA'),
('Fortaleza', 'CE'),
('Brasília', 'DF'),
('Campo Grande', 'MS'),
('Florianópolis', 'SC');

INSERT INTO tf.Bairro (nome) VALUES
('Centro'),
('Copacabana'),
('Savassi'),
('Batel'),
('Cidade Baixa'),
('Alameda'),
('Vila Mariana'),
('Ipanema'),
('Barra da Tijuca'),
('Santo Antonio');

INSERT INTO tf.Tipo_Logradouro (nome) VALUES
('Rua'),
('Avenida'),
('Praça'),
('Travessa'),
('Estrada'),
('Rodovia'),
('Beco'),
('Viela'),
('Alameda'),
('Passagem');

INSERT INTO tf.CEP (cep) VALUES
('01001-000'),
('22041-001'),
('30112-000'),
('80010-000'),
('90040-001'),
('40140-110'),
('60160-000'),
('70040-000'),
('69010-000'),
('50010-000');

INSERT INTO tf.Endereco (id_tipo_logradouro, logradouro, numero, complemento, id_bairro, id_cep) VALUES
(1, 'Rua A', '10', 'Apto 101', 1, 1),
(2, 'Avenida B', '20', 'Apto 202', 2, 2),
(3, 'Praça C', '30', '', 3, 3),
(4, 'Travessa D', '40', 'Casa', 4, 4),
(5, 'Estrada E', '50', 'Chácara', 5, 5),
(6, 'Rodovia F', '60', '', 6, 6),
(7, 'Beco G', '70', '', 7, 7),
(8, 'Viela H', '80', '', 8, 8),
(9, 'Alameda I', '90', 'Sala 901', 9, 9),
(10, 'Passagem J', '100', '', 10, 10);

INSERT INTO tf.Pacientes (nome, cpf, data_nascimento, id_endereco) VALUES
('Ana Souza', '111.222.333-44', '1985-06-15', 1),
('Carlos Lima', '222.333.444-55', '1990-09-25', 2),
('Mariana Castro', '333.444.555-66', '1982-04-10', 3),
('João Pereira', '444.555.666-77', '1995-12-01', 4),
('Fernanda Silva', '555.666.777-88', '1988-07-07', 5),
('Ricardo Alves', '666.777.888-99', '1975-11-20', 6),
('Paula Ramos', '777.888.999-00', '1998-03-14', 7),
('André Vasconcelos', '888.999.000-11', '1983-05-29', 8),
('Beatriz Oliveira', '999.000.111-22', '1991-01-17', 9),
('Eduardo Mendes', '000.111.222-33', '1980-08-09', 10);

INSERT INTO tf.Dentistas (nome, cpf, cro, especialidade, id_endereco) VALUES
('Dr. Pedro Rocha', '111.111.111-11', 'SP12345','Ortodontia', 1),
('Dra. Juliana Mendes', '222.222.222-22', 'RJ23456','Periodontia', 2),
('Dr. Fernando Costa', '333.333.333-33', 'MG34567','Endodontia', 3),
('Dra. Ana Beatriz', '444.444.444-44', 'PR45678','Implantodontia', 4),
('Dr. Marcelo Lima', '555.555.555-55', 'RS56789', 'Pediatria', 5),
('Dra. Patrícia Souza', '666.666.666-66', 'BA67890','Estética', 6),
('Dr. Rafael Nogueira', '777.777.777-77', 'CE78901','Cirurgia', 7),
('Dra. Vanessa Torres', '888.888.888-88', 'DF89012', 'Protesista', 8),
('Dr. Lucas Barros', '999.999.999-99', 'AM90123', 'Odontopediatria', 9),
('Dra. Camila Ferreira', '000.000.000-00', 'PE01234', 'Odontologia do Trabalho', 10);

INSERT INTO tf.Telefones (numero, tipo, principal, id_paciente, id_dentista) VALUES
('11987654321', 'Celular', TRUE, 4, NULL),
('1134567890', 'Residencial', FALSE, 4, NULL),
('21987654322', 'Celular', TRUE, 5, NULL),
('31987654323', 'Celular', FALSE, 5, NULL),
('41987654324', 'Fixo', TRUE, 6, NULL),
('51987654325', 'Celular', FALSE, 6, NULL),
('61987654326', 'Residencial', TRUE, NULL, 4),
('71987654327', 'Fixo', FALSE, NULL, 4),
('81987654328', 'Celular', TRUE, NULL, 5),
('91987654329', 'Fixo', FALSE, NULL, 5),
('11987654321', 'Celular', TRUE, 1, NULL),
('21998765432', 'Residencial', FALSE, 1, NULL),
('31987651234', 'Celular', TRUE, 2, NULL),
('41996543210', 'Comercial', FALSE, 2, NULL),
('51991234567', 'Celular', TRUE, 3, NULL),
('61993456789', 'Residencial', FALSE, 3, NULL),
('71992345678', 'Celular', TRUE, NULL, 1),
('81994567890', 'Comercial', FALSE, NULL, 1),
('91998761234', 'Celular', TRUE, NULL, 2),
('11996547890', 'Residencial', FALSE, NULL, 2);

INSERT INTO tf.Email (email, principal, id_paciente, id_dentista) VALUES
('ana@gmail.com',TRUE, 4, NULL),
('carlos@hotmail.com', FALSE, 4, NULL),
('mariana@yahoo.com', TRUE, 5, NULL),
('joao@empresa.com', FALSE, 5, NULL),
('fernanda@outlook.com', TRUE, 6, NULL),
('ricardo@gmail.com', FALSE, 6, NUll),
('paula@trabalho.com', TRUE, NUll, 4),
('andre@gmail.com', FALSE, NUll, 4),
('beatriz@outlook.com', TRUE, NUll, 5),
('eduardo@empresa.com', FALSE, NUll, 5),
('ana.souza@email.com', TRUE, 1, NULL),
('contato.ana@email.com', FALSE, 1, NULL),
('carlos.lima@email.com', TRUE, 2, NULL),
('carlos.trabalho@email.com', FALSE, 2, NULL),
('mariana.castro@email.com', TRUE, 3, NULL),
('mari.cas@email.com', FALSE, 3, NULL),
('pedro.rocha@odontoclinic.com', TRUE, NULL, 1),
('dr.pedro@email.com', FALSE, NULL, 1),
('juliana.mendes@odontoclinic.com', TRUE, NULL, 2),
('dra.juliana@email.com', FALSE, NULL, 2);

INSERT INTO tf.Horarios_Atendimento (id_dentista, dia_semana, horario_inicio, horario_fim) VALUES
(1, 'Segunda-feira', '08:00:00', '12:00:00'),
(2, 'Terça-feira', '09:00:00', '13:00:00'),
(3, 'Quarta-feira', '10:00:00', '14:00:00'),
(4, 'Quinta-feira', '11:00:00', '15:00:00'),
(5, 'Sexta-feira', '12:00:00', '16:00:00'),
(6, 'Sábado', '08:00:00', '12:00:00'),
(7, 'Segunda-feira', '09:00:00', '13:00:00'),
(8, 'Terça-feira', '10:00:00', '14:00:00'),
(9, 'Quarta-feira', '11:00:00', '15:00:00'),
(10, 'Quinta-feira', '12:00:00', '16:00:00');

INSERT INTO tf.Procedimentos (nome, descricao, duracao_minutos) VALUES
('Limpeza Dental', 'Procedimento para remoção de placa e tártaro', 60),
('Extração de Siso', 'Remoção de dente do siso', 60),
('Tratamento de Canal', 'Remoção da polpa dentária infectada', 60),
('Clareamento Dental', 'Branqueamento dos dentes', 60),
('Aparelho Ortodôntico', 'Correção do alinhamento dos dentes', 60),
('Restauração de Cárie', 'Recuperação do dente afetado por cárie', 60),
('Consulta Preventiva', 'Avaliação odontológica regular', 60),
('Remoção de Tártaro', 'Limpeza profunda', 60),
('Facetas Dentárias', 'Colocação de laminados dentários', 60),
('Implante Dentário', 'Substituição de dentes perdidos com implantes', 60);

INSERT INTO tf.Consultas (id_paciente, id_dentista, id_procedimento, data_consulta, id_horario, descricao, prescricao) VALUES
(1, 1, 1, '2024-07-01', 1, 'Limpeza dental', 'Usar fio dental diariamente'),
(2, 2, 2, '2024-07-02', 2, 'Extração de siso', 'Tomar anti-inflamatório por 3 dias'),
(3, 3, 3, '2024-07-03', 3, 'Tratamento de canal', 'Evitar alimentos duros por 1 semana'),
(4, 4, 4,'2024-07-04', 4, 'Clareamento dental', 'Usar gel clareador à noite'),
(5, 5, 5, '2024-07-05', 5, 'Aparelho ortodôntico', 'Manter consultas mensais'),
(6, 6, 6, '2024-07-06', 6, 'Restauração de cárie', 'Evitar doces em excesso'),
(7, 7, 7, '2024-07-07', 7, 'Consulta preventiva', 'Escovar os dentes 3x ao dia'),
(8, 8, 8, '2024-07-08', 8, 'Remoção de tártaro', 'Fazer bochecho com antisséptico'),
(9, 9, 9, '2024-07-09', 9, 'Colocação de facetas', 'Evitar corantes por 48h'),
(10, 10, 10, '2024-07-10', 10, 'Avaliação inicial', 'Marcar retorno em 6 meses'),
(8, 3, 7, '2024-07-08', 8, 'Remoção de tártaro', 'Fazer bochecho com antisséptico'),
(9, 1, 4, '2024-07-09', 9, 'Colocação de facetas', 'Evitar corantes por 48h'),
(8, 1, 2, '2024-07-09', 9, 'Colocação de facetas', 'Evitar corantes por 48h'),
(10, 5, 1, '2024-07-10', 10, 'Avaliação inicial', 'Marcar retorno em 6 meses');

------------------------------------------------------------------------------------------
-- Criação dos índices:

CREATE INDEX IF NOT EXISTS idx_cosultas_dentisas ON tf.Consultas(id_dentista);
CREATE INDEX IF NOT EXISTS idx_cosultas_paciente ON tf.Consultas(id_paciente);

-- Update de uma tabela com condição em alguma tabela:
UPDATE tf.Telefones
SET numero = '9999999999' WHERE id_telefone = 2;

UPDATE tf.Telefones
SET numero = '2631825182' WHERE id_telefone = 5;

UPDATE tf.Dentistas 
SET especialidade = 'Estomatologia' WHERE id_dentista = 2;

------------------------------------------------------------------------------------------
-- Exclusão de registro com condição em alguma tabela:
DELETE FROM tf.Consultas WHERE id_consulta = 1;
DELETE FROM tf.Pacientes WHERE id_paciente = 4;
DELETE FROM tf.Email WHERE id_email = 3;

------------------------------------------------------------------------------------------
-- Cinco Consultas especializadas:

-- 1ª - Quantidade de consultas por especialidade:
SELECT d.especialidade, COUNT(c.id_consulta) AS Total_Consultas
FROM tf.Consultas c
JOIN tf.Dentistas d ON c.id_dentista = d.id_dentista
GROUP BY d.especialidade;

-- 2ª - Quantidade de consultas realizadas por cada dentista:
SELECT d.nome, COUNT(c.id_consulta) AS Total_Consultas
FROM tf.Dentistas d
LEFT JOIN tf.Consultas c ON d.id_dentista = c.id_dentista
GROUP BY d.nome
ORDER BY Total_Consultas DESC;

--3ª - Pacientes com maior número de consultas:
SELECT p.nome AS Paciente, COUNT(c.id_consulta) AS Total_Consultas
FROM tf.Pacientes p
LEFT JOIN tf.Consultas c ON p.id_paciente = c.id_paciente
GROUP BY p.nome
ORDER BY Total_Consultas DESC;

-- 4ª View com lista de consultas ordenadas por data:
CREATE OR REPLACE VIEW tf.vw_consultas_ordenadas AS
SELECT 
	c.id_consulta, 
	p.nome AS Paciente, 
	d.nome AS Dentista, 
	c.data_consulta,
	STRING_AGG(pr.nome, ', ') AS Procedimentos_Realizados
FROM tf.Consultas c 
JOIN tf.Pacientes p ON c.id_paciente = p.id_paciente
JOIN tf.Dentistas d ON c.id_dentista = d.id_dentista
LEFT JOIN tf.Horarios_Atendimento h ON c.id_horario = h.id_horario
LEFT JOIN tf.Procedimentos pr ON c.id_procedimento = pr.id_procedimento
GROUP BY c.id_consulta, p.nome, d.nome, c.data_consulta
ORDER BY c.data_consulta DESC;

SELECT * FROM tf.vw_consultas_ordenadas;

-- 5ª - Média de consultas por dentista:
SELECT 
    d.nome AS dentista,
    ROUND(AVG(soma), 2) AS Media_Consultas
FROM 
    tf.Dentistas d
LEFT JOIN (
    SELECT 
        id_dentista, 
        COUNT(id_consulta) AS soma
    FROM 
        tf.Consultas
    GROUP BY 
        id_dentista
) AS sub ON d.id_dentista = sub.id_dentista
GROUP BY 
    d.id_dentista, d.nome
ORDER BY 
    Media_Consultas DESC;

