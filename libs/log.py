import logging
import logging.handlers
import os


filename = 'running.log'


def log(logger_name):
    level = logging.DEBUG if os.environ.get('DEBUG', False) else logging.INFO
    fmt = '[%(levelname)1.1s %(asctime)s %(name)s:%(lineno)d] %(message)s'
    logging.basicConfig(
        level=level,
        format=fmt,
        datefmt='%y%m%d %H:%M:%S',
        filename=filename,filemode='w'
    )
    return logging.getLogger(logger_name)
