USE `centrosaude`;

-- povoamento Especialidade
INSERT INTO Especialidade (Id, Descricao) VALUES
(1, 'Medicina Interna'),
(2, 'Nutrição'),
(3, 'Psiquiatria'), 
(4, 'Psicologia'),
(5, 'Medicina Geral e Familiar');   

-- povoamento Profissional_Saude
INSERT INTO Profissional_Saude (Nome, CC, Sexo, Salario, Especialidade) VALUES
('Roberto Cunha',11234,'M', 2500,1),
('Anastácia Pereira',98207,'F', 2000,2),
('Diogo Magalhães',19981,'M', 1400,3),
('Maria Pinho',56277,'F', 2900,4),
('Feliciana Freitas',78352,'F', 2200, 5),
('Manuel Matias',34563,'M', 2200,5);


-- povoamento Contacto_PS
INSERT INTO Contacto_PS (PS, Contacto) VALUES 
(11234,'918273859'),
(98207,'928394017'),
(19981,'939492738'),
(56277,'969278123'),
(78352,'912346132'),
(34563,'967812349');


-- povoamento Utente
INSERT INTO Utente (Nome,Nr,Sexo,DtNascimento,Profissao,Dador,FaixaEtaria,Rua,Cidade,Numero,DtObito) VALUES
('Rodolfina Oliveira',137142,'F','1984/03/05','Professor',1,NULL,'Rua da Porta','Caldas de Vizela',1,NULL),
('Sofia Ferreira',251938,'F','1976/09/06','Banqueiro',1,NULL,'Rua de Santa Margarida','Braga',192,NULL),
('Nuno Dias',123456,'M','2007/02/05','Estudante',0,NULL,'Travessa das Arroteias','Rio Tinto',180,NULL),
('Marco Silva',654678,'M','1992/08/22','Veterinário',1,NULL,'Rua Primeiro de Maio','Braga',245,NULL),
('Cristina Pinheiro',978675,'F','1943/11/12','Reformado',0,NULL,'Rua de Portugal','Valongo',58,NULL), 
('Miquelina Maria',133564,'F','1947/01/15','Reformado',0,NULL,'Rua Gil Vincente','Guimarães',13,NULL),
('Francisco Manuel',995513,'M','2013/02/09','Estudante',0,NULL,'Rua Maximino de Matos','Fafe',18,NULL),
('José Joaquim',772413,'M','1968/05/28','Carpinteiro',1,NULL,'Rua Camilo Castelo Branco','Vila Nova de Famalicão',46,NULL),
('Guilhermina Sá Freitas',133897,'F','1929/10/17','Reformado',0,NULL,'Rua Santa Catarina','Porto',78,NULL),
('Manuel Antunes',353761,'M','1980/03/25','Escritorário',1,NULL,'Rua de Bom Jardim','Porto',33,NULL),
('Margarida Freitas',225839,'F','1988/04/27','Modista',1,NULL,'Rua da Misericórdia','Vila Verde',25,NULL),
('Pedro Frazão',667553,'M','1988/08/10','Madeireiro',1,NULL,'Rua da Igreja','Póvoa de Lanhoso',535,NULL),
('Aurora Menezes',180827,'F','1957/11/11','Professor',0,NULL,'Rua Padre Américo','Penafiel',16,NULL), 
('Sónia Araújo',517943,'F','1992/09/25','Professor',1,NULL,'Praça da República','Caminha',10,NULL),
('Joana Pereira',693156,'F','2013/05/05','Estudante',0,NULL,'Rua das Barcas','Ponte Barca',57,NULL),
('António Moreira',954132,'M','1948/12/12','Reformado',0,NULL,'Rua São João de Deus','Vila Nova de Famalicão',31,NULL),
('Amélia Carmélia',576382,'F','1928/01/31','Reformado',0,NULL,'Rua São Marcos','Braga',140,NULL),
('Ameliana Carmo',576132,'F','1922/06/21','Reformado',0,NULL,'Avenida Central','Braga',40,'2018/11/18'),
('Joana Vaz',152637,'F','1960/10/19','Escritor',1,NULL,'Rua da Porta Nova', 'Braga',20,'2017/01/02'),
('Felisberto Castro',839271,'M','1940/03/05','Reformado',1,NULL,'Rua Cândido dos Reis','Barcelos',12,'2013/05/06');

-- povoamento Incapacidade
INSERT INTO Incapacidade (Id,Descricao) VALUES
(1, 'Esquizofrenia'), -- psiquiatra -- DADOR
(2, 'Toxicodependência'), -- NAO DADOR
(3, 'Etilismo Crónico'), -- psiquiatra -- NAO DADOR 
(4, 'Depressão'), -- Psico -- DADOR PARA LIGEIRA
(5, 'Alterações Comportamentais'), -- Psico -- NAO DADOR
(6, 'Hiperatividade'), -- Psico, criança -- DADOR
(7, 'Obesidade'), -- N, MGF -- DADOR
(8, 'Intolerância Alimentar'), -- N -- DADOR
(9, 'Hipertensão'), -- MI, MFG -- DADOR
(10, 'Doença Pulmonar Obstrutiva Crónica'), -- MI -- NAO DADOR
(11, 'Gripe'), -- mgf -- DADOR
(12, 'Dores Abdominais'); -- mgf -- DADOR


-- povoamento Utente_Incapacitado
INSERT INTO Utente_Incapacitado (Utente, Incapacidade) VALUES
(667553,1),
(137142,2),
(180827,3),
(517943,4),
(123456,5),
(995513,6),
(137142,7),
(693156,8),
(133564,9),
(954132,10),
(251938,11),
(995513,12);


-- povoamento Contacto_Utente
INSERT INTO Contacto_Utente (Utente, Contacto) VALUES 
(137142,'919187762'),
(251938,'965748219'),
(123456,'928791236'),
(654678,'938102941'),
(978675,'255098789'),
(978675,'918265910');

-- povoamento Consulta
INSERT INTO Consulta (Id, Data,HoraEntrada,HoraSaida,Duracao,Descricao,Estado) VALUES -- ESTADO - 1:  Marcada, 2: Iniciada, 3: Realizada, 4: Cancelada
(1,'2018-11-01 12:15:00','2018-11-01 12:16:00',NULL,NULL,NULL,2),     
(2,'2022-01-03 08:15:00',NULL,NULL,NULL,NULL,1),
(3,'2018-12-11 11:00:00','2018-12-11 11:05:00',NULL,NULL,NULL,2),
(4,'2019-01-10 09:00:00',NULL,NULL,NULL,NULL,1),
(5,'2018-04-05 18:30:00',NULL,NULL,NULL,NULL,4),
(6,'2015-11-01 14:45:00','2015-11-01 14:46:00','2015-11-01 15:01:00',NULL,'Utente com grau elevado de obesidade.Receita a prescrever.',3),
(7,'2017-08-12 17:00:00','2017-08-12 17:00:00','2017-08-12 17:10:00',NULL,'Utente com sintomas de intolerância alimentar.Receita a prescrever.',3),
(8,'2018-04-22 10:15:00','2018-04-22 10:15:45','2018-04-22 10:30:45',NULL,'Utente com hipertensão.Receita a prescrever.',3),
(9,'2018-09-15 16:45:00','2018-09-15 16:46:00','2018-09-15 17:00:00',NULL,'Utente apresenta sinais hiperatividade. Receita a prescrever.',3),
(10,'2021-02-02 11:45:00',NULL,NULL,NULL,NULL,1),
(11,'2021-03-15 12:00:00',NULL,NULL,NULL,NULL,1),
(12,'2017-06-25 19:45:00','2017-06-25 19:45:30','2017-06-25 19:45:30',NULL,'Utente com algumas alterações comportamentais. Receita a prescrever.',3),
(13,'2018-11-07 19:45:00','2018-11-07 19:46:00',NULL,NULL,NULL,2),
(14,'2023-12-01 11:30:00',NULL,NULL,NULL,NULL,1),
(15,'2025-05-12 15:00:00',NULL,NULL,NULL,NULL,4),
(16,'2019-01-19 17:15:00','2019-01-19 17:16:00',NULL,NULL,NULL,1),
(17,'2018-04-05 18:30:00','2018-04-05 18:32:00','2018-04-05 18:49:00',NULL,'Utente apresenta DPOC grave. Receita a prescrever. Necessidade de exames.',3),
(18,'2021-02-02 16:45:00',NULL,NULL,NULL,NULL,1),
(19,'2021-03-15 12:00:00',NULL,NULL,NULL,NULL,4),
(20,'2023-12-01 11:30:00',NULL,NULL,NULL,NULL,1),
(21,'2023-12-01 11:45:00',NULL,NULL,NULL,NULL,1),
(22,'2021-03-15 12:15:00',NULL,NULL,NULL,NULL,4),
(23,'2018-11-01 12:30:00','2018-11-01 12:30:20','2018-11-01 12:45:50',NULL,'Utente apresenta queixas de dores abdominais. Receita a prescrever.',3),
(24,'2018-10-11 08:30:00','2018-10-11 08:30:00','2018-10-11 08:43:00',NULL,'Utente com etilismo crónico. Receita a prescrever.',3),
(25,'2018-05-21 13:00:00','2018-05-21 13:05:00','2018-05-21 13:25:00',NULL,'Utente apresenta indícios de depressão.Receita a prescrever.',3),
(26,'2018-07-15 18:45:00','2018-07-15 18:46:00','2018-07-15 18:55:10',NULL,'Utente apresenta toxicodependência. Receita a prescrever.',3),
(27,'2018-01-11 10:45:00','2018-01-11 10:47:00','2018-01-11 11:01:00',NULL,'Utente encontra-se com gripe. Prescrição de receita.',3),
(28,'2018-04-13 19:00:00','2018-04-13 19:01:00','2018-04-13 19:15:00',NULL,'Utente com indícios de esquizofrenia. Necessidade de exames. Receita a prescrever.',3),
(29,'2018-09-13 14:15:00','2018-09-13 14:15:00','2018-09-13 14:25:00',NULL,'Consulta de Rotina',3),
(30,'2018-01-11 08:45:00','2018-01-11 08:45:00','2018-01-11 09:00:00',NULL,'Consulta de Rotina',3),
(31,'2018-03-12 09:15:00','2018-03-12 09:15:00','2018-03-12 09:30:00',NULL,'Consulta de Rotina',3),
(32,'2018-05-20 08:45:00','2018-05-20 08:45:00','2018-05-20 09:00:00',NULL,'Consulta de Rotina',3);


-- povoamento Receita
INSERT INTO Receita (Id, Data, Descricao,Consulta) VALUES 
(1, '2015-11-01','3 vezes por dia', 6),
(2, '2017-08-12','8 em 8 horas', 7),
(3, '2018-04-22','8 em 8 horas', 8),
(4, '2018-09-15','3 vezes por dia', 9),
(5, '2017-06-25','1 vez por dia', 12),
(6, '2018-04-05','3 vezes por dia, 15 minutos antes das refeições', 17),
(7, '2018-11-01','1 vez por semana', 23),
(8, '2018-10-11','1 vez por dia', 24),
(9, '2018-05-21','1 vez por dia', 25),
(10, '2018-07-15','1 vez por dia', 26),
(11, '2018-01-11','3 vezes por dia', 27),
(12, '2018-04-13','1 vez por dia', 27),
(13, '2018-01-11','3 vezes por dia', 28);


-- povoamento Medicamento 
INSERT INTO Medicamento(Id,Nome,Descricao) VALUES 
(1,'Haloperidol','5mg comprimido'), -- esquizofrenia
(2,'Butil-Escopolamina','supositório'), -- dores abdominais (criança)
(3,'Paracetamol','1000mg comprimido'),
(4,'Brometo de Hipratrópio', 'nebulização'), -- doença pulmonar
(5,'Losartan','50mg comprimido'),
(6,'Domperidona','10mg comprimido'),
(7,'Dulaglutida','1.5mg Ampola subcutanea'),
(8,'Metilfedinato','60mg comprimido'),
(9,'Nisperidona','1mg compimido'),
(10,'Paroxetina','20mg comprimido'),
(11,'Tiapride','100mg comprimido'),
(12,'Metadona','30mg comprimido'),
(13,'Ibuprofeno','400mg comprimido');


-- povoamento Medicamento_Receita
INSERT INTO Medicamento_Receita(Receita, Medicamento, Posologia) VALUES
(1,1,3),
(12,2,3),
(12,3,3),
(11,3,3),
(10,4,3), 
(9,5,1), 
(8,6,3), 
(7,7,1),
(6,8,1),
(5,9,1),
(4,10,1), 
(3,11,3),
(13,13,3),
(2,12,1);


-- povoamento PUC 
INSERT INTO PUC(Utente,PS,Consulta,Preco) VALUES
(137142,78352,6,5),
(693156,98207,7,5),
(133564,34563,8,5),
(995513,56277,9,5),
(123456,56277,12,5),
(954132,11234,17,5),
(995513,78352,23,5),
(180827,19981,24,5),
(517943,56277,25,5),
(137142,19981,26,5),
(251938,34563,27,5),
(667553,19981,28,5),
(654678,34563,29,5),
(978675,78352,1,5),
(772413,11234,2,5),
(133897,11234,3,5),
(353761,98207,4,5),
(225839,98207,5,5),
(576382,34563,10,5),
(995513,56277,11,5),
(137142,78352,13,5),
(995513,78352,14,5),
(576382,34563,15,5),
(693156,98207,16,5),
(772413,11234,18,5),
(654678,34563,19,5),
(654678,34563,20,5),
(133897,11234,21,5),
(225839,19981,22,5),
(137142,78352,30,5),
(137142,78352,31,5),
(137142,78352,32,5);