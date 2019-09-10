#!/bin/bash
# CYMRU : https://www.team-cymru.com/bogon-reference.html
wget -Nq https://www.team-cymru.org/Services/Bogons/fullbogons-ipv6.txt -O cymru-bogons/fullbogons-ipv6.txt
wget -Nq https://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt -O cymru-bogons/fullbogons-ipv4.txt
# SPAMHAUS : https://www.spamhaus.org/drop/
wget -Nq https://www.spamhaus.org/drop/drop.txt -O spamhaus-drop/drop-v4.txt
wget -Nq https://www.spamhaus.org/drop/dropv6.txt -O spamhaus-drop/drop-v6.txt
wget -Nq https://www.spamhaus.org/drop/edrop.txt -O spamhaus-drop/drop-v4-extended.txt
wget -Nq https://www.spamhaus.org/drop/asndrop.txt -O spamhaus-drop/drop-asn.txt
