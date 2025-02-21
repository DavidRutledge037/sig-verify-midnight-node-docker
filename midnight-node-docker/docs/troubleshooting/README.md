# Troubleshooting Guide

## Common Issues and Solutions

### 1. Service Start-up Issues

#### Cardano Node Won't Start
```bash
# Check if socket file exists and has correct permissions
ls -l node-ipc/node.socket

# Verify port availability
netstat -an | grep 3001

# Check node logs
docker logs cardano-node
```

**Solution**:
1. Remove stale socket file: `rm node-ipc/node.socket`
2. Ensure correct permissions: `chmod 755 node-ipc`
3. Verify port is not in use
4. Restart service

#### DB Sync Connection Issues
```bash
# Check PostgreSQL status
docker logs db-sync-postgres

# Verify database exists
docker exec db-sync-postgres psql -U postgres -l

# Check DB Sync logs
docker logs db-sync
```

**Solution**:
1. Verify PostgreSQL is running
2. Check database credentials in .env
3. Ensure database exists and is accessible
4. Verify socket connection to Cardano node

### 2. Performance Issues

#### High Memory Usage
```bash
# Monitor container memory usage
docker stats

# Check PostgreSQL memory settings
docker exec db-sync-postgres psql -U postgres -c 'SHOW work_mem;'
```

**Solution**:
1. Adjust memory limits in compose file
2. Tune PostgreSQL settings
3. Consider system upgrade if persistent

#### Slow Synchronization

```bash
# Check network sync status
docker logs ogmios | grep "networkSynchronization"

# Monitor block progress
docker logs cardano-node | grep "Chain extended"
```

**Solution**:
1. Verify system resources
2. Check network connectivity
3. Adjust PostgreSQL performance parameters
4. Consider using a snapshot for initial sync

### 3. Volume and Storage Issues

#### Disk Space Problems
```bash
# Check disk usage
df -h

# View container storage
docker system df -v
```

**Solution**:
1. Clean up old logs
2. Remove unused containers/volumes
3. Prune unnecessary data
4. Add storage capacity

#### Volume Mount Issues
```bash
# Check volume mounts
docker volume ls
docker volume inspect node-ipc

# Verify bind mounts
ls -l $(pwd)/node-ipc
```

**Solution**:
1. Recreate volumes
2. Check directory permissions
3. Verify docker-compose configuration

### 4. Network Issues

#### Inter-Service Communication
```bash
# Check network connectivity
docker network inspect partner-chain-net

# Verify service resolution
docker exec cardano-node ping db-sync
```

**Solution**:
1. Recreate network
2. Check service names
3. Verify network configuration

#### External Connectivity
```bash
# Test network access
docker exec cardano-node curl -v telemetry.cardano.org

# Check DNS resolution
docker exec cardano-node nslookup iohk.io
```

**Solution**:
1. Check firewall rules
2. Verify DNS configuration
3. Test network connectivity

## Log Analysis

### Important Log Patterns

1. Cardano Node
```
Chain extended - Normal operation
Disconnected - Network issues
ConnectionFailure - Peer connection problems
```

2. DB Sync
```
Insert Block - Normal operation
Rolling back - Chain reorganization
DatabaseError - Database issues
```

3. Ogmios
```
networkSynchronization - Sync progress
ConnectionStatus - Connection state
Error - Operation issues
```

## Recovery Procedures

### 1. Database Recovery
```bash
# Stop services
docker compose -f compose-partner-chains.yml down

# Restore from backup
cat backup.sql | docker exec -i db-sync-postgres psql -U postgres cexplorer

# Restart services
docker compose -f compose-partner-chains.yml up -d
```

### 2. Node Reset
```bash
# Stop services
docker compose -f compose-partner-chains.yml down

# Clear node data
rm -rf node-data/*

# Restart with clean state
docker compose -f compose-partner-chains.yml up -d
```

### 3. Emergency Shutdown
```bash
# Graceful shutdown
docker compose -f compose-partner-chains.yml down

# Force shutdown if necessary
docker compose -f compose-partner-chains.yml down -v
```
