import sqlalchemy 
import psycopg2
import os

DB_USER = os.getenv('DB_USER')
DB_PASS = os.getenv('DB_PASS')
DB_URL  = os.getenv('DB_URL')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')

print('aaaaaaaaaaaaaaaaaaaaaa', DB_PORT)

if  DB_USER is None or DB_PASS is None or DB_URL  is None or DB_PORT is None or DB_NAME is None:
    exit(1)

db_string = f'postgres://{DB_USER}:{DB_PASS}@{DB_URL}:{DB_PORT}/{DB_NAME}'
db = sqlalchemy.create_engine(db_string)

db.execute('CREATE TABLE IF NOT EXISTS numbers (num integer PRIMARY KEY)')  

def insert_num(num):
    try:
        db.execute(f'INSERT INTO numbers (num) values ({num})')
    except sqlalchemy.exc.IntegrityError as e:
        return False
    return True

def get_num(num):
    result_set = db.execute(f'SELECT num from numbers WHERE numbers.num={num} or numbers.num={num+1}')
    res = [r[0] for r in result_set]
    res.sort()
    return res

def get_all_num():
    result_set = db.execute('SELECT * FROM numbers')  
    res = [r[0] for r in result_set]
    res.sort()
    return res

