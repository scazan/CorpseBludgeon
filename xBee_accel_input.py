"""
CorpseBludgeon Interface
by Casey Anderson

Read the serial port and process IO data received from a remote XBee.
XBee transmits information from 3-axis acceleromter on adc-0, adc-1, and adc-2.
Sends info to Processing via OSC

python-xbee package is here: http://code.google.com/p/python-xbee/

Usage: Connect local XBee, turn remote XBee on, run the listener in Processing, then run this to send
"""

from xbee import XBee
import serial
import OSC
import sys

# setup xbee
ser = serial.Serial('/dev/tty.usbserial-A4011813', 9600)	# find a way to automate this
xbee = XBee(ser)

#setup OSC
pPort = 12000
client = OSC.OSCClient()
client.connect( ( '127.0.0.1', pPort ) )
msg = OSC.OSCMessage()
msg.setAddress("/accel")
msg.append(0)
msg.append(0)
msg.append(0)

# Continuously read
while True:
	try:
		response = xbee.wait_read_frame()				# print response (for everything)
		adc0 = response.get('samples')[0].get('adc-0')
		adc1 = response.get('samples')[0].get('adc-1')
		adc2 = response.get('samples')[0].get('adc-2')
		msg[0] = adc0
		msg[1] = adc1
		msg[2] = adc2
		client.send(msg)
	except KeyboardInterrupt:							# keyboard interrupt stops the process
		break
	except:												# catches errors to prevent infinite loops
		ser.close()
		print sys.exc_info()[0]
		break
        
ser.close()