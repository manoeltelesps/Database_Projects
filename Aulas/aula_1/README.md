# 📚 Aula 1 — Modelagem de Biblioteca

Script de criação do banco `Biblioteca`, com tabelas para autores, livros, empréstimos (`Aluga`) e pessoas. Modela os relacionamentos entre um autor e seus livros (1:N) e o vínculo de uma pessoa com seus empréstimos, usando chaves estrangeiras com `on update cascade` e `on delete restrict`. Inclui inserções de exemplo e consultas simples de conferência.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `bibliotecabd.sql` | Cria o banco `Biblioteca` e as tabelas `Autor`, `Livro`, `Aluga` e `Pessoa`, com dados de exemplo |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
