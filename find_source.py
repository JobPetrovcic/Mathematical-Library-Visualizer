from configparser import ConfigParser
import sys

parser = ConfigParser()
with open(sys.argv[1]) as stream:
    parser.read_string("[top]\n" + stream.read()) 
    print(parser["top"]["include"].strip())