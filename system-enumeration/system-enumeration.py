#!/usr/bin/env python
#----------------------------------
import os
import sys
import time
import json
import codecs
import datetime
import subprocess
from optparse import OptionParser

#// Parse the command line options
parser = OptionParser()
parser.add_option("-c", "--command-list", dest="command_list" , help="Specifiy a json file with the commands to be enumerated")
parser.add_option("-e", "--enumerate"   , dest="enumeration"  , help="Specify a enumeration to run defined by a key in the json file")
parser.add_option("-o", "--output"      , dest="output_file"  , help="Specify output file")
parser.add_option("-f", "--forest"      , dest="forest"       , action='store_true' , help="Display output in tree-like format")
parser.add_option("-N", "--no-header"   , dest="no_header"    , action='store_true', help="Remove headers from output")
(options, arg) = parser.parse_args()
if options.enumeration:
    options.enumeration = options.enumeration.upper()

#-----------------------------------------------------------------------------------------------------
# Handles the opening, reading and parsing of the JSON file which contains all the enumerations,
# categories and commands/messages
#-----------------------------------------------------------------------------------------------------
class JsonHelper:
    def __init__(self):
        with codecs.open(str(options.command_list), 'rU', 'utf-8') as json_data:
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
        if not options.no_header:
            print "\n"
            print "[ + ] " + msg
            print "-" * 77
        else:
            print "\n"


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
        else:
            print "    ", output.rstrip()


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
        if not options.enumeration:
            for enumeration in self.json:
                self.cmd_exec(enumeration)
        else:
            self.cmd_exec(options.enumeration)




# Main Function: starts the CommandRunner and shoves output to file
#-----------------------------------------------------------------------------------
def main():
    formatter = FormatHelper()
    commander = CommandRunner()
    if options.output_file:
        output_file = open(options.output_file, 'w')
        original    = sys.stdout
        sys.stdout  = Tee(sys.stdout, output_file)
        formatter.file_header()
        commander.run_enumerations()
        sys.stdout = original
        output_file.close()
    else:
        commander.run_enumerations()



if __name__ == "__main__":
    main()
