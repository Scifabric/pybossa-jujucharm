#!/bin/bash

set -ex

sudo apt-get update -y
sudo apt-get install -y juju-local git-core

NATGUI="/home/vagrant/natgui.sh"
NATPYBOSSA="/home/vagrant/natpybossa.sh"
NATHAPROXY="/home/vagrant/nathaproxy.sh"

# write files to provide NAT to LXC containers
cat > "$NATGUI" <<'EOF'
#!/bin/bash

ROOT_UID="0"

# Check if run as root
if [ "$UID" -ne "$ROOT_UID" ] ; then
        echo "Use this command with sudo (root)!"
        exit 1
fi

JUJUSETTINGS="/home/vagrant/.juju/environments/local.jenv"

# check if Juju is initialized
if [ ! -f "$JUJUSETTINGS" ]
then
    echo ERROR: Is Juju initialized? No Juju configuration file found.
    exit 1
fi

if [ $# -lt 1 ] ; then
  echo Please provide an ip as argument!
  exit 1
else
  # check ip with regex
  ip=`echo $1`
  re='([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})'
  if [[ "$ip" =~ $re ]]; then
    ip="${BASH_REMATCH[1]}"
    # check if ip reachable with ping
    ping -c 1 "$ip" &>/dev/null
    if [ $? -ne 0 ]; then
      echo Error: Not a reachable valid IP.
      exit 1
    else
      # check if ip already forwarded
      iptables-save | grep "$ip" &> /dev/null
      if [ $? -eq 0 ] ; then
        echo Warning: IP is already forwarded. Showing only Juju password.
      else
        iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination "$ip":443
        if [ $? -eq 0 ] ; then
          echo SUCCESS: Mapped "$ip" port 443 to local port 443.
        else
          echo ERROR: Something went wrong with iptables command :(
        fi
      fi
    fi
  else
    echo Error: Entered ip address is not valid.
  fi
fi
echo
echo Ubuntu Juju GUI password
grep password "$JUJUSETTINGS"
EOF

cat > "$NATPYBOSSA" <<'EOF'
#!/bin/bash

ROOT_UID="0"

# Check if run as root
if [ "$UID" -ne "$ROOT_UID" ] ; then
        echo "Use this command with sudo (root)!"
        exit 1
fi

JUJUSETTINGS="/home/vagrant/.juju/environments/local.jenv"

# check if Juju is initialized
if [ ! -f "$JUJUSETTINGS" ]
then
    echo ERROR: Is Juju initialized? No Juju configuration file found.
    exit 1
fi

if [ $# -lt 1 ] ; then
  echo Please provide an ip as argument!
  exit 1
else
  # check ip with regex
  ip=`echo $1`
  re='([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})'
  if [[ "$ip" =~ $re ]]; then
    ip="${BASH_REMATCH[1]}"
    # check if ip reachable with ping
    ping -c 1 "$ip" &>/dev/null
    if [ $? -ne 0 ]; then
      echo Error: Not a reachable valid IP.
      exit 1
    else
      # check if ip already forwarded
      iptables-save | grep "$ip" &> /dev/null
      if [ $? -eq 0 ] ; then
        echo Warning: IP is already forwarded. Showing only Juju password.
      else
        iptables -t nat -A PREROUTING -p tcp --dport 7000 -j DNAT --to-destination "$ip":8080
        if [ $? -eq 0 ] ; then
          echo SUCCESS: Mapped "$ip" port 8080 from PyBossa to local port 7000.
        else
          echo ERROR: Something went wrong with iptables command :(
        fi
      fi
    fi
  else
    echo Error: Entered ip address is not valid.
  fi
fi
EOF

cat > "$NATHAPROXY" <<'EOF'
#!/bin/bash

ROOT_UID="0"

# Check if run as root
if [ "$UID" -ne "$ROOT_UID" ] ; then
        echo "Use this command with sudo (root)!"
        exit 1
fi

JUJUSETTINGS="/home/vagrant/.juju/environments/local.jenv"

# check if Juju is initialized
if [ ! -f "$JUJUSETTINGS" ]
then
    echo ERROR: Is Juju initialized? No Juju configuration file found.
    exit 1
fi

if [ $# -lt 1 ] ; then
  echo Please provide an ip as argument!
  exit 1
else
  # check ip with regex
  ip=`echo $1`
  re='([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})'
  if [[ "$ip" =~ $re ]]; then
    ip="${BASH_REMATCH[1]}"
    # check if ip reachable with ping
    ping -c 1 "$ip" &>/dev/null
    if [ $? -ne 0 ]; then
      echo Error: Not a reachable valid IP.
      exit 1
    else
      # check if ip already forwarded
      iptables-save | grep "$ip" &> /dev/null
      if [ $? -eq 0 ] ; then
        echo Warning: IP is already forwarded. Showing only Juju password.
      else
        iptables -t nat -A PREROUTING -p tcp --dport 7001 -j DNAT --to-destination "$ip":80
        if [ $? -eq 0 ] ; then
          echo SUCCESS: Mapped "$ip" port 80 from HAProxy to local port 7001.
        else
          echo ERROR: Something went wrong with iptables command :(
        fi
      fi
    fi
  else
    echo Error: Entered ip address is not valid.
  fi
fi
EOF

# make this config files executable
chmod +x "$NATGUI"
chmod +x "$NATPYBOSSA"
chmod +x "$NATHAPROXY"
