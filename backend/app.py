from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hey, selam yabancı. Eskiden buralar dutluktu!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

