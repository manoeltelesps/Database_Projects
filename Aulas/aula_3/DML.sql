use Livraria;

-- 1.
SELECT DISTINCT nome 
FROM autor ;

-- 2.
SELECT titulo
FROM livro;

-- 3.
SELECT *
FROM PESSOA
WHERE SALDO = 0;

-- 4.
SELECT *
FROM PESSOA
WHERE TIMESTAMPDIFF(YEAR, Data_nasc, CURDATE()) < 18;

-- 5.
SELECT A.nome, L.titulo
FROM Autor A
INNER JOIN Livro L
	ON A.ID = L.ID_Autor;
    
-- 6.
SELECT A.nome
FROM Autor A
LEFT JOIN Livro L
	ON A.ID = L.ID_Autor
    WHERE L.ISBN IS NULL;
    
-- 7.
SELECT P.Nome, L.titulo
FROM Pessoa P
JOIN Emprestimo E 
	ON P.ID = E.ID_Pessoa 
JOIN Livro L 
	ON L.ISBN = E.ISBN_Livro;
    
-- 8.
SELECT COUNT(ISBN) AS qnt
	FROM Livro L
    JOIN Autor A
		ON L.ID_Autor = A.ID
GROUP BY A.nome;
        
-- 9.
SELECT A.Nome, COUNT(L.ISBN) AS qnt
	FROM Autor A
	LEFT JOIN Livro L 
		ON L.id_autor = A.ID
			GROUP BY A.ID, A.Nome
			ORDER BY qnt DESC;

-- 10.
SELECT P.CPF, P.Nome, COUNT(L.ISBN) AS qnt
	FROM Pessoa P
	JOIN Emprestimo E 
		ON P.ID   = E.ID_Pessoa
	JOIN Livro L 
		ON L.ISBN = E.ISBN_Livro
        
WHERE E.Data_empres BETWEEN '2024-01-01' AND '2025-12-31 23:59:59'
GROUP BY P.CPF, P.Nome
ORDER BY qnt DESC;


