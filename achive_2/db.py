import sqlalchemy 

db_string = 'postgres://user:pass@localhost:5432/rvs'
db = sqlalchemy.create_engine(db_string)

db.execute('CREATE TABLE IF NOT EXISTS numbers (num integer PRIMARY KEY)')  

def insert_num(num):
    try:
        db.execute(f'INSERT INTO numbers (num) values ({num})')
    except sqlalchemy.exc.IntegrityError as e:
        return False
    return True

def get_num(num):
    result_set = db.execute(f'SELECT num from numbers WHERE numbers.num={num} or numbers.num={num-1}')
    res = [r[0] for r in result_set]
    res.sort()
    return res

def get_all_num():
    result_set = db.execute('SELECT * FROM numbers')  
    res = [r[0] for r in result_set]
    res.sort()
    return res

