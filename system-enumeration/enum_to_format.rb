require "json"

json = {
    "SYSTEM" => {
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
    },
    "NET_INFO" => {
        "Net"   => {
            "cmd"   => %q[ifconfig -a],
            "msg"   => "Available Network Interfaces",
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
        "Firewall"  => {
            "cmd"   => %q[firewall-cmd --list-all-zones],
            "msg"   => "Firewall Information --( Firewall-cmd )--",
        },
        "IPTables"  => {
            "cmd"   => %q[iptables -S],
            "msg"   => "Firewall Information --( IP Tables )--",
        },
    },
    "DRIVE_INFO" => {
        "Mount"     => {
            "cmd"   => %q[mount],
            "msg"   => "Currently Mounted Devices",
        },
        "FSTab"     => {
            "cmd"   => %q[cat /etc/fstab | tail -n +9],
            "msg"   => "Other Devices Statistics",
        },
    },
    "LOG_INFO" => {
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
            "msg"   => "Listing Writable Cron Directories",
        },
    },
    "CONF_INFO" => {
        "OpenSSH"   => {
            "cmd"   => %q[sshd -T],
            "msg"   => "Testing OpenSSH Configuration",
        },
     },
    "USER_INFO" => {
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
        "Sudoers"   => {
            "cmd"   => %q[cat /etc/sudoers | grep -v "#" | sed "/^$/d"],
            "msg"   => "All Suoders On The System",
        },
        "Logged"    => {
            "cmd"   => %q[w],
            "msg"   => "All Users Currently Logged In",
        },
    },
    "PERMS" => {
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
    "PASS_FILES" => {
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
    "PROCESS_INFO" => {
        "Procs"     => {
            "cmd"   => %q[ps axfo cgroup,rgid,class,stat,args],
            "msg"   => "Process Information",
        },
    },
    "PACKAGES" => {
        "RPM"       => {
            "cmd"   => %q[rpm -qa --qf "[%-10{=FILEMD5S} %-30{NAME}] %{INSTALLTIME:date}\n" | sort -u -k2],
            "msg"   => "Listing Installed Packages",
        }
    },
    "TOOLS_INFO" => {
        "Tools"     => {
            "cmd"   => %q[which awk sed perl python ruby java gcc cc vi vim nmap find ncat nc wget tftp ftp 2>/dev/null],
            "msg"   => "Available Development Tools",
        },
    },
    "VIRT_HARDWAre" => {
	"VirtualBox All" => {
	    "cmd" => %q[vboxmanage list --long vms],
	    "msg" => "Listing All Configured Virtual Machines",
	},
	"VirtualBox Running" => {
	    "cmd" => %q[vboxmanage list --long runningvms],
            "msg" => "Listing all Running Virtual Machines",
	},
    },
    "HARDWARE" => {
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
