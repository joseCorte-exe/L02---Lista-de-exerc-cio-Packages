CREATE OR REPLACE PACKAGE PKG_ALUNO AS
  PROCEDURE delete_aluno(p_id_aluno IN NUMBER);
  
  CURSOR c_alunos_maiores_18 IS
    SELECT nome, data_nascimento
    FROM alunos
    WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;
  
  CURSOR c_alunos_por_curso(p_id_curso IN NUMBER) IS
    SELECT a.nome
    FROM alunos a
    JOIN matriculas m ON a.id_aluno = m.id_aluno
    WHERE m.id_curso = p_id_curso;
END PKG_ALUNO;
/

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
  PROCEDURE delete_aluno(p_id_aluno IN NUMBER) IS
  BEGIN
    DELETE FROM matriculas WHERE id_aluno = p_id_aluno;
    DELETE FROM alunos WHERE id_aluno = p_id_aluno;
    COMMIT;
  END delete_aluno;
END PKG_ALUNO;
/

CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
  PROCEDURE insert_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER);
  
  CURSOR c_total_alunos_por_disciplina IS
    SELECT d.nome AS disciplina, COUNT(m.id_aluno) AS total_alunos
    FROM disciplinas d
    LEFT JOIN matriculas m ON d.id_disciplina = m.id_disciplina
    GROUP BY d.nome
    HAVING COUNT(m.id_aluno) > 10;
  
  CURSOR c_media_idade_por_disciplina(p_id_disciplina IN NUMBER) IS
    SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
    FROM alunos a
    JOIN matriculas m ON a.id_aluno = m.id_aluno
    WHERE m.id_disciplina = p_id_disciplina;
    
  PROCEDURE list_alunos_disciplina(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;
/

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
  PROCEDURE insert_disciplina(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER) IS
  BEGIN
    INSERT INTO disciplinas (nome, descricao, carga_horaria)
    VALUES (p_nome, p_descricao, p_carga_horaria);
    COMMIT;
  END insert_disciplina;
  
  PROCEDURE list_alunos_disciplina(p_id_disciplina IN NUMBER) IS
    CURSOR c_alunos_disciplina IS
      SELECT a.nome
      FROM alunos a
      JOIN matriculas m ON a.id_aluno = m.id_aluno
      WHERE m.id_disciplina = p_id_disciplina;
  BEGIN
    FOR aluno IN c_alunos_disciplina LOOP
      DBMS_OUTPUT.PUT_LINE(aluno.nome);
    END LOOP;
  END list_alunos_disciplina;
END PKG_DISCIPLINA;
/

CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
  CURSOR c_total_turmas_por_professor IS
    SELECT p.nome AS professor, COUNT(t.id_turma) AS total_turmas
    FROM professores p
    LEFT JOIN turmas t ON p.id_professor = t.id_professor
    GROUP BY p.nome
    HAVING COUNT(t.id_turma) > 1;
    
  FUNCTION get_total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
  FUNCTION get_total_turmas_professor(p_id_professor IN NUMBER) RETURN NUMBER IS
    v_total_turmas NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_total_turmas
    FROM turmas
    WHERE id_professor = p_id_professor;
    
    RETURN v_total_turmas;
  END get_total_turmas_professor;
  
  FUNCTION get_professor_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
    v_nome_professor VARCHAR2(100);
  BEGIN
    SELECT p.nome INTO v_nome_professor
    FROM professores p
    JOIN turmas t ON p.id_professor = t.id_professor
    JOIN disciplinas d ON t.id_disciplina = d.id_disciplina
    WHERE d.id_disciplina = p_id_disciplina;
    
    RETURN v_nome_professor;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_professor_disciplina;
END PKG_PROFESSOR;
/