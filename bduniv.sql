-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET UTF8MB4 ;
USE `mydb` ;


-- CREATE DOMAIN VCH8 AS VARCHAR(8);
-- CREATE DOMAIN VCH16 AS VARCHAR(16);
-- CREATE DOMAIN IF NOT EXISTS VCH32 AS VARCHAR(32);
-- CREATE DOMAIN IF NOT EXISTS VCH64 AS VARCHAR(64);
-- CREATE DOMAIN IF NOT EXISTS VCH128 AS VARCHAR(128);
-- CREATE DOMAIN IF NOT EXISTS VCH256 AS VARCHAR(256);


-- -----------------------------------------------------
-- Table `mydb`.`Pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pessoa` (
  `idPessoa` INT PRIMARY KEY AUTO_INCREMENT,
  `CPF` VARCHAR(10) NOT NULL,
  `pNome` VARCHAR(45) NOT NULL,
  `sNome` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(64) NOT NULL,
  `numero` VARCHAR(8) NOT NULL,
  `complemento` VARCHAR(16) NULL,
  `referencia` VARCHAR(32) NULL,
  `dataNascimento` DATE NOT NULL,
  `enderecoCompleto` VARCHAR(128) GENERATED ALWAYS AS  (CONCAT(endereco, ', ', numero, IFNULL(CONCAT(' ', complemento), ''))) VIRTUAL,
  UNIQUE INDEX `IDperfil_UNIQUE` (`idPessoa` ASC) VISIBLE,
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Perfil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Perfil` (
  `idPerfil` INT NOT NULL AUTO_INCREMENT,
  `tipoPerfil` VARCHAR(16) NOT NULL,
  `dataCriacao` DATE NOT NULL,
  `dataDesativacao` DATE NULL,
  `motivoDesativacao` VARCHAR(16) NULL,
  `ehDesativado` TINYINT GENERATED ALWAYS AS (IF(dataDesativacao IS NULL, 0, 1)) VIRTUAL,
  PRIMARY KEY (`idPerfil`),
  UNIQUE INDEX `IDperfil_UNIQUE` (`idPerfil` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Servicos` (
  `idServico` INT NOT NULL AUTO_INCREMENT,
  `Perfil_idPerfil` INT NOT NULL,
  `tipoServico` VARCHAR(16) NOT NULL,
  `descServico` VARCHAR(64) NOT NULL,
  `codigoServico` VARCHAR(16) NULL,
  PRIMARY KEY (`idServico`, `Perfil_idPerfil`),
  INDEX `fk_Servicos_Perfil_idx` (`Perfil_idPerfil` ASC) VISIBLE,
  CONSTRAINT `fk_Servicos_Perfil`
    FOREIGN KEY (`Perfil_idPerfil`)
    REFERENCES `mydb`.`Perfil` (`idPerfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`nn_PerfilPessoas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`nn_PerfilPessoas` (
  `idnn_PerfilPessoas` INT NOT NULL AUTO_INCREMENT,
  `Pessoa_idPessoa` INT NOT NULL,
  `Perfil_idPerfil` INT NOT NULL,
  PRIMARY KEY (`idnn_PerfilPessoas`, `Pessoa_idPessoa`, `Perfil_idPerfil`),
  UNIQUE INDEX `idnn_PerfilPessoas_UNIQUE` (`idnn_PerfilPessoas` ASC) VISIBLE,
  INDEX `fk_nn_PerfilPessoas_Pessoa1_idx` (`Pessoa_idPessoa` ASC) VISIBLE,
  INDEX `fk_nn_PerfilPessoas_Perfil1_idx` (`Perfil_idPerfil` ASC) VISIBLE,
  CONSTRAINT `fk_nn_PerfilPessoas_Pessoa1`
    FOREIGN KEY (`Pessoa_idPessoa`)
    REFERENCES `mydb`.`Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_nn_PerfilPessoas_Perfil1`
    FOREIGN KEY (`Perfil_idPerfil`)
    REFERENCES `mydb`.`Perfil` (`idPerfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Funcionario` (
  `Pessoa_idPessoa` INT NOT NULL,
  `idFuncionario` INT NOT NULL,
  `funcao` VARCHAR(32) NOT NULL,
  `salario` FLOAT NOT NULL,
  `dataAdmissao` DATE NOT NULL,
  `dataRecisao` VARCHAR(45) NULL,
  `eh_empregago` TINYINT GENERATED ALWAYS AS (IF(dataRecisao IS NULL, 0, 1)) VIRTUAL,
  PRIMARY KEY (`Pessoa_idPessoa`),
  UNIQUE INDEX `idFuncionario_UNIQUE` (`idFuncionario` ASC) VISIBLE,
  INDEX `fk_Funcionario_Pessoa1_idx` (`Pessoa_idPessoa` ASC) VISIBLE,
  CONSTRAINT `fk_Funcionario_Pessoa1`
    FOREIGN KEY (`Pessoa_idPessoa`)
    REFERENCES `mydb`.`Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Professor` (
  `Pessoa_idPessoa` INT NOT NULL,
  `idProfessor` INT NOT NULL,
  `salario` FLOAT NOT NULL,
  PRIMARY KEY (`Pessoa_idPessoa`),
  UNIQUE INDEX `idProfessor_UNIQUE` (`idProfessor` ASC) VISIBLE,
  INDEX `fk_Professor_Pessoa1_idx` (`Pessoa_idPessoa` ASC) VISIBLE,
  CONSTRAINT `fk_Professor_Pessoa1`
    FOREIGN KEY (`Pessoa_idPessoa`)
    REFERENCES `mydb`.`Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Aluno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Aluno` (
  `Pessoa_idPessoa` INT NOT NULL,
  `idAluno` INT NOT NULL,
  `processoIngresso` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Pessoa_idPessoa`),
  UNIQUE INDEX `idAluno_UNIQUE` (`idAluno` ASC) VISIBLE,
  INDEX `fk_Aluno_Pessoa1_idx` (`Pessoa_idPessoa` ASC) VISIBLE,
  CONSTRAINT `fk_Aluno_Pessoa1`
    FOREIGN KEY (`Pessoa_idPessoa`)
    REFERENCES `mydb`.`Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Curso` (
  `idCurso` INT NOT NULL AUTO_INCREMENT,
  `codigoCurso` VARCHAR(8) NOT NULL,
  `nomeCurso` VARCHAR(32) NOT NULL,
  `descricaoCurso` VARCHAR(256) NOT NULL,
  `dataCriacao` DATE NOT NULL,
  `dataDescontinuacao` DATE NULL,
  `motivoDescontinuacao` VARCHAR(128) NULL,
  `ehAtivo` TINYINT GENERATED ALWAYS AS (IF(dataDescontinuacao IS NULL, 0, 1)) VIRTUAL,
  PRIMARY KEY (`idCurso`),
  UNIQUE INDEX `idCurso_UNIQUE` (`idCurso` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Disciplinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Disciplinas` (
  `idDisciplina` INT NOT NULL AUTO_INCREMENT,
  `codigoDisciplina` VARCHAR(8) NOT NULL,
  `nomeDisciplina` VARCHAR(64) NOT NULL,
  `ementaDisciplina` VARCHAR(512) NOT NULL,
  `descricaoDisciplina` VARCHAR(512) NOT NULL,
  `dataCriacao` DATE NOT NULL,
  `dataDesativacao` DATE NULL,
  `motivoDesativacao` VARCHAR(32) NULL,
  `ehAtivoDisciplina` VARCHAR(45) GENERATED ALWAYS AS (IF(dataDesativacao IS NULL, 0, 1)) VIRTUAL,
  PRIMARY KEY (`idDisciplina`),
  UNIQUE INDEX `idDisciplina_UNIQUE` (`idDisciplina` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`nn_AlunoCurso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`nn_AlunoCurso` (
  `Curso_idCurso` INT NOT NULL,
  `Aluno_Pessoa_idPessoa` INT NOT NULL,
  `dataIngresso` DATE NOT NULL,
  `dataFormacaoPrevista` DATE NOT NULL,
  `processoIngresso` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`Curso_idCurso`, `Aluno_Pessoa_idPessoa`),
  INDEX `fk_Curso_has_Aluno_Curso1_idx` (`Curso_idCurso` ASC) VISIBLE,
  INDEX `fk_nn_AlunoCurso_Aluno1_idx` (`Aluno_Pessoa_idPessoa` ASC) VISIBLE,
  CONSTRAINT `fk_Curso_has_Aluno_Curso1`
    FOREIGN KEY (`Curso_idCurso`)
    REFERENCES `mydb`.`Curso` (`idCurso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_nn_AlunoCurso_Aluno1`
    FOREIGN KEY (`Aluno_Pessoa_idPessoa`)
    REFERENCES `mydb`.`Aluno` (`Pessoa_idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`nn_CursoDisciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`nn_CursoDisciplina` (
  `Curso_idCurso` INT NOT NULL,
  `Disciplinas_idDisciplina` INT NOT NULL,
  `tipoDisciplinaCurso` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Curso_idCurso`, `Disciplinas_idDisciplina`),
  INDEX `fk_Curso_has_Disciplinas_Disciplinas1_idx` (`Disciplinas_idDisciplina` ASC) VISIBLE,
  INDEX `fk_Curso_has_Disciplinas_Curso1_idx` (`Curso_idCurso` ASC) VISIBLE,
  CONSTRAINT `fk_Curso_has_Disciplinas_Curso1`
    FOREIGN KEY (`Curso_idCurso`)
    REFERENCES `mydb`.`Curso` (`idCurso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Curso_has_Disciplinas_Disciplinas1`
    FOREIGN KEY (`Disciplinas_idDisciplina`)
    REFERENCES `mydb`.`Disciplinas` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Oferecimentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Oferecimentos` (
  `idOferecimento` INT NOT NULL AUTO_INCREMENT,
  `Disciplinas_idDisciplina` INT NOT NULL,
  `anoOferecimento` INT NOT NULL,
  `semestreOferecimento` INT NOT NULL,
  `dataInicio` DATE NOT NULL,
  `dataFinalizacao` DATE NULL,
  PRIMARY KEY (`idOferecimento`, `Disciplinas_idDisciplina`),
  UNIQUE INDEX `idOferecimento_UNIQUE` (`idOferecimento` ASC) VISIBLE,
  INDEX `fk_Oferecimentos_Disciplinas1_idx` (`Disciplinas_idDisciplina` ASC) VISIBLE,
  CONSTRAINT `fk_Oferecimentos_Disciplinas1`
    FOREIGN KEY (`Disciplinas_idDisciplina`)
    REFERENCES `mydb`.`Disciplinas` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Boletim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Boletim` (
  `idBoletim` INT NOT NULL,
  `notaFinal` INT NOT NULL,
  `presencaFinal` INT NOT NULL,
  `conceitoFinal` VARCHAR(1) NULL,
  `ehAprovado` TINYINT GENERATED ALWAYS AS (IF(notaFinal >= 5, 1, 0)) VIRTUAL,
  PRIMARY KEY (`idBoletim`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AlunosMatriculadosOferecimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AlunosMatriculadosOferecimento` (
  `Oferecimentos_idOferecimento` INT NOT NULL,
  `Oferecimentos_Disciplinas_idDisciplina` INT NOT NULL,
  `Aluno_Pessoa_idPessoa` INT NOT NULL,
  `Boletim_idBoletim` INT NOT NULL,
  PRIMARY KEY (`Oferecimentos_idOferecimento`, `Oferecimentos_Disciplinas_idDisciplina`, `Aluno_Pessoa_idPessoa`, `Boletim_idBoletim`),
  INDEX `fk_AlunosMatriculadosOferecimento_Oferecimentos1_idx` (`Oferecimentos_idOferecimento` ASC, `Oferecimentos_Disciplinas_idDisciplina` ASC) VISIBLE,
  INDEX `fk_AlunosMatriculadosOferecimento_Aluno1_idx` (`Aluno_Pessoa_idPessoa` ASC) VISIBLE,
  INDEX `fk_AlunosMatriculadosOferecimento_Boletim1_idx` (`Boletim_idBoletim` ASC) VISIBLE,
  CONSTRAINT `fk_AlunosMatriculadosOferecimento_Oferecimentos1`
    FOREIGN KEY (`Oferecimentos_idOferecimento` , `Oferecimentos_Disciplinas_idDisciplina`)
    REFERENCES `mydb`.`Oferecimentos` (`idOferecimento` , `Disciplinas_idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AlunosMatriculadosOferecimento_Aluno1`
    FOREIGN KEY (`Aluno_Pessoa_idPessoa`)
    REFERENCES `mydb`.`Aluno` (`Pessoa_idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AlunosMatriculadosOferecimento_Boletim1`
    FOREIGN KEY (`Boletim_idBoletim`)
    REFERENCES `mydb`.`Boletim` (`idBoletim`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProfessoresOferecimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProfessoresOferecimento` (
  `Oferecimentos_idOferecimento` INT NOT NULL,
  `Oferecimentos_Disciplinas_idDisciplina` INT NOT NULL,
  `Professor_Pessoa_idPessoa` INT NOT NULL,
  PRIMARY KEY (`Oferecimentos_idOferecimento`, `Oferecimentos_Disciplinas_idDisciplina`, `Professor_Pessoa_idPessoa`),
  INDEX `fk_ProfessoresOferecimento_Oferecimentos1_idx` (`Oferecimentos_idOferecimento` ASC, `Oferecimentos_Disciplinas_idDisciplina` ASC) VISIBLE,
  INDEX `fk_ProfessoresOferecimento_Professor1_idx` (`Professor_Pessoa_idPessoa` ASC) VISIBLE,
  CONSTRAINT `fk_ProfessoresOferecimento_Oferecimentos1`
    FOREIGN KEY (`Oferecimentos_idOferecimento` , `Oferecimentos_Disciplinas_idDisciplina`)
    REFERENCES `mydb`.`Oferecimentos` (`idOferecimento` , `Disciplinas_idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProfessoresOferecimento_Professor1`
    FOREIGN KEY (`Professor_Pessoa_idPessoa`)
    REFERENCES `mydb`.`Professor` (`Pessoa_idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
