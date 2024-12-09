"# Pacotes de Entidades

Este repositório contém a implementação de um conjunto de pacotes em PL/SQL para o Oracle, que realizam operações relacionadas às entidades Aluno, Disciplina e Professor.

## Pré-requisitos

- Oracle Database instalado
- Acesso a uma ferramenta de consulta SQL, como SQL Developer ou SQL*Plus

## Configuração do Banco de Dados

Antes de executar o script, certifique-se de ter as seguintes tabelas criadas no banco de dados:

- `alunos`: Tabela que armazena informações dos alunos
- `disciplinas`: Tabela que armazena informações das disciplinas
- `matriculas`: Tabela que armazena as matrículas dos alunos em disciplinas
- `professores`: Tabela que armazena informações dos professores
- `turmas`: Tabela que armazena informações das turmas

## Executando o Script

1. Abra sua ferramenta de consulta SQL e conecte-se ao banco de dados Oracle.
2. Copie o conteúdo do arquivo `pacotes_entidades.sql` e cole-o na área de consulta.
3. Execute o script.

## Pacotes Implementados

### PKG_ALUNO

- `delete_aluno`: Procedure que exclui um aluno e todas as suas matrículas associadas.
- `c_alunos_maiores_18`: Cursor que lista os alunos maiores de 18 anos.
- `c_alunos_por_curso`: Cursor parametrizado que lista os alunos matriculados em um curso específico.

### PKG_DISCIPLINA

- `insert_disciplina`: Procedure para cadastrar uma nova disciplina.
- `c_total_alunos_por_disciplina`: Cursor que lista o total de alunos por disciplina.
- `c_media_idade_por_disciplina`: Cursor parametrizado que calcula a média de idade dos alunos em uma disciplina.
- `list_alunos_disciplina`: Procedure que lista os alunos matriculados em uma disciplina.

### PKG_PROFESSOR

- `c_total_turmas_por_professor`: Cursor que lista o total de turmas por professor.
- `get_total_turmas_professor`: Function que retorna o total de turmas de um professor.
- `get_professor_disciplina`: Function que retorna o professor de uma disciplina."