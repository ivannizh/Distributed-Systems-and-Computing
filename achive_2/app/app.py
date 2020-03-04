from flask import Flask
from flask import request
from flask import make_response
from flask import jsonify
import json

import db
# from db import insert_num, get_all_num, get_num


app = Flask(__name__)
app.config['SECRET_KEY'] = 'you-will-never-guess'

print('asdasdasd')

@app.route('/', methods=['POST'])
def get_inc():
    num = 0
    try:
        data = json.loads(request.data)
        print(data)
    except Exception:
        ans = { 'status': 400, 'msg': 'Bad Request. Not valid json.' }
        return make_response(jsonify(ans), 400)
    
    num = data.get('num', None)

    if num is None:
        ans = { 'status': 400, 'msg': 'Bad Request. Can\'t find \'num\' field.' }
        return make_response(jsonify(ans), 400)

    if type(num) is not int:
        ans = { 'status': 400, 'msg': 'Bad Request. Number is not int' }
        return make_response(jsonify(ans), 400)

    nums = db.get_num(num)

    if num in nums:
        ans = { 'status': 409, 'msg': 'Conflict. This number already was.' }
        return make_response(jsonify(ans), 409)

    if (num + 1) in nums:
        ans = { 'status': 409, 'msg': 'Conflict. number - 1 already was.' }
        return 

    if not db.insert_num(num):
        raise Exception('Uncought error')

    ans = { 'num': num + 1, 'status': 201, 'msg': 'Created.'  }

    return make_response(jsonify(ans), 200)

if __name__ == '__main__':
    print("as")
    app.run(debug=True)