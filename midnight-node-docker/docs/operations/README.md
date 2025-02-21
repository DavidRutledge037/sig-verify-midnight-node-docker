# Operations Guide

## Daily Operations

### Service Management

1. Starting Services
   ```bash
   docker compose -f compose-partner-chains.yml up -d
   ```

2. Stopping Services
   ```bash
   docker compose -f compose-partner-chains.yml down
   ```

3. Service Status Check
   ```bash
   docker compose -f compose-partner-chains.yml ps
   ```

### Monitoring

1. View Service Logs
   ```bash
   # All services
   docker compose -f compose-partner-chains.yml logs -f

   # Specific service
   docker logs db-sync
   docker logs cardano-node
   docker logs kupo
   docker logs ogmios
   ```

2. Resource Usage
   ```bash
   docker stats
   ```

3. Sync Progress Check
   ```bash
   # DB Sync progress
   docker logs db-sync | grep "Insert"

   # Ogmios sync status
   docker logs ogmios | grep "networkSynchronization"
   ```

## Backup Procedures

### 1. Database Backup
```bash
# Create backup directory with timestamp
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup PostgreSQL database
docker exec db-sync-postgres pg_dump -U postgres cexplorer > $BACKUP_DIR/cexplorer.sql
```

### 2. State Snapshot Management
- Location: `/var/lib/cexplorer/`
- Latest snapshot: `43545597-f64a2109c8-503.lstate`
- Backup frequency: Every 500 blocks (following)
- Retention policy: Keep last 3 snapshots

## Performance Tuning

### Memory Management
1. DB Sync & PostgreSQL
   - Current limits: 4G
   - Monitoring threshold: 80% usage
   - Action required if consistently above 90%

2. Resource Allocation
   ```yaml
   db-sync:
     mem_limit: 4g
     mem_reservation: 2g
   ```

### Network Configuration
1. Socket Management
   - Path: `/ipc/node.socket`
   - Permissions: `srwxr-xr-x`
   - Health check interval: 10s

2. Port Configuration
   - Cardano Node: 3001
   - Ogmios: 1337
   - PostgreSQL: 5432

## Troubleshooting

### Common Issues

1. Socket Connection Issues
   ```bash
   # Check socket existence and permissions
   ls -l node-ipc/node.socket
   
   # Verify socket is being used
   lsof node-ipc/node.socket
   ```

2. Database Connection Problems
   ```bash
   # Check PostgreSQL logs
   docker logs db-sync-postgres
   
   # Verify database connectivity
   docker exec db-sync-postgres psql -U postgres -d cexplorer -c "\l"
   ```

3. Sync Issues
   ```bash
   # Check network synchronization
   docker logs ogmios | grep "networkSynchronization"
   
   # Verify chain progress
   docker logs cardano-node | grep "Chain extended"
   ```

## Maintenance Schedule

1. Daily Tasks
   - Monitor sync progress
   - Check resource usage
   - Review error logs

2. Weekly Tasks
   - Backup database
   - Prune old logs
   - Review performance metrics

3. Monthly Tasks
   - Full system backup
   - Review and update configurations
   - Check for updates
