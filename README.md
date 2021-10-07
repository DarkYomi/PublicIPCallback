# PublicIP Callback

This script is used to execute commands when your public ip change.

## Usage

To install the script, simply add it to your cron job file using **crontab -e** command.  
To add actions, create a file in the action folder or use the default one, and add the command line to execute.  
  > The script read the file line by line, so you have to write your command on a **single line**
