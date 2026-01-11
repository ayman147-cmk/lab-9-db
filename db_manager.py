import mysql.connector as mariadb
from mysql.connector import pooling
import os

class DatabaseManager:
    def __init__(self):
        self.config = {
            'host': 'localhost',
            'database': 'universite',
            'user': 'root',
            'password': '',
            'pool_name': 'pool_universite_v2',
            'pool_size': 5
        }
        self.pool = self._setup_pool()

    def _setup_pool(self):
        try:
            pool_instance = pooling.MySQLConnectionPool(**self.config)
            print(f"--- [Status] Pool '{self.config['pool_name']}' est prêt ---")
            return pool_instance
        except Exception as error:
            print(f"--- [Erreur] Échec de l'initialisation : {error} ---")
            return None

    def acquire_link(self):
        if self.pool:
            return self.pool.get_connection()
        return None

manager = DatabaseManager()

def get_db_connection():
    return manager.acquire_link()

if __name__ == "__main__":
    conn = get_db_connection()
    if conn and conn.is_connected():
        print(">>> Test de connectivité : Succès")
        conn.close()
    else:
        print(">>> Test de connectivité : Échec")