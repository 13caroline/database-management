-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema centrosaude
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema centrosaude
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `centrosaude` DEFAULT CHARACTER SET utf8 ;
USE `centrosaude` ;

-- -----------------------------------------------------
-- Table `centrosaude`.`Incapacidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Incapacidade` (
  `Id` INT NOT NULL,
  `Descricao` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Utente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Utente` (
  `Nr` INT NOT NULL,
  `Profissao` VARCHAR(30) NULL,
  `Nome` VARCHAR(75) NOT NULL,
  `Sexo` VARCHAR(1) NOT NULL,
  `Dador` TINYINT NULL,
  `DtNascimento` DATE NOT NULL,
  `FaixaEtaria` VARCHAR(1) NULL,
  `Rua` VARCHAR(50) NULL,
  `Cidade` VARCHAR(50) NULL,
  `Numero` INT NULL,
  `DtObito` DATE NULL,
  PRIMARY KEY (`Nr`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Contacto_Utente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Contacto_Utente` (
  `Utente` INT NOT NULL,
  `Contacto` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Utente`, `Contacto`),
  CONSTRAINT `fk_Contacto_Utente_Utente`
    FOREIGN KEY (`Utente`)
    REFERENCES `centrosaude`.`Utente` (`Nr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Utente_Incapacitado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Utente_Incapacitado` (
  `Incapacidade` INT NOT NULL,
  `Utente` INT NOT NULL,
  PRIMARY KEY (`Incapacidade`, `Utente`),
  INDEX `fk_Incapacidade_has_Utente_Utente1_idx` (`Utente` ASC) VISIBLE,
  INDEX `fk_Incapacidade_has_Utente_Incapacidade1_idx` (`Incapacidade` ASC) VISIBLE,
  CONSTRAINT `fk_Incapacidade_has_Utente_Incapacidade1`
    FOREIGN KEY (`Incapacidade`)
    REFERENCES `centrosaude`.`Incapacidade` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incapacidade_has_Utente_Utente1`
    FOREIGN KEY (`Utente`)
    REFERENCES `centrosaude`.`Utente` (`Nr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Especialidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Especialidade` (
  `Id` INT NOT NULL,
  `Descricao` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Profissional_Saude`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Profissional_Saude` (
  `CC` INT NOT NULL,
  `Nome` VARCHAR(100) NOT NULL,
  `Sexo` VARCHAR(1) NOT NULL,
  `Salario` INT NULL,
  `Especialidade` INT NOT NULL,
  PRIMARY KEY (`CC`),
  INDEX `fk_Profissional_Saude_Especialidade1_idx` (`Especialidade` ASC) VISIBLE,
  CONSTRAINT `fk_Profissional_Saude_Especialidade1`
    FOREIGN KEY (`Especialidade`)
    REFERENCES `centrosaude`.`Especialidade` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Contacto_PS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Contacto_PS` (
  `PS` INT NOT NULL,
  `Contacto` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`PS`, `Contacto`),
  CONSTRAINT `fk_Contacto_PS_Profissional_Saude1`
    FOREIGN KEY (`PS`)
    REFERENCES `centrosaude`.`Profissional_Saude` (`CC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Consulta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Consulta` (
  `Id` INT NOT NULL,
  `HoraSaida` DATETIME NULL,
  `Descricao` VARCHAR(100) NULL,
  `Duracao` INT NULL,
  `Data` DATETIME NOT NULL,
  `HoraEntrada` DATETIME NULL,
  `Estado` INT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Receita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Receita` (
  `Id` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Descricao` VARCHAR(100) NULL,
  `Consulta` INT NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `fk_Receita_Consulta1_idx` (`Consulta` ASC) VISIBLE,
  CONSTRAINT `fk_Receita_Consulta1`
    FOREIGN KEY (`Consulta`)
    REFERENCES `centrosaude`.`Consulta` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Medicamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Medicamento` (
  `Id` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`Medicamento_Receita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`Medicamento_Receita` (
  `Medicamento` INT NOT NULL,
  `Receita` INT NOT NULL,
  `Posologia` INT NULL,
  PRIMARY KEY (`Medicamento`, `Receita`),
  INDEX `fk_Medicamento_has_Receita_Receita1_idx` (`Receita` ASC) VISIBLE,
  INDEX `fk_Medicamento_has_Receita_Medicamento1_idx` (`Medicamento` ASC) VISIBLE,
  CONSTRAINT `fk_Medicamento_has_Receita_Medicamento1`
    FOREIGN KEY (`Medicamento`)
    REFERENCES `centrosaude`.`Medicamento` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Medicamento_has_Receita_Receita1`
    FOREIGN KEY (`Receita`)
    REFERENCES `centrosaude`.`Receita` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `centrosaude`.`PUC`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `centrosaude`.`PUC` (
  `Utente` INT NOT NULL,
  `PS` INT NOT NULL,
  `Consulta` INT NOT NULL,
  `Preco` FLOAT NOT NULL,
  PRIMARY KEY (`Utente`, `PS`, `Consulta`),
  INDEX `fk_PUC_Profissional_Saude1_idx` (`PS` ASC) VISIBLE,
  INDEX `fk_PUC_Consulta1_idx` (`Consulta` ASC) VISIBLE,
  CONSTRAINT `fk_PUC_Utente1`
    FOREIGN KEY (`Utente`)
    REFERENCES `centrosaude`.`Utente` (`Nr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PUC_Profissional_Saude1`
    FOREIGN KEY (`PS`)
    REFERENCES `centrosaude`.`Profissional_Saude` (`CC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PUC_Consulta1`
    FOREIGN KEY (`Consulta`)
    REFERENCES `centrosaude`.`Consulta` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
