# ezmrtg 
```
docker run -d --rm --name ezmrtg \
    -p 80:80 \                           # or some other unused port.
    -v /path/to/mrtg/cfg:/mrtg/cfg \     # optional but recomended.
    -v /path/to/mrtg/data:/mrtg/data \   # optional but recomended.
    -e SNMP_HOSTS='1.2.3.4 5.6.7.8' \    # only necessary on the inital run, but this is how you add new nodes.
    legolator/ezmrtg
```
