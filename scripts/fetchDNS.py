#!/usr/bin/env python3

# Usage: su root and place it in /root/fetchDNS and chmod a+x
# crontab: 0 3 * * 0 /root/fetchDNS

import os
import urllib.request


data = urllib.request.urlopen("https://gitee.com/ineo6/hosts/raw/master/hosts")


hosts = [line.decode('ascii').strip() for line in data]

hosts = [h for h in hosts if len(h) > 0 and not h.startswith("#")]

ipAndAddrs = [h.strip().split() for h in hosts]

ips = [h[0].strip() for h in ipAndAddrs]
addresses = [h[1].strip() for h in ipAndAddrs]

with open("/etc/hosts", "r") as fp:
    records = fp.readlines()

records = [r for r in records if not (r.startswith("# Github") or r.isspace())]
records = [r for r in records if all(addr not in r for addr in addresses)]

records.append("# Github Hosts Start" + os.linesep)

records.extend(hosts)

records.append("# Github Hosts End" + os.linesep)

result = os.linesep.join(records)


with open("/etc/hosts", "w") as fp:
    fp.write(result)

    
print("Set hosts finished.")
