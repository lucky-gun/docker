from flask import Flask
import logging

logging.basicConfig(filename = "log/project.log", level = logging.DEBUG)
server = Flask(__name__)


@server.route('/search')
def hello_world():
    return 'hello elasticsearch2'
