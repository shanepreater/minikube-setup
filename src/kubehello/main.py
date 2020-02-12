from os import environ

from uvicorn import run


def start(port=None, reload=None, colours=None):
    """
    Start the server using uvicorn.

    :param int port: The port to start on, default is the ENV VAR SERVER_PORT
    :param bool reload: Auto reload the app when it changes. Default ENV VAR AUTO_RELOAD
    :param bool colours: Use multi colours on the console. Default ENV VAR USE_COLOURS
    """
    if not port:
        port = int(environ.get('SERVER_PORT', '8000'))
    if not reload:
        reload = bool(environ.get('AUTO_RELOAD', 'no'))
    if not colours:
        colours = bool(environ.get('USE_COLOURS', 'no'))

    run('kubehello.app:app', port=port, reload=reload, use_colors=colours)


def hello_world():
    print('Hello world')


if __name__ == '__main__':
    start(reload=True, colours=True)
