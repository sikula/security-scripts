
Directory containing proof of concept code using scripts from the security-scripts repository.
<br/>
<br/>
###### Directory 'proof-of-concept-code'
-------------
Proof of concept code using the 'system-enumeration.py' script.
	
Python allows you to run code from within a zip file.
The goal is to create an executable zip file which contains the 'command-list.json' file and the 'system-enumeration.py' script, which we can then run easily
on a machine.

The script adds a new function *hide_process()* which changes the process name.

NOTE: Commands such as *ps -A* and *top* will show the **fake** process name, but commands such as *ps auxwww* will display the true process name.


**Creating the executable file**

	1. Clone the repository
	2. Change directory into 'proof-of-concept-code'
	3. Create the zip file
		- zip -r zip_file_name *
	4. Make the zip file executable
		- echo "#!/usr/bin/python" | cat - zip_file_name > new_file_name
		- chmod ug+x new_file_name

