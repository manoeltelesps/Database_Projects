USE SalaDeAula;


-- Questao 2

CREATE INDEX idx_pessoa_cpf
ON Pessoa (CPF);

SELECT * FROM Pessoa WHERE CPF = '39354382537';

-- Questao 3

ALTER TABLE Avaliacao
  ADD COLUMN tipo_prova_busca VARCHAR(16)
  GENERATED ALWAYS AS (CONCAT('prova_', CAST(tipo_prova AS CHAR(3)))) STORED;
  
CREATE FULLTEXT INDEX ft_avaliacao_busca
ON Avaliacao (ocorrencia, tipo_prova_busca);
  
SELECT ID, aluno_turma_id, tipo_prova, nota
FROM Avaliacao
WHERE MATCH (ocorrencia, tipo_prova_busca)
      AGAINST ('+cola +prova_p3' IN BOOLEAN MODE);
      
-- Questao 5

CREATE OR REPLACE VIEW vw_alunos_ocorrencias_avaliacoes AS
SELECT
  a.matricula          AS aluno_mat,
  p.nome               AS aluno_nome,
  atur.turma_cod,
  av.tipo_prova,
  av.nota,
  av.ocorrencia
FROM Aluno a
JOIN Pessoa p           ON p.ID = a.pessoa_id
JOIN Aluno_Turma atur   ON atur.aluno_mat = a.matricula
JOIN Avaliacao av       ON av.aluno_turma_id = atur.ID
LEFT JOIN Aluno_Curso ac ON ac.aluno_mat = a.matricula AND ac.dt_fim IS NULL
WHERE a.status = 'ativo'
  AND av.ocorrencia IS NOT NULL
  AND TRIM(av.ocorrencia) <> '';
  
  -- Questao 6
  -- Professor + Pessoa
CREATE OR REPLACE VIEW vw_professor_dados AS
SELECT
  pr.matricula     AS prof_mat,
  pr.ativo         AS prof_ativo,
  pe.ID            AS pessoa_id,
  pe.CPF,
  pe.nome,
  pe.data_nascimento,
  pe.end_logradouro,
  pe.end_numero,
  pe.end_complemento,
  pe.end_bairro,
  pe.end_cidade,
  pe.end_uf_sigla
FROM Professor pr
JOIN Pessoa pe ON pe.ID = pr.pessoa_id;

-- Aluno + Pessoa
CREATE OR REPLACE VIEW vw_aluno_dados AS
SELECT
  a.matricula      AS aluno_mat,
  a.status         AS aluno_status,
  a.dt_matricula,
  pe.ID            AS pessoa_id,
  pe.CPF,
  pe.nome,
  pe.data_nascimento,
  pe.end_logradouro,
  pe.end_numero,
  pe.end_complemento,
  pe.end_bairro,
  pe.end_cidade,
  pe.end_uf_sigla
FROM Aluno a
JOIN Pessoa pe ON pe.ID = a.pessoa_id;


-- Questao 7
CREATE ROLE IF NOT EXISTS 'Secretaria';

GRANT
  SELECT, INSERT, UPDATE,
  CREATE, ALTER, INDEX,
  CREATE VIEW, SHOW VIEW,
  TRIGGER, EVENT, EXECUTE,
  REFERENCES
ON SalaDeAula.* TO 'Secretaria';

-- Questao 8
CREATE USER IF NOT EXISTS 'maria'@'localhost.com' IDENTIFIED BY '12345678';

GRANT 'Secretaria' TO 'maria'@'localhost.com';
SET DEFAULT ROLE 'Secretaria' TO 'maria'@'localhost.com';

-- Questao 9
DELIMITER $$

CREATE TRIGGER tg_avaliacao_ins_ocorrencia_zerar
BEFORE INSERT ON Avaliacao
FOR EACH ROW
BEGIN
  IF NEW.ocorrencia IS NOT NULL AND
     TRIM(NEW.ocorrencia) <> '' AND
     NEW.ocorrencia REGEXP '(fraude|cola|plagio|indisciplina[ ]*grave)'
  THEN
    SET NEW.nota = 0.0;
  END IF;
END$$

DELIMITER ;

-- Questao 10
DELIMITER $$

CREATE TRIGGER tg_avaliacao_upd_ocorrencia_zerar
BEFORE UPDATE ON Avaliacao
FOR EACH ROW
BEGIN
  -- Só aplica quando a ocorrência passa a existir/ser preenchida e atende ao critério
  IF NEW.ocorrencia IS NOT NULL
     AND TRIM(NEW.ocorrencia) <> ''
     AND (OLD.ocorrencia IS NULL OR TRIM(OLD.ocorrencia) = '')
     AND NEW.ocorrencia REGEXP '(fraude|cola|plagio|indisciplina[ ]*grave)'
  THEN
    SET NEW.nota = 0.0;
  END IF;
END$$

DELIMITER ;

-- Questao 11
DELIMITER $$

-- Por ID de Aluno_Turma
CREATE FUNCTION fn_nota_final_aluno_turma(p_aluno_turma_id INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_media DECIMAL(4,2);
  DECLARE v_rec   DECIMAL(4,2);

  SELECT AVG(nota)
    INTO v_media
    FROM Avaliacao
   WHERE aluno_turma_id = p_aluno_turma_id
     AND tipo_prova IN ('P1','P2','P3','P4','P5');

  SELECT MAX(nota)
    INTO v_rec
    FROM Avaliacao
   WHERE aluno_turma_id = p_aluno_turma_id
     AND tipo_prova = 'Rec';

  IF v_media IS NULL AND v_rec IS NULL THEN
    RETURN 0.00;
  ELSEIF v_rec IS NULL THEN
    RETURN IFNULL(v_media, 0.00);
  ELSEIF v_media IS NULL THEN
    RETURN v_rec;
  ELSE
    RETURN GREATEST(v_media, v_rec);
  END IF;
END$$

-- Versão por chaves (aluno_matricula + turma_cod)
CREATE FUNCTION fn_nota_final(p_aluno_mat VARCHAR(10), p_turma_cod VARCHAR(12))
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_at_id INT;

  SELECT ID INTO v_at_id
    FROM Aluno_Turma
   WHERE aluno_mat = p_aluno_mat
     AND turma_cod = p_turma_cod
   LIMIT 1;

  IF v_at_id IS NULL THEN
    RETURN 0.00;
  END IF;

  RETURN fn_nota_final_aluno_turma(v_at_id);
END$$

DELIMITER ;

-- Questao 12
DELIMITER $$

CREATE PROCEDURE sp_aplicar_medidas_disciplinares(IN p_aluno_mat VARCHAR(10))
MODIFIES SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;
  DECLARE v_status_atual VARCHAR(32);

  SELECT COUNT(*)
    INTO v_total
    FROM Avaliacao av
    JOIN Aluno_Turma atur ON atur.ID = av.aluno_turma_id
   WHERE atur.aluno_mat = p_aluno_mat
     AND av.ocorrencia IS NOT NULL
     AND TRIM(av.ocorrencia) <> '';

  SELECT status INTO v_status_atual
    FROM Aluno
   WHERE matricula = p_aluno_mat
   LIMIT 1;

  IF v_status_atual IS NOT NULL THEN
    IF v_status_atual = 'suspenso' AND v_total >= 9 THEN
      UPDATE Aluno SET status = 'expulso' WHERE matricula = p_aluno_mat;
    ELSEIF v_total >= 3 THEN
      UPDATE Aluno SET status = 'suspenso' WHERE matricula = p_aluno_mat;
    END IF;
  END IF;
END$$

DELIMITER ;
