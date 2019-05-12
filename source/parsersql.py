import datetime
import mysql.connector
from pymongo import MongoClient

client     = MongoClient()
db         = client.test
collection = db.utentes

cnx        = mysql.connector.connect( 
                                     user     ='root', 
                                     password ='', 
                                     database ='CentroSaude')
cursor     = cnx.cursor()

# Utentes

row_titles = (
        '_Nr', 'Profissao', 'Nome', 
        'Sexo', 'Dador', 'DtNascimento', 
        'FaixaEtaria', 'Rua', 'Cidade', 'Numero', 
        'DtObito', 'Incapacidades', 'Contactos'          
)

query = ( "SELECT " 
          
          "* FROM Utente" )

cursor.execute( query )
                                                
for ( row ) in cursor:
    collection.insert({"_id" : int(row[0]), "Profissao" : row[1], "Nome" : row[2], "Sexo" : row[3], "Dador" : int(row[4]), "DtNascimento" : str(row[5]), "FaixaEtaria" : row[6], "Rua" : row[7], "Cidade" : row[8], "Numero" : int(row[9]), "DtObito" : str(row[10])})


query2 = ("SELECT "
  "U.Nr, UC.Contacto "
  "FROM Utente U " 
    "Inner Join Contacto_Utente UC "
    "ON UC.Utente = U.Nr"
  )

cursor.execute(query2)

for( row ) in cursor:
  collection.update({"_id" : int(row[0])}, {'$addToSet' : {"Contactos" : str(row[1])}})


query3 = ("SELECT " 
  "U.Nr, I.Descricao "
    "FROM Utente U " 
    "Inner Join Utente_Incapacitado UI " 
        "ON U.Nr = UI.Utente "
      "Inner Join Incapacidade I "
            "On I.Id = UI.Incapacidade"
  )

cursor.execute(query3)

for( row ) in cursor:
  collection.update({"_id" : int(row[0])}, {'$addToSet' : {"Incapacidades" : str(row[1])}})



# Medicos
collection2 = db.profissionais

row_titles = (
        '_id', 'Nome', 'Sexo', 'Salario', 'Especialidade'
)

query4 = ( "SELECT "
      "P.CC, P.Nome, P.Sexo, P.Salario, E.Descricao " 
        "FROM Profissional_Saude P " 
          "INNER JOIN Especialidade E " 
          "ON P.Especialidade = E.Id"
    )

cursor.execute( query4 )


for ( row ) in cursor:
    collection2.insert({"_id" : int(row[0]), "Nome" : row[1], "Sexo" : row[2], "Salario" : int(row[3]), "Especialidade" : str(row[4])})


query5 = ("SELECT "
  "P.CC, PC.Contacto "
  "FROM Profissional_Saude P " 
    "Inner Join Contacto_PS PC "
    "ON PC.PS = P.CC"
  )

cursor.execute(query5)

for( row ) in cursor:
  collection2.update({"_id" : int(row[0])}, {'$addToSet' : {"Contactos" : row[1]}})



# Consultas 
collection3 = db.consultas
 
row_titles = (
              'Data', 'HoraEntrada',
              'HoraSaida', 'Duracao', 'Descricao', 'Estado', 'Preco', 'Utente_Nr', 'Medico_CC'
)

query6 = ( "SELECT "
      "C.Id, C.Data, C.HoraEntrada, C.HoraSaida, C.Duracao, C.Descricao, C.Estado, P.Preco, P.Utente, P.PS " 
        "FROM Consulta C INNER JOIN PUC P "
        "ON P.Consulta = C.Id" 
    )

cursor.execute( query6 )



for ( row ) in cursor:
    
    collection3.insert({"_id" : int(row[0]), "Data" : str(row[1]), "HoraEntrada" : str(row[2]), "HoraSaida" : str(row[3]), "Duracao" : str(row[4]), "Descricao" : str(row[5]), "Estado" : int(row[6]), "Preco" : float(row[7]), "Utente_id" : int(row[8]), "Medico_id" : int(row[9])})


# Receitas 

query7 = ( "SELECT "
  "C.Id AS Consulta, R.Id, M.Nome, M.Descricao, RC.Posologia "
  "FROM Receita R "
    "Inner join Medicamento_Receita RC "
    "ON RC.Receita = R.Id "
      "Inner join Medicamento M "
      "ON M.Id = RC.Medicamento "
        "Inner join Consulta C "
        "ON R.Consulta = C.Id"
    )

cursor.execute( query7 )

cus = dict()

for( row ) in cursor:
  collection3.update({"_id": row[0]}, {'$push': {"Receitas": {"Receita": (row[1]), "medicamento": (row[2]), "descricao": str(row[3]), "posologia": int(row[4])}}})
  

cursor.close()
cnx.close()









