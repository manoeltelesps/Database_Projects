CREATE DATABASE IF NOT EXISTS Livraria;
USE Livraria;

-- Tabelas

CREATE TABLE IF NOT EXISTS Autor(
	ID int primary key auto_increment,
    Nome varchar(200) unique not null
);

CREATE TABLE IF NOT EXISTS Livro(
	ISBN decimal(13) primary key,
    Titulo varchar(50) not null,
    Ano smallint,
    
    ID_autor int not null,
    
    constraint FK_Livro_Autor foreign key (ID_autor) references Autor(ID) -- Autor pode ter mais de um livro, livro só pode ser de um autor
    on update cascade -- Se atualizar o nome do autor, todas tabelas atualizam
    on delete restrict -- Se deletar o autor os livros que ele escreveu nao pode apagar
);

CREATE TABLE IF NOT EXISTS Pessoa(
	ID int primary key auto_increment,
    CPF decimal (11,0) unique not null,
    Nome varchar(200) not null,
	Data_nasc date not null,
    Saldo decimal (12,2) not null default 0.00
);

-- Tabela Relacionamentos

CREATE TABLE IF NOT EXISTS Emprestimo(
	ID int primary key auto_increment,
    Data_empres timestamp not null default current_timestamp, -- Se não inseriu a dara de empréstimo é colocada atual
    Date_devo timestamp,
    ISBN_livro decimal(13) not null,
    ID_pessoa int not null,
    
    
    constraint FK_Pessoa_Emprestimo foreign key (ID_pessoa) references Pessoa(ID),
    constraint FK_Livro_Emprestimo foreign key (ISBN_livro) references Livro(ISBN) on delete cascade -- On delete vem no filho
);

-- Inserções

insert into Autor(nome) value ("Machado de Assis");

insert into Livro (ISBN,titulo, ano, ID_autor) values ("1111222233334", "Dom Casmurro", 1899, 1);
insert into Livro (ISBN,titulo, ano, ID_autor) values ("1111222233335", "O Alienista", 1882, 1);

INSERT INTO Pessoa(CPF, Nome, Data_nasc) VALUES ("10522429521", "Manoel", "2004-07-31");

select * from Pessoa