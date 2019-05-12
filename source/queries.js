// Mostrar todas as consultas
db.consultas.find().pretty();

// mostra info de todos os utentes
db.utentes.find().pretty();

// Mostra todos os PS
db.profissionais.find().pretty();

// mostra info de todos os medicamentos 
db.consultas.distinct( "Receitas.medicamento")

// apresenta todas as pessoas que já faleceram 
db.utentes.find({"DtObito":{$ne:"None"}} , {"Nome" : 1, "Nr" : 1, "DtObito": 1});

// lista de receitas emitidas por determinado PS
db.consultas.distinct("Receitas.Receita",{"Medico_id" : 34563})

// Implementação um procedure que, dado o ID de um profissional de saúde, apresente as consultas a si associadas
db.consultas.find({"Medico_id" : 34563}).pretty()

// implementação um procedimento que, dado um ID de um utente, apresente o seu histórico clínico 
db.consultas.find({"Utente_id" : 654678, "Estado" : 3}, {"_id" : 1, "Descricao" : 1, "Data" : 1}).pretty()