#--------------------------------------------------------------------
# Currently Runs 66 Commands
#--------------------------------------------------------------------
require "json"

json = {
    "System Enumeration" => {
        "OS"    => {
            "cmd"   => %q[cat /etc/issue],
            "msg"   => "Operating System Information",
        },
        "Uname" => {
            "cmd"   => %q[uname -a],
            "msg"   => "System/Kernel Version Information",
        },
        "Kernel" => {
            "cmd"   => %q[cat /proc/version],
            "msg"   => "Kernal Information",
        },
        "Hostname"  => {
            "cmd"   => %q[hostname],
            "msg"   => "System Hostname",
        },
        "Filesystem" => {
            "cmd"   => %q[df -a],
            "msg"   => "Filesystem Information",
        },
    },
    "Network Enumeration" => {
        "Net"   => {
            "cmd"   => %q[ifconfig -a],
            "msg"   => "Available Network Interfaces",
        },
        "Connections" => {
            "cmd"   => %q[ls -alh /etc/sysconfig/network-scripts],
            "msg"   => "Listing Network Connections",
        },
        "Resolv"    => {
            "cmd"   => %q[cat /etc/resolv.cong],
            "msg"   => "Listing Gatways/DNS/DHCP"
        },
        "Route"     => {
            "cmd"   => %q[route],
            "msg"   => "Routing Information",
        },
        "Netstat"   => {
            "cmd"   => %q[netstat -antup | grep -v "TIME_WAIT"],
            "msg"   => "Network Connections and Statistics",
        },
        "ARP"       => {
            "cmd"   => %q[arp -ven],
            "msg"   => "ARP Information",
        },
        "Firewall" => {
            "cmd"  => %q[firewall-cmd --list-all-zones],
            "msg"  => "Firewall Information --( Firewall CMD ) --",
        },
        "IPTables"  => {
            "cmd"   => %q[iptables -S ; iptables -L],
            "msg"   => "Firewall Information --( IP Tables )--",
        },
        "TCPDUMP"   => {
            "cmd"   => %q[tcpdump -s0 -xxXX -vv -i any -c 25 "host $(ifconfig | grep -w inet | grep -v 127.0.0.1 | sed 's/\s\+/ /g' | cut -d" " -f 3)"],
            "msg"   => "TCP Dump Network Traffic",
        },
    },
    "Drive Enumeration" => {
        "Mount"     => {
            "cmd"   => %q[mount],
            "msg"   => "Currently Mounted Devices",
        },
        "FSTab"     => {
            "cmd"   => %q[cat /etc/fstab | tail -n +9],
            "msg"   => "Other Devices Statistics",
        },
    },
    "Log File Enumeration" => {
        "Logwatch"  => {
            "cmd"   => %q[logwatch --detail 10 --range Today --numeric --hostname --filename],
            "msg"   => "Recent Log Entries",
        },
        "LOGDIR"    => {
            "cmd"   => %q[tail -n25 /var/log/boot.log /var/log/cron /var/log/secure /var/log/dracut.log /var/log/firewalld /var/log/messages],
            "msg"   => "Last 25 Lines From Important Log Files",
        },
        "CRON"      => {
            "cmd"   => %q[ls -al /etc/cron*],
            "msg"   => "Listing Known Cron Jobs",
        },
        "CRONW"     => {
            "cmd"   => %q[ls -alR /etc/cron* | awk "\$1 ~ /w.\$/"],
            "msg"   => "Listing Writable Cron Directories",
        },
    },
    "Database Enumeration" => {
        "MySQLDUMP" => {
            "cmd"   => %q[systemctl stop mysqld.service ; mysqld_safe ; mysqldump --all-databases --skip-add-drop-table --skip-set-charset | grep -v "help" ; systemctl start mysqld.service"],
            "msg"   => "Dumping MySQL Database",
        },
    },
    "Configuration Enumeration" => {
        "OpenSSH"   => {
            "cmd"   => %q[sshd -T],
            "msg"   => "Testing OpenSSH Configuration",
        },
     },
    "User Enumeration" => {
        "Lastlog"   => {
            "cmd"   => %q[last],
            "msg"   => "Last logged in users",
        },
        "Lastlog Info" => {
            "cmd"   => %q[lastlog | grep -v "Never"],
            "msg"   => "Information about last logged in users",
        },
        "Whoami"    => {
            "cmd"   => %q[whoami],
            "msg"   => "Current User Session",
        },
        "ID"        => {
            "cmd"   => %q[id],
            "msg"   => "Current User Session ID",
        },
        "Users"     => {
            "cmd"   => %q[cat /etc/passwd],
            "msg"   => "All User Accounts",
        },
        "Groups"    => {
            "cmd"   => %q[cat /etc/group],
            "msg"   => "All Group Accounts",
        },
        "Supusr"    => {
            "cmd"   => %q[grep -v -E "^#" /etc/passwd | awk -F: "$3 == 0{print $1}"],
            "msg"   => "All Super Users Found",
        },
        "History"   => {
            "cmd"   => %q[ls -al $HOME/.*_history],
            "msg"   => "Recent Command Line History",
        },
        "Env"       => {
            "cmd"   => %q[env | grep -v "LS_COLORS"],
            "msg"   => "Environment Information",
        },
        "Set"       => {
            "cmd"   => %q[set],
            "msg"   => "Shell Variables",
        },
        "Sys Vars"  => {
            "cmd"   => %q[cat /etc/profiles],
            "msg"   => "Default System Variables",
        },
        "Shells"    => {
            "cmd"   => %q[/etc/shells],
            "msg"   => "Available shells",
        },
        "Sudoers"   => {
            "cmd"   => %q[cat /etc/sudoers | grep -v "#" | sed "/^$/d"],
            "msg"   => "All Suoders On The System",
        },
        "Logged"    => {
            "cmd"   => %q[w],
            "msg"   => "All Users Currently Logged In",
        },
    },
    "Permission Enumeration" => {
        "DIRSROOT"  => {
            "cmd"   => %q[find / \( -wholename \"$HOME*\" -prune \) -o \( -type d -perm -0002 \) -exec ls -ld "{}" ";" 2>/dev/null | grep root],
            "msg"   => "Searching For World Writeable Directories For User => Root",
        },
        "DIRS"      => {
            "cmd"   => %q[find / \( -wholename \"$HOME*\" -prune \) -o \( -type d -perm -0002 \) -exec ls -ld "{}" ";" 2>/dev/null | grep -v root],
            "msg"   => "Searching For World Writeable Files For Users Other Than => Root",
        },
        "FILES"     => {
            "cmd"   => %q[
                find / -xdev \( -path \"$HOME*\" -prune -o -path "proc" -prune -path "sys" -prune \) -o \( -type f -perm -0002 \) -exec ls -l "{}" ";" 2>/dev/null],
            "msg"   => "Searching For World Writeable Files",
        },
        "STICKY"    => {
            "cmd"   => %q[find $HOME* | xargs lsattr 2>/dev/null | grep "^....i"],
            "msg"   => "Searching For Files With Immutable Bits Set",
        },
        "SUID"      => {
            "cmd"   => %q[find / \( -perm -2000 -o -perm -4000 \) -exec ls -ld {} \; 2>/dev/null],
            "msg"   => "Searching for SUID/SGID Files and Directories",
        },
        "5DAYS"     => {
            "cmd"   => %q[find / -xdev -ctime -5 -not \( -path "proc" -o -path "sys" \)],
            "msg"   => "Listing Files That Have Been Modified In The Last 5 Days",
        },
        "ROOTHOME"  => {
            "cmd"   => %q[ls -ahlR /root/ 2>/dev/null],
            "msg"   => "Testing If Home Directory Is Visible for User => Root",
        },
    },
    "Password File Enumeration" => {
        "LOGPWD"    => {
            "cmd"   => %q[find /var/log -name "*.log" 2>/dev/null | xargs -l10 egrep "pwd|password" 2>/dev/null],
            "msg"   => "Searching For Keywords [pwd|passwd] In Log Files",
        },
        "CNFPWD"    => {
            "cmd"   => %q[find /etc -name "*.c*" 2>/dev/null | xargs -l10 egrep "pwd|password" 2>/dev/null],
            "msg"   => "Searching For Keywords [pwd|passwd] In Configuration Files",
        },
        "PWDFILE"   => {
            "cmd"   => %q[find ~ -name "*pass*" 2>/dev/null],
            "msg"   => "Searching For Files With [pass] In Their Name",
        },
        "SHDW"      => {
            "cmd"   => %q[cat /etc/shadow 2>/dev/null],
            "msg"   => "Shadow Files",
        },
    },
    "Process Enumeration" => {
        "Procs"     => {
            "cmd"   => %q[ps axfo cgroup,rgid,class,stat,args],
            "msg"   => "Process Information",
        },
    },
    "Package Enumeration" => {
        "RPM"       => {
            "cmd"   => %q[rpm -qa --qf "[%-10{=FILEMD5S} %-30{NAME}] %{INSTALLTIME:date}\n" | sort -u -k2],
            "msg"   => "Listing Installed Packages --( RPM )--",
        },
    },
    "Tool Enumeration" => {
        "Tools"     => {
            "cmd"   => %q[which awk sed perl python ruby java gcc cc vi vim nmap find ncat nc wget tftp ftp 2>/dev/null],
            "msg"   => "Available Development Tools",
        },
    },
    "Virtual Hardware Enumeration"  => {
        "VBoxManage" => {
            "cmd"    => %q[vboxmanage list --long vms],
            "msg"    => "Virtual Machine Information"
        },
    },
    "Hardware Enumeration" => {
        "CPU"       => {
            "cmd"   => %q[cat /proc/cpuinfo],
            "msg"   => "Listing CPU Information",
        },
        "LVM"       => {
            "cmd"   => %q[dmsetup ls --tree -o active,open,rw,uuid,ascii,notrunc],
            "msg"   => "Logival Volume Manager Information",
        },
        "Hardware"  => {
            "cmd"   => %q[lshw],
            "msg"   => "List Hardware",
        },
        "Blocks"    => {
            "cmd"   => %q[blkid],
            "msg"   => "Block Device Attributes",
        },
        "PCI"       => {
            "cmd"   => %q[lspci],
            "msg"   => "List of PCI Devices",
        },
        "USB"       => {
            "cmd"   => %q[lsusb],
            "msg"   => "List USB Devices",
        },
        "USB-DEV"   => {
            "cmd"   => %q[usb-devices],
            "msg"   => "USB Device Information",
        },
        "DMI Decode"=> {
            "cmd"   => %q[dmidecode],
            "msg"   => "Printing DMI Table in Readable Format",
        },
        "Partition" => {
            "cmd"   => %q[fdisk -l ; fdisk -u -l],
            "msg"   => "Listing Partition Table",
        },
        "Drives"    => {
            "cmd"   => %q[hdparm -I /dev/sd??],
            "msg"   => "Listing SATA/IDE Device Parameters",
        },
        "BLK Report"=> {
            "cmd"   => %q[blockdev --report /dev/sd?],
            "msg"   => "Printing Block Device Report",
        },
        "Devices"   => {
            "cmd"   => %q[head -10 /sys/devices/virtual/dmi/id/*],
            "msg"   => "Printing More DMI Device Information",
        },
        "Listing"   => {
            "cmd"   => %q[ls -al /dev/disk/*],
            "msg"   => "Listing files in => /dev/disk/",
        },
        "By ID"     => {
            "cmd"   => %q[find /dev/disk -ls],
            "msg"   => "Listing Disks by ID",
        },
        "LVM Dump"  => {
            "cmd"   => %q[lvmdump],
            "msg"   => "Dumping LVM Information: DUMPED INTO TARBALL in $HOME",
        },
    },
}

File.open("command_list.json", "w") {|file|
    file.write JSON.dump(json)
}
