from flask import Flask, request, jsonify
from flask_cors import CORS
import logging

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO)

response_data = {
    "status_code": "0000",
    "status_description": "Success",
    "ref_id": "20230514170000000031",
    "result": {
        "ref1": "8800000000",
        "amount": 50000,
        "fee": 25000,
        "invoice_list": [
            {
                "id": "WL-2023-04-01",
                "date": "2023-04-01",
                "amount": 12400,
                "fee": 20000,
            },
            {
                "id": "WL-2023-05-01",
                "date": "2023-05-01",
                "amount": 37600,
                "fee": 0,
            },
            {
                "id": "SERVICE_FEE",
                "date": "2023-05-14",
                "amount": 0,
                "fee": 5000,
            }
        ]
    }
}

response_data_validate = {
    "status_code": "0000",
    "status_description": "Success",
    "ref_id": "20230514170000000031",
    "result": {
        "ref1": "8800000000",
        "amount": 50000,
        "fee": 25000,
    }
}

response_data_confirm = {
    "status_code": "0000",
    "status_description": "Success",
    "ref_id": "20230514170000000031",
    "result": {
        "txn_id": "1111284099",
        "txn_dt": "2023-05-14T08:00:00+07:00",
        "amount": 50000,
        "fee": 25000,
        "ref1": "8800000000",
        "ref2": "0999999999",
        "ref3": "0123456789",
        "ref4": "0123456789",
        "ref5": "0123456789",
        "ref6": "0123456789",
    },
}

@app.route('/your-query', methods=['POST'])
def your_query():
    try:
        rabbit_id = request.headers.get('X-Rabbit-ID')
        rabbit_datetime = request.headers.get('X-Rabbit-Datetime')
        rabbit_auth = request.headers.get('X-Rabbit-Auth')
        
        # Log the received headers
        app.logger.info(f"Headers received: X-Rabbit-ID={rabbit_id}, X-Rabbit-Datetime={rabbit_datetime}, X-Rabbit-Auth={rabbit_auth}")
        
        return jsonify(response_data), 200
    except Exception as e:
        app.logger.error(f"Error in /your-query: {e}")
        return jsonify({"status_code": "9999", "status_description": "Error"}), 500

@app.route('/your-validate', methods=['POST'])
def your_validate():
    try:
        rabbit_id = request.headers.get('X-Rabbit-ID')
        rabbit_datetime = request.headers.get('X-Rabbit-Datetime')
        rabbit_auth = request.headers.get('X-Rabbit-Auth')
        
        # Log the received headers
        app.logger.info(f"Headers received: X-Rabbit-ID={rabbit_id}, X-Rabbit-Datetime={rabbit_datetime}, X-Rabbit-Auth={rabbit_auth}")
        
        return jsonify(response_data_validate), 200
    except Exception as e:
        app.logger.error(f"Error in /your-validate: {e}")
        return jsonify({"status_code": "9999", "status_description": "Error"}), 500

@app.route('/your-confirm', methods=['POST'])
def your_confirm():
    try:
        rabbit_id = request.headers.get('X-Rabbit-ID')
        rabbit_datetime = request.headers.get('X-Rabbit-Datetime')
        rabbit_auth = request.headers.get('X-Rabbit-Auth')
        
        # Log the received headers
        app.logger.info(f"Headers received: X-Rabbit-ID={rabbit_id}, X-Rabbit-Datetime={rabbit_datetime}, X-Rabbit-Auth={rabbit_auth}")
        
        return jsonify(response_data_confirm), 200
    except Exception as e:
        app.logger.error(f"Error in /your-confirm: {e}")
        return jsonify({"status_code": "9999", "status_description": "Error"}), 500

if __name__ == '__main__':
    app.run(debug=True)
