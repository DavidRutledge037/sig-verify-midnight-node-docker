# Architecture Documentation

## System Components

### 1. Cardano Node
- **Purpose**: Core blockchain node for the Cardano network
- **Configuration**: 
  - Network: Preview testnet
  - Socket Path: `/ipc/node.socket`
  - Port: 3001

### 2. DB Sync
- **Purpose**: Blockchain data indexer
- **Configuration**:
  - Memory: 4G limit, 2G reservation
  - Database: PostgreSQL
  - Socket Path: `/node-ipc/node.socket`
  - State Dir: `/var/lib/cexplorer`

### 3. Kupo
- **Purpose**: UTXO indexer
- **Configuration**:
  - Socket Path: `/ipc/node.socket`
  - Database Path: `/db`
  - Match Pattern: "*"
  - Prune UTXO: Enabled

### 4. Ogmios
- **Purpose**: JSON-RPC interface
- **Configuration**:
  - Socket Path: `/ipc/node.socket`
  - Port: 1337

## Volume Management
```yaml
volumes:
  node-ipc:
    driver_opts:
      type: none
      device: ${PWD}/node-ipc
      o: bind
  db-sync-data:
  postgres-data:
  kupo-data:
```

## Network Configuration
- All services share `partner-chain-net` network
- Internal communication via Docker network
- Socket file shared via volume mounts

## Security
- Socket permissions strictly controlled
- Volume mounts properly configured
- Network isolation between services
- Secure configuration management

## Health Checks
```yaml
healthcheck:
  test: ["CMD", "test", "-S", "/node-ipc/node.socket"]
  interval: 10s
  timeout: 5s
  retries: 12
  start_period: 30s
```

## Resource Management
- PostgreSQL: 4G memory limit, 2G reservation
- DB Sync: 4G memory limit, 2G reservation
- Monitoring via container stats
- Regular backup system in place
