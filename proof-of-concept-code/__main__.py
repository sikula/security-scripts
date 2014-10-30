#!/usr/bin/env python
#----------------------------------
import os
import sys
import time
import json
import codecs
import datetime
import subprocess

#-----------------------------------------------------------------------------------------------------
# Handles the opening, reading and parsing of the JSON file which contains all the enumerations,
# categories and commands/messages
#-----------------------------------------------------------------------------------------------------
class JsonHelper:
    def __init__(self):
        #with codecs.open(str(options.command_list), 'rU', 'utf-8') as json_data:
        with codecs.open(str("resources/command_list.json"), 'rU', 'utf-8') as json_data:
            self.json_data    = json.load(json_data)


    def get_json(self):
        return self.json_data


#-----------------------------------------------------------------------------------------------------
# Mimics the the *nix 'tee' command.  prints output to file and STDOUT
#-----------------------------------------------------------------------------------------------------
class Tee(object):
    def __init__(self, *files):
        self.files = files

    def write(self, obj):
        for f in self.files:
            f.write(obj)


#-----------------------------------------------------------------------------------------------------
# Handles proper output formatting
#-----------------------------------------------------------------------------------------------------
class FormatHelper:
    def _big_title(self, msg):
        print "\n"
        print "[ + ] " + msg
        print "-" * 77


    def error(self, text):
        print "    [ ! ] " + text


    def file_header(self):
        current_time    = time.strftime("%Y/%m/%d %H:%M:%S", time.gmtime())
        print "=" * 80
        print "{0:<15s} : {1:15s}".format("Date/Start Time" , current_time)
        print "{0:<15s} : {1:15s}".format("Command Line"    , " ".join(sys.argv))
        print "{0:<15s} : {1:15s}".format("Filename"        , options.output_file)
        print "{0:<15s} : {1:15s}".format("Hostname"        , os.environ["HOSTNAME"])
        print "=" * 80


    def _print_cmd(self, output):
        if options.forest:
            print "  |> ", output.rstrip()


#-----------------------------------------------------------------------------------------------------
# Handles the execution and processing of the commands that are to be executed
#-----------------------------------------------------------------------------------------------------
class CommandRunner:
    def __init__(self):
        self.json_helper    = JsonHelper()
        self.json           = self.json_helper.get_json()
        self.formatter      = FormatHelper()


    def get_enumerations(self):
        enumerations = []
        for item in range(0, len(self.json), 2):
            enumerations.append(self.json[item])
        return "\n".join(enumerations)


    def cmd_exec(self, enumeration):
        for category in self.json[enumeration]:
            command     = self.json[enumeration][category]["cmd"]
            message     = self.json[enumeration][category]["msg"]
            self.formatter._big_title(message)
            try:
                results = subprocess.check_output(command, stderr=subprocess.PIPE, shell=True, universal_newlines=True);
            except subprocess.CalledProcessError as exc:
                self.formatter.error("Root priveleges probably required")
            else:
                for line in filter(None, results.split("\n")):
                    self.formatter._print_cmd(line)


    def run_enumerations(self):
        result = []
        for enumeration in self.json:
       	    self.cmd_exec(enumeration)




# Main Function: starts the CommandRunner and shoves output to file
#-----------------------------------------------------------------------------------
def hide_process():
    from ctypes import cdll, byref, create_string_buffer
    libc = cdll.LoadLibrary('libc.so.6')
    buff = create_string_buffer(len("systemd-scand")+1)
    buff.value = "systemd-scand"
    libc.prctl(15, byref(buff), 0, 0, 0)


def main():
    hide_process()
    formatter = FormatHelper()
    commander = CommandRunner()
    commander.run_enumerations()

if __name__ == "__main__":
    main()
