def run(arg1):
	import subprocess, sys
	pid = subprocess.Popen([sys.executable, "xxx.py", arg1], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)

