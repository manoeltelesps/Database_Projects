use Livraria;

insert into Autor (Nome)
value
("J. K. Rowling"), ("Yoshihiro Togashi");

insert into Livro(ISBN, Titulo, Ano, ID_autor)
values 
("9788869183157", "Harry Potter and the Philosopher's Stone", 1997, 4), ("9788831000154", "Harry Potter and the Chamber of Secrets", 2002, 4),
("8577870405", "Hunter x Hunter", 1998, 5), ("8577870406","Yu Yu Hakusho", 1990, 5);

insert into Pessoa(CPF, Nome, Data_nasc)
values
("51829643007", "Tiago", "2003-05-09"), ("30217498561", "Pietro", "2016-09-01");


insert into Emprestimo(ISBN_livro, ID_pessoa)
values
('1111222233334', 2);


select * from Emprestimo;

delete from Livro
where ISBN = '1111222233334';



