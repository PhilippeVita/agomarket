from src.db import get_connection

def main():
    conn = get_connection()
    print("Connexion OK :", conn)
    conn.close()

if __name__ == "__main__":
    main()
    

# Ce script teste la connexion à la base de données PostgreSQL 
# en utilisant la fonction get_connection() définie dans src.db : 

# $>> python src/scripts/test_connection.py
# -OU-
# $>> python -m src.scripts.test_connection

# Si la connexion est réussie, il affiche un message de confirmation et ferme la connexion.

