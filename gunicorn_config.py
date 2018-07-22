from multiprocessing import cpu_count
#from os import environ

def max_workers():
    return cpu_count()

#bind = '0.0.0.0:' + environ.get('PORT', '5000')
bind = '0.0.0.0:8000'
#workers = max_workers() // 2
workers = 2
worker_class = 'gevent'
worker_connections = 100
timeout = 30
keepalive = 5

#daemon = True
spew = False
#pidfile='gunicorn_pid'

errorlog = '-'
loglevel = 'info'
accesslog = '-'
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

def post_fork(server, worker):
    server.log.info("Worker spawned (pid: %s)", worker.pid)

def pre_fork(server, worker):
    pass

def pre_exec(server):
    server.log.info("Forked child, re-executing.")

def when_ready(server):
    server.log.info("Server is ready. Spawning workers")

def worker_int(worker):
    worker.log.info("worker received INT or QUIT signal")

def worker_abort(worker):
    worker.log.info("worker received SIGABRT signal")

