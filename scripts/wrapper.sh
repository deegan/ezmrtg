#!/bin/bash
/mrtg/scripts/make-cfg.sh
/mrtg/scripts/update-host-cfg.sh
/mrtg/scripts/start-mrtg.sh
/mrtg/scripts/update-mrtg.sh
/mrtg/scripts/make-index.sh
/mrtg/scripts/make-left.sh

