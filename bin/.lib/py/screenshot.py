from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice
import sys
device = MonkeyRunner.waitForConnection()
result = device.takeSnapshot()
result.writeToFile(sys.argv[1],'png')
