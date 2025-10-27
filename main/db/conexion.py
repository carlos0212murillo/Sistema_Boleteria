import mysql.connector

def obtener_conexion():
    conexion = mysql.connector.connect(
        host="localhost",
        user="boleto_user",
        password="1234",
        database="sistema_boletos"
    )
    return conexion
