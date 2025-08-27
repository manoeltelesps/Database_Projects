create database if not exists SistemaEscolar;
use SistemaEscolar;

create table if not exists Pessoa(
	CPF varchar(11) unique not null,
    Nome varchar(100) not null,
    Data_nasc date not null
);

create table if not exists Aluno(
    Matricula varchar(11) primary key,
    Entrada date,
	Ativo boolean not null,
    CPF_pessoa varchar(11) unique not null,
    
    constraint FK_Aluno_Pessoa
    foreign key(CPF_pessoa) references Pessoa(CPF)
);

create table if not exists Curso(
	Codigo varchar(11) primary key,
	Nome varchar(100) unique not null
);

create table if not exists Turma(
	Codigo varchar(11) primary key,
    Semestre int not null
);

create table if not exists Autor(
	ID varchar(11) primary key,
    CPF_pessoa varchar(11) unique not null,
    
    constraint FK_Autor_Pessoa
    foreign key(CPF_pessoa) references Pessoa(CPF)
);

create table if not exists Livro(
	ISBN int primary key,
    Titulo varchar(50) not null,
    Ano int,
    Editor varchar(50) not null
);


-- Tabelas de Relacionamentos

create table if not exists AlunoCursoTurma (
	Matricula_aluno varchar(11) unique not null,
    Codigo_curso varchar(11) unique not null,
    Codigo_turma varchar(11) unique not null,
	
    constraint PK_Aluno_Curso_Turma primary key(Matricula_aluno, Codigo_curso, Codigo_turma),
    constraint FK_Aluno_AlunoCursoTurma foreign key (Matricula_aluno) references Aluno(Matricula),
    constraint FK_Curso_AlunoCursoTurma foreign key (Codigo_curso) references Curso(Codigo),
    constraint FK_Turma_AlunoCursoTurma foreign key (Codigo_turma) references Turma(Codigo)
);

create table if not exists CursoTurma(
	Codigo_curso varchar(11) unique not null,
    Codigo_turma varchar(11) unique not null,
    
    constraint PK_Curso_Turma primary key(Codigo_curso, Codigo_turma),
    constraint FK_Curso_CursoTurma foreign key(Codigo_curso) references Curso(Codigo),
    constraint FK_Turma_CursoTurma foreign key(Codigo_turma) references Turma(Codigo)
);

create table if not exists AutoriaLivro(
    ID_autor varchar(11) unique not null,
    ISBN_livro int unique not null,

	constraint PK_Autor_Livro primary key(ID_autor, ISBN_livro),
    constraint FK_Autor_AutoriaLivro foreign key (ID_autor) references Autor(ID),
    constraint FK_Livro_AutoriaLivro foreign key (ISBN_livro) references Livro(ISBN)
);

create table if not exists Emprestimo (
    ID int auto_increment primary key,
    Data_empres date not null,
    Data_devol date not null,
    ISBN_livro int not null,
    Matricula_aluno varchar(11) not null,
    
    constraint FK_Livro_Emprestimo foreign key (ISBN_livro) references Livro(ISBN),
    constraint FK_Aluno_Emprestimo foreign key (Matricula_aluno) references Aluno(Matricula),
    constraint UC_Emprestimo unique (ISBN_livro, Matricula_aluno)
);

-- Inserindo Pessoas
INSERT INTO Pessoa (CPF, Nome, Data_nasc) VALUES
('11111111111', 'João Silva', '2000-01-15'),
('22222222222', 'Maria Oliveira', '1999-05-20'),
('33333333333', 'Carlos Santos', '2001-09-10');

-- Inserindo Alunos
INSERT INTO Aluno (Matricula, Entrada, Ativo, CPF_pessoa) VALUES
('A001', '2023-02-01', TRUE, '11111111111'),
('A002', '2022-08-15', TRUE, '22222222222'),
('A003', '2023-01-10', FALSE, '33333333333');

-- Inserindo Cursos
INSERT INTO Curso (Codigo, Nome) VALUES
('C001', 'Engenharia'),
('C002', 'Medicina'),
('C003', 'Direito');

-- Inserindo Turmas
INSERT INTO Turma (Codigo, Semestre) VALUES
('T001', 1),
('T002', 2),
('T003', 3);

-- Inserindo Autores
INSERT INTO Autor (ID, CPF_pessoa) VALUES
('AU001', '11111111111'),
('AU002', '22222222222'),
('AU003', '33333333333');

-- Inserindo Livros
INSERT INTO Livro (ISBN, Titulo, Ano, Editor) VALUES
(1001, 'Matemática Avançada', 2020, 'Editora Alfa'),
(1002, 'Anatomia Humana', 2019, 'Editora Beta'),
(1003, 'Direito Constitucional', 2021, 'Editora Gama');

-- Inserindo AlunoCursoTurma
INSERT INTO AlunoCursoTurma (Matricula_aluno, Codigo_curso, Codigo_turma) VALUES
('A001', 'C001', 'T001'),
('A002', 'C002', 'T002'),
('A003', 'C003', 'T003');

-- Inserindo CursoTurma
INSERT INTO CursoTurma (Codigo_curso, Codigo_turma) VALUES
('C001', 'T001'),
('C002', 'T002'),
('C003', 'T003');

-- Inserindo AutoriaLivro
INSERT INTO AutoriaLivro (ID_autor, ISBN_livro) VALUES
('AU001', 1001),
('AU002', 1002),
('AU003', 1003);

-- Inserindo Emprestimos
INSERT INTO Emprestimo (Data_empres, Data_devol, ISBN_livro, Matricula_aluno) VALUES
('2023-08-01', '2023-08-15', 1001, 'A001'),
('2023-08-05', '2023-08-20', 1002, 'A002'),
('2023-08-10', '2023-08-25', 1003, 'A003');

-- Conferir Pessoas
SELECT * FROM Pessoa;

-- Conferir Alunos
SELECT * FROM Aluno;

-- Conferir Cursos
SELECT * FROM Curso;

-- Conferir Turmas
SELECT * FROM Turma;

-- Conferir Autores
SELECT * FROM Autor;

-- Conferir Livros
SELECT * FROM Livro;

-- Conferir AlunoCursoTurma
SELECT * FROM AlunoCursoTurma;

-- Conferir CursoTurma
SELECT * FROM CursoTurma;

-- Conferir AutoriaLivro
SELECT * FROM AutoriaLivro;

-- Conferir Emprestimos
SELECT * FROM Emprestimo;