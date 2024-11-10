#!/bin/bash
nmcli connection show --active | grep wifi | awk '{print $1}' | xargs -r nmcli connection down
