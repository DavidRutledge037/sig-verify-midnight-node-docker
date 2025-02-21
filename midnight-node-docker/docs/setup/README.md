# Setup Guide

## Prerequisites
- Docker Engine 20.10+
- Docker Compose v2.0+
- Minimum 16GB RAM
- 100GB+ available disk space
- Git

## Initial Setup

### 1. Clone the Repository
```bash
git clone https://github.com/YourOrg/sig-verify-midnight-node-docker.git
cd sig-verify-midnight-node-docker/midnight-node-docker
```

### 2. Environment Configuration
1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Configure environment variables:
   ```env
   NETWORK=preview
   POSTGRES_DB=cexplorer
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=your_secure_password
   ```

### 3. Directory Structure Setup
```bash
# Create necessary directories
mkdir -p node-ipc
mkdir -p cardano/config/preview
mkdir -p backups
```

### 4. Download Cardano Configuration
```bash
# Run the configuration download script
./download-config.sh
```

## Service Configuration

### 1. Cardano Node
- Configuration file: `cardano/config/preview/config.json`
- Socket path: `/ipc/node.socket`
- Port: 3001

### 2. DB Sync
- Configuration file: `cardano/config/preview/db-sync/config.json`
- Database configuration in `compose-partner-chains.yml`
- Memory limits: 4G

### 3. Kupo
- Configuration in `compose-partner-chains.yml`
- Database path: `/db`
- Socket path: `/ipc/node.socket`

### 4. Ogmios
- Port: 1337
- Socket path: `/ipc/node.socket`

## Starting the Services

1. Start all services:
   ```bash
   docker compose -f compose-partner-chains.yml up -d
   ```

2. Monitor initial startup:
   ```bash
   docker compose -f compose-partner-chains.yml logs -f
   ```

## Verification Steps

1. Check service status:
   ```bash
   docker compose -f compose-partner-chains.yml ps
   ```

2. Verify socket creation:
   ```bash
   ls -l node-ipc/node.socket
   ```

3. Check DB Sync progress:
   ```bash
   docker logs db-sync
   ```

4. Monitor Ogmios synchronization:
   ```bash
   docker logs ogmios
   ```

## Next Steps
- Monitor the synchronization progress
- Set up monitoring and alerting
- Configure backup procedures
- Review the Operations Guide for day-to-day management
