USE `centrosaude`;


-- Implementação de um trigger que, antes de ser inserido um utente, indica o valor da sua faixa etária
DELIMITER $$
CREATE TRIGGER AtualizaFaixaEtaria BEFORE INSERT ON Utente
FOR EACH ROW
BEGIN
		IF (TIMESTAMPDIFF(YEAR, NEW.DtNascimento, CURDATE()) < 18) THEN SET NEW.FaixaEtaria = 'J';
        ELSE IF (TIMESTAMPDIFF(YEAR, NEW.DtNascimento, CURDATE()) > 65) THEN SET NEW.FaixaEtaria = 'S';
		ELSE SET NEW.FaixaEtaria = 'A';
        END IF;
        END IF;
END $$;
DELIMITER ;


-- Implementação de um procedure que insere um utente na BD 
DELIMITER $$ 
CREATE PROCEDURE InserirUtente(NrUtente INT, Profissao VARCHAR(30), Nome VARCHAR(75),Sexo VARCHAR(1),Dador BOOLEAN, Data_Nascimento DATE, Rua VARCHAR(50), Cidade VARCHAR(50),Numero INT)
BEGIN
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
    
     INSERT INTO Utente (Nr, Profissao, Nome, Sexo, Dador, DtNascimento, Rua, Cidade, Numero) VALUES (NrUtente, Profissao, Nome, Sexo, Dador, Data_Nascimento, Rua, Cidade, Numero);

     IF erro = 1
     THEN 
		BEGIN
		ROLLBACK;
		SELECT 'Sexo indicado pode não ser válido';
		END;
     ELSE COMMIT;
     END IF;
    
END $$
DELIMITER ;

-- Implementação de um procedure que insere um PS na BD
DELIMITER $$ 
CREATE PROCEDURE InserirPS(CC INT, Nome VARCHAR(100), Sexo VARCHAR(1), Salario INT, Especialidade INT)
BEGIN
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
	 INSERT INTO Profissional_Saude VALUES (CC, Nome, Sexo, Salario, Especialidade);
    
	 IF erro = 1
     THEN 
		BEGIN
		ROLLBACK;
		SELECT 'Sexo indicado pode não ser válido';
		END;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;

-- Implementação de um procedure que regista a morte de um utente
DELIMITER $$
CREATE PROCEDURE ObitoUtente(NrUtente INT, Data_Morte DATE)
BEGIN
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
    
	UPDATE Utente AS U SET U.dtObito=Data_Morte WHERE U.Nr=NrUtente;
	
     IF erro = 1
     THEN ROLLBACK;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;

-- Implementação de um trigger que desmarca consultas de utente que morreu
-- ESTADO - 1:  Marcada, 2: Iniciada, 3: Realizada, 4: Cancelada
DELIMITER $
CREATE TRIGGER DesmarcarObito BEFORE UPDATE ON Utente
FOR EACH ROW
DesmarcarObitoLabel:BEGIN    
	IF new.DtObito IS NOT NULL THEN
		UPDATE Consulta
			INNER JOIN PUC ON PUC.Consulta = Consulta.Id
				SET Estado = 4 
					WHERE Utente=old.Nr AND (Estado = 1 OR Estado = 2);
	ELSE 
		LEAVE DesmarcarObitoLabel;
	END IF ;
END $
DELIMITER ;

-- Implementação de um procedure para marcar consultas
DELIMITER $$ 
CREATE PROCEDURE MarcarConsulta(NrUtente INT, NrPS INT,NrConsulta INT, Data DATETIME)  
BEGIN
	DECLARE Erro BOOLEAN DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	START TRANSACTION;
    
    IF ((SELECT DtObito FROM Utente WHERE Nr = NrUtente) IS NOT NULL) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Nao é possivel agendar a consulta - Utente faleceu';
	ELSE 
    IF ((SELECT SemSobreposicao(NrUtente, NrPS, Data)) > 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Nao é possivel agendar a consulta - Sobreposição de consultas';
	ELSE	
        INSERT INTO Consulta (Id, Data, Estado) VALUES (NrConsulta,Data,1);
		INSERT INTO PUC (Utente, PS, Consulta)VALUES (NrUtente, NrPS, NrConsulta);
	END IF;
    END IF;
    
	IF erro = 1
	THEN BEGIN
		ROLLBACK;
		SELECT 'Possibilidades: Utente faleceu; existe sobreposição de consultas; horário de agendamento não é possível';
	 	END;
	ELSE COMMIT;
	END IF;
END $$
DELIMITER ;	


-- Implementação de um procedimento para desmarcar consultas
DELIMITER $$ 
CREATE PROCEDURE DesmarcarConsulta(NrUtente INT, data DATETIME)
BEGIN
	
     DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
    UPDATE Consulta
			INNER JOIN PUC ON PUC.Consulta = Consulta.Id
				SET Estado = 4 
					WHERE Utente=NrUtente AND Data=data;
	 IF erro = 1
     THEN 
		BEGIN
		ROLLBACK;
		SELECT 'Possibilidades: Consulta já está desmarcada';
		END;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;

-- Implementação de uma função para ajudar a agendar uma consulta sem sobreposição
DELIMITER $$ 
CREATE FUNCTION SemSobreposicao (ut INT, ps INT, dt DATETIME) RETURNS INT
	DETERMINISTIC
		BEGIN
				RETURN (SELECT COUNT(*) FROM Consulta INNER JOIN PUC ON (PUC.Consulta = Consulta.Id) 
										WHERE Data BETWEEN SUBTIME(dt, TIME('00:14:59'))
											AND ADDTIME(dt, TIME('00:14:59'))
												AND Consulta.Estado <> 3 AND Consulta.Estado <> 4
													AND (PUC.Utente = ut OR PUC.PS = ps OR (PUC.Utente = ut AND PUC.PS = ps)));
END $$
DELIMITER ;


-- Implementação de um procedure que permite remarcar uma consulta : Cancela a antiga e cria uma nova 
DELIMITER $$
CREATE PROCEDURE RemarcarConsulta(NrUtente INT, data_velha DATETIME, data_nova DATETIME, NrPS INT, NrConsulta INT)
BEGIN
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
    
	CALL DesmarcarConsulta(NrUtente, data_velha);
	CALL MarcarConsulta(NrUtente, NrPS, NrConsulta, data_nova);

     IF erro = 1
     THEN ROLLBACK;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;

-- Implementação de um trigger que permite calcular o preço da consulta consoante os parâmetros: Faixa Etária e Dador
DELIMITER $
CREATE TRIGGER precoConsulta BEFORE INSERT ON PUC
FOR EACH ROW
BEGIN
    IF ((SELECT FaixaEtaria FROM Utente WHERE Nr = new.Utente) = 'S') THEN SET new.Preco = 0;
		ELSE IF ((SELECT Dador FROM Utente WHERE Nr = new.Utente) = 1) THEN SET new.Preco = 4;
			ELSE SET new.Preco = 5;
		END IF;
    END IF;
END $
DELIMITER ;

-- Implementação de um trigger que calcula a duração da consulta em Update
DELIMITER $
CREATE TRIGGER MeterDuracaoU BEFORE UPDATE ON Consulta
FOR EACH ROW
BEGIN
	IF new.HoraSaida IS NOT NULL THEN
		SET new.Duracao = TIMESTAMPDIFF(MINUTE,new.HoraEntrada,new.HoraSaida);
	END IF;
END $$
DELIMITER ;
-- Implementação de um trigger que calcula a duração da consulta em Insert
DELIMITER $
CREATE TRIGGER MeterDuracaoI BEFORE INSERT ON Consulta
FOR EACH ROW
BEGIN
	IF new.HoraSaida IS NOT NULL THEN
		SET new.Duracao = TIMESTAMPDIFF(MINUTE,new.HoraEntrada,new.HoraSaida);
	END IF;
END $$
DELIMITER ;

-- Implementação de um trigger que atualiza o estado
DELIMITER $
CREATE TRIGGER AtualizarEstado BEFORE UPDATE ON Consulta
FOR EACH ROW
BEGIN
	IF new.HoraEntrada IS NOT NULL THEN
		IF new.Estado = 1 THEN
			SET new.Estado = 2;
		ELSE IF new.Estado = 2 AND new.HoraSaida IS NOT NULL THEN
			SET new.Estado = 3;
		END IF;
        END IF;
	END IF;		
END $$
DELIMITER ;

-- Implementação de um procedure que devolve a lista de receitas emitidas por determinado PS
DELIMITER $
CREATE PROCEDURE ReceitasM(idM INT)
BEGIN
	SELECT R.Id,R.Descricao
		FROM (( Receita R
				INNER JOIN Consulta C ON R.Consulta = C.Id)
				INNER JOIN PUC P ON P.Consulta = C.id)
			WHERE P.PS = idM;
END $$
DELIMITER ;

-- Implementação de um procedure que calcula o numero de receitas emitidas por determinado PS
DELIMITER $
CREATE PROCEDURE NmReceitasM(idM INT)
BEGIN
	SELECT COUNT(R.Id)
		FROM (( Receita R
				INNER JOIN Consulta C ON R.Consulta = C.Id)
				INNER JOIN PUC P ON P.Consulta = C.id)
			WHERE P.PS = idM;
END $$
DELIMITER ;

-- Implementação de um procedure que calcula quanto o CS ganhou num mês
DELIMITER $
CREATE PROCEDURE DinheiroMes(mes INT,ano INT)
BEGIN
	SELECT SUM(P.Preco)
		FROM ( PUC P
				INNER JOIN Consulta C ON P.Consulta = C.id)
			WHERE ((YEAR(C.Data) = ano) AND (MONTH(C.Data) = mes) AND (C.Estado = 3));
END $$
DELIMITER ;

-- Implementação de um procedure que calcula o numero de consultas feitas em determinado tempo	
DELIMITER $
CREATE PROCEDURE ConsulXTemp(inicio DATETIME,fim DATETIME)
BEGIN
	SELECT COUNT(C.Id)
		FROM Consulta C
			WHERE ((C.Data > inicio) AND (C.Data < fim));
END $$
DELIMITER ;

-- Implementação de um procedure que devolve as receitas que foram emitidas numa consulta de um dado utente
DELIMITER $
CREATE PROCEDURE ReceitasEmConsulta(idU INT,dataC DATETIME)
BEGIN
	SELECT R.Id,R.Descricao 
		FROM ((Receita R 
				INNER JOIN Consulta C ON C.Id = R.Consulta)
                INNER JOIN PUC P ON P.Consulta = C.Id)
			WHERE ((P.Utente = idU) AND (C.Data = dataC));
END $$
DELIMITER ;

-- Implementação um procedure que, dado o ID de um profissional de saúde, apresente as consultas feitas
DELIMITER $$
CREATE PROCEDURE recebeConsulta (IN numero INT)
READS SQL DATA 
BEGIN 
	SELECT PC.Consulta AS NumConsulta, P.CC AS NumCC
		FROM ((PUC PC
			INNER JOIN Profissional_Saude P ON P.CC = PC.PS)
            INNER JOIN Consulta C ON C.Id = PC.Consulta)
		WHERE P.CC = numero
        ORDER BY PC.Consulta;
END $$
DELIMITER $$

-- Implementação um procedure que, dado um ID de um profissional de saúde, apresente as consultas que realizou em determinado dia 
DELIMITER $$ 
CREATE PROCEDURE consultaDiaria (IN numero INT, dia DATE) 
READS SQL DATA 
BEGIN 
	SELECT PC.Consulta AS Numero, P.CC AS Numero, C.Data AS Dia
		FROM ((PUC PC
			INNER JOIN Profissional_Saude P ON P.CC = PC.PS)
            INNER JOIN Consulta C ON C.Id = PC.Consulta)
		WHERE P.CC = numero AND DATE(C.Data) = dia
        ORDER BY PC.Consulta;	
 
END $$
DELIMITER $$ 

-- Implementação de uma function que indica qual o bónus anual que um PS vai ganhar 
DELIMITER $$ 
CREATE FUNCTION bonusS (Prof_S INT, ano YEAR) RETURNS INT
	DETERMINISTIC
		BEGIN
			DECLARE bonus INT; 
            DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL; 
				SET bonus = (SELECT COUNT(*) FROM (SELECT COUNT(PC.Consulta) AS Numero
						FROM (PUC PC 
							INNER JOIN Consulta C ON C.Id = PC.Consulta)
								WHERE YEAR(C.Data) = ano AND PC.PS = Prof_S
									GROUP BY PC.Utente) AS T
								WHERE T.Numero >= 4);
                    RETURN bonus*50;
END $$
DELIMITER ;

-- Implementação de um procedure que calcula o bónus de um PS ao final de um ano
DELIMITER $$
CREATE PROCEDURE bonus (IN Prof_S INT, ano YEAR) 
READS SQL DATA
BEGIN 
		SELECT bonusS(Prof_S, ano) AS Bonus;
END $$
DELIMITER ;


-- Implementação um procedimento que, dado um ID de um utente, apresente o seu histórico clínico 
DELIMITER $$ 
CREATE PROCEDURE historicoClinico (IN numero INT) 
READS SQL DATA 
BEGIN 
	SELECT U.Nr AS Numero, C.Descricao AS Descricao, C.Data AS Data
		FROM ((PUC PC 
			INNER JOIN Utente U ON U.Nr = PC.Utente)
			INNER JOIN Consulta C ON C.Id = PC.Consulta) 
		WHERE U.Nr = numero AND C.Estado = 3
        ORDER BY C.Data;
        
        
END $$ 
DELIMITER ;

-- Implementação uma view que apresente todas as pessoas que já faleceram 
DROP VIEW IF EXISTS listaObito;
CREATE VIEW listaObito AS   
SELECT U.Nome, U.Nr, U.DtObito
		FROM Utente U	
			WHERE U.DtObito IS NOT NULL
	ORDER BY U.Nome ASC;   
   
-- View que mostra info de todos os utentes
DROP VIEW IF EXISTS vwUtentes;
CREATE VIEW vwUtentes AS
	SELECT DISTINCT Nr AS 'Identificação',
					Nome AS 'Nome',
                    FaixaEtaria AS 'Faixa Etária',
                    Dador AS 'Dador',
                    Sexo AS 'Sexo'
				From Utente
            WHERE DtObito IS NULL;

-- View que mostra info de todos os medicamentos          
DROP VIEW IF EXISTS vwMedicamentos;
CREATE VIEW vwMedicamentos AS
	SELECT DISTINCT Id AS 'Identificação',
					Nome AS 'Nome',
                    Descricao AS 'Informação Extra'
				FROM Medicamento;    

 -- Implementação um trigger que não permita que sejam marcadas consultas durante as horas de encerramento do centro de saúde ou em dias festivos (Natal e Ano Novo)
 DELIMITER $$
 CREATE TRIGGER AgendarEmTempoUtil BEFORE INSERT ON Consulta
 FOR EACH ROW 
 BEGIN 
	IF (TIME(new.Data) >= '20:00:00' OR TIME(new.Data) <= '07:59:59' ) 
		OR (MONTH(new.Data) = 12 AND DAY(new.Data) = 25 ) 
		OR (MONTH(new.Data) = 1 AND DAY(new.Data) = 1) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Nao é possivel agendar a consulta';
    END IF; 
END $$
DELIMITER ;

-- Implemetação de um trigger que garante que não é inserido nenhum sexo aquando o registo do Utente que não seja M ou F 
DELIMITER $$
 CREATE TRIGGER GenderSafe BEFORE INSERT ON Utente
 FOR EACH ROW 
 BEGIN 
	IF (new.Sexo <> 'F' AND new.Sexo <> 'M') 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sexo escolhido não é válido, use F ou M';
    END IF; 
END $$
DELIMITER ;

-- Implemetação de um trigger que garante que não é inserido nenhum sexo aquando o registo do PS que não seja M ou F 
DELIMITER $$
 CREATE TRIGGER GenderSafePS BEFORE INSERT ON Profissional_Saude
 FOR EACH ROW 
 BEGIN 
	IF (new.Sexo <> 'F' AND new.Sexo <> 'M') 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sexo escolhido não é válido, use F ou M';
    END IF; 
END $$
DELIMITER ;

-- Implementação um procedure que emita receitas 
DELIMITER $$ 
CREATE PROCEDURE EmitirReceita(receita INT, data DATE, descricao VARCHAR(100), consulta INT)
BEGIN
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
		IF ((SELECT Estado FROM Consulta WHERE Id = consulta) <> 4) AND ((SELECT Estado FROM Consulta WHERE Id = consulta) <> 1)
			THEN INSERT INTO Receita (Id,Data,Descricao, Consulta) VALUES (receita, data, descricao, consulta);
		ELSE
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consulta está desmarcada ou ainda não começou';
        END IF;
     IF erro = 1
     THEN ROLLBACK;
		BEGIN
		ROLLBACK;
		SELECT 'Consulta está desmarcada ou ainda não começou';
		END;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ContactoUtente(Id INT, contacto VARCHAR(50))
BEGIN 
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
		INSERT INTO Contacto_Utente VALUES (Id, contacto);
     IF erro = 1
     THEN ROLLBACK;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ContactoPs(CC INT, contacto VARCHAR(50))
BEGIN 
	 DECLARE Erro BOOLEAN DEFAULT 0;
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    
	 START TRANSACTION;
		INSERT INTO Contacto_PS VALUES (Id, contacto);
     IF erro = 1
     THEN ROLLBACK;
     ELSE COMMIT;
     END IF;
END $$
DELIMITER ;