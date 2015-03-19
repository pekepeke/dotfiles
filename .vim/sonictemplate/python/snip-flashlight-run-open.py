def run(url):
    import os, pipes
    os.system('open "{0}"'.format(pipes.quote(url)))
