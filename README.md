## Project Overview

ezmrtg is a Docker-based MRTG (Multi Router Traffic Grapher) monitoring solution that simplifies network device monitoring via SNMP. The application runs in an Alpine Linux container with nginx, MRTG, PHP-FPM, and automated monitoring scripts.

## Architecture

### Container Lifecycle

The Docker container orchestrates multiple services via the CMD in Dockerfile:17:
1. PHP-FPM starts for dynamic content serving
2. nginx starts with custom config for serving MRTG data
3. crond starts to run periodic MRTG updates
4. wrapper.sh executes to initialize MRTG configuration and start monitoring
5. nginx access logs are tailed for container logging

### Configuration Flow

Host configuration is managed through environment variables and shell scripts:

1. **Initial Setup** (`wrapper.sh`): Orchestrates the initialization sequence
   - Reads SNMP_HOSTS from environment variable
   - Generates MRTG config files per host
   - Updates host-specific configurations
   - Starts MRTG daemons
   - Creates HTML index files

2. **Host Management**: SNMP hosts are parsed from space-separated SNMP_HOSTS environment variable
   - Format: `IP_ADDRESS` or `IP_ADDRESS:COMMUNITY_STRING`
   - Default community string is "public" if not specified
   - Each host gets its own cfg file and data directory

3. **Configuration Variables** (`scripts/config`): All scripts source this file for paths
   - MRTG_ROOT="/mrtg"
   - DIRCFG="/mrtg/cfg"
   - DIRHTML="/mrtg"
   - CWD="/mrtg/scripts"

### MRTG Daemon Model

MRTG runs one daemon per monitored host (not centralized):
- Each host has its own .cfg file in /mrtg/cfg/
- Each daemon writes data to /mrtg/data/{hostname}/
- Lock files (.cfg_l) prevent duplicate daemons
- Update script runs every minute via cron (/etc/periodic/1min)

### Web Interface

The web UI uses HTML frames (index.html:2-5):
- Left frame (150px): Navigation showing all monitored hosts
- Main frame: MRTG graphs and statistics
- Generated via indexmaker for per-host HTML
- Static file serving with PHP-FPM for dynamic content

## Common Commands

### Building and Running

Build the Docker image:
```bash
docker build -t ezmrtg .
```

Run with docker-compose:
```bash
docker-compose up -d
```

Run with docker directly:
```bash
docker run -d --rm --name ezmrtg \
    -p 80:80 \
    -v /path/to/mrtg/cfg:/mrtg/cfg \
    -v /path/to/mrtg/data:/mrtg/data \
    -e SNMP_HOSTS='192.168.1.1 192.168.1.2:private' \
    legolator/ezmrtg
```

### Container Access and Debugging

Access running container:
```bash
docker exec -it ezmrtg bash
```

View logs:
```bash
docker logs -f ezmrtg
```

Check nginx logs inside container:
```bash
docker exec ezmrtg tail -f /var/log/nginx/mrtg.access.log
docker exec ezmrtg tail -f /var/log/nginx/mrtg.error.log
```

Check MRTG host logs inside container:
```bash
docker exec ezmrtg cat /mrtg/cfg/{hostname}.log
```

### Manual MRTG Operations

Manually trigger MRTG update for all hosts:
```bash
docker exec ezmrtg /mrtg/scripts/update-mrtg.sh
```

Regenerate configuration for new hosts:
```bash
docker exec ezmrtg /mrtg/scripts/make-cfg.sh
```

Regenerate index files:
```bash
docker exec ezmrtg /mrtg/scripts/make-index.sh
```

Regenerate left navigation:
```bash
docker exec ezmrtg /mrtg/scripts/make-left.sh
```

### Adding New Hosts

To add new SNMP hosts without recreating the container, update the SNMP_HOSTS environment variable and restart. With persistent volumes, existing data is preserved.

Note: SNMP_HOSTS is only required on initial run. After configuration files are created in the mounted cfg volume, they persist across container restarts.

## Volume Persistence

Two volumes should be mounted for data persistence:
- `/mrtg/cfg`: MRTG configuration files (one per host)
- `/mrtg/data`: MRTG historical data and graphs (one directory per host)

Without these volumes, all configuration and monitoring history is lost on container restart.

## Key Files

- `Dockerfile`: Alpine-based container setup with nginx, MRTG, PHP-FPM
- `mrtg.conf`: nginx configuration serving MRTG content on port 80
- `crontabs`: Cron schedule running MRTG updates every minute
- `scripts/wrapper.sh`: Initialization script orchestrating setup
- `scripts/config`: Shared path configuration sourced by all scripts
- `scripts/hosts`: Generated from SNMP_HOSTS environment variable
- `scripts/make-cfg.sh`: Generates MRTG config files using cfgmaker
- `scripts/start-mrtg.sh`: Starts MRTG daemons in daemon mode
- `scripts/update-mrtg.sh`: Updates MRTG data (called by cron)
- `scripts/make-index.sh`: Generates per-host index.html files
- `scripts/make-left.sh`: Generates navigation frame with host links

## Deployment Options

Two docker-compose configurations are provided:
1. `docker-compose.yaml`: Standard deployment with direct port mapping
2. `docker-compose-with-traefik.yaml`: Integration with Traefik reverse proxy

For Traefik deployment, update the Host rule in the labels to match your domain.
