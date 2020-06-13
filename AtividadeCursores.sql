CREATE DATABASE AtividadeCursores
GO
USE AtividadeCursores

CREATE TABLE curso(
cod INT NOT NULL,
nome VARCHAR(50) NOT NULL,
duracao INT
PRIMARY KEY (cod)
)

INSERT INTO curso VALUES
(0, 'An�lise e Desenvolvimento de Sistema', 2880),
(1, 'Log�stica', 2880),
(2, 'Pol�meros', 2880),
(3, 'Com�rcio Exterior', 2600),
(4, 'Gest�o Empresarial', 2600)

CREATE TABLE disciplinas(
cod INT IDENTITY NOT NULL,
nome VARCHAR(50) NOT NULL,
carga_horaria INT NOT NULL
PRIMARY KEY (cod)
)

INSERT INTO disciplinas VALUES
('Algoritmos', 80),
('Administra��o', 80),
('Laborat�rio de Hardware', 40),
('Pesquisa Operacional', 80),
('F�sica I', 80),
('F�sico Qu�mica', 80),
('Com�rcio Exterior', 80),
('Fundamentos de Marketing', 80),
('Inform�tica', 40),
('Sistema de Informa��o', 80)

CREATE TABLE disciplina_curso(
cod_disciplina INT NOT NULL,
cod_curso INT NOT NULL
CONSTRAINT pk_disc_curso PRIMARY KEY (cod_disciplina, cod_curso)
)

INSERT INTO disciplina_curso VALUES
(1, 0),
(2, 0),
(2, 1),
(2, 3),
(2, 4),
(3, 0),
(4, 1),
(5, 2),
(6, 2),
(7, 1),
(7, 3),
(8, 1),
(8, 4),
(9, 1),
(9, 3),
(10, 0),
(10, 4)

GO
CREATE FUNCTION fn_tabela_curso(@cod INT)
RETURNS @tabela TABLE(
cod_disc INT,
nome_disc VARCHAR(50),
ch_disc INT,
nome_curso VARCHAR(50))
AS
BEGIN
	DECLARE @cod_curso INT,
			@cod_disc INT,
			@nome_disc VARCHAR(50),
			@ch_disc INT,
			@nome_curso VARCHAR(50)

	SET @nome_curso = (SELECT nome FROM curso WHERE cod = @cod)

	DECLARE cursor_busca CURSOR FOR
		SELECT cod_disciplina, cod_curso FROM disciplina_curso

	OPEN cursor_busca
	FETCH NEXT FROM cursor_busca INTO @cod_disc, @cod_curso
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(@cod_curso = @cod)
				BEGIN
					SET @nome_disc = (SELECT nome FROM disciplinas WHERE cod = @cod_disc)
					SET @ch_disc = (SELECT carga_horaria FROM disciplinas WHERE cod = @cod_disc)
					INSERT INTO @tabela VALUES
					(@cod_disc, @nome_disc, @ch_disc, @nome_curso)
				END
			FETCH NEXT FROM cursor_busca INTO @cod_disc, @cod_curso
		END
	CLOSE cursor_busca
	DEALLOCATE cursor_busca
	RETURN
END

SELECT * FROM dbo.fn_tabela_curso(0)
SELECT * FROM dbo.fn_tabela_curso(1)
SELECT * FROM dbo.fn_tabela_curso(2)
SELECT * FROM dbo.fn_tabela_curso(3)
SELECT * FROM dbo.fn_tabela_curso(4)