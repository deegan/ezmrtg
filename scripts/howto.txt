# MRTG scrip av Hakan "linuxguden" Bjoerklund

Edit config to reflect your working enviroment.

1) add host to hosts
2) ./make-cfg.sh
3) ./update-host-cfg.sh
4) ./start-mrtg.sh
5) ./update-mrtg.sh
6) ./make-index.sh

Add update-mrtg.sh to crontab.

# runs every 5minutes. with debug logging.
*/5 * * * * $PATH_TO_SCRIPTS/update-mrtg.sh > /dev/null
# without debugging.
*/5 * * * * $PATH_TO_SCRIPTS/update-mrtg.sh > /dev/null 2>&1
