import logging
from flask import Flask

app = Flask(__name__)
logging.basicConfig(level=logging.DEBUG)

@app.route('/')
def hello():
    app.logger.info('main request successfull')
    return "Hey, selam yabancı. Eskiden buralar dutluktu!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

