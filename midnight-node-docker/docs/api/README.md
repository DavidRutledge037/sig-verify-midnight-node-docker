# API Documentation

## Service APIs Overview

### 1. Ogmios API
Base URL: `http://localhost:1337`

#### WebSocket Endpoints
```javascript
// Chain Sync
ws://localhost:1337/

// State Query
ws://localhost:1337/

// Transaction Submit
ws://localhost:1337/
```

#### Example Queries
```javascript
// Chain Tip Query
{
    "type": "jsonwsp/request",
    "version": "1.0",
    "servicename": "ogmios",
    "methodname": "RequestNext",
    "args": {}
}

// UTXO Query
{
    "type": "jsonwsp/request",
    "version": "1.0",
    "servicename": "ogmios",
    "methodname": "Query",
    "args": {
        "query": "utxo",
        "args": {
            "addresses": ["addr..."]
        }
    }
}
```

### 2. Kupo API
Base URL: `http://localhost:1442`

#### REST Endpoints
```
GET /matches                    # Get all matching outputs
GET /matches/{pattern}         # Get outputs matching pattern
GET /patterns                  # List tracked patterns
```

#### Example Queries
```bash
# Get all UTXOs for an address
curl http://localhost:1442/matches/addr1...

# Get all tracked patterns
curl http://localhost:1442/patterns
```

### 3. DB Sync Queries
Connection: PostgreSQL on port 5432

#### Common Queries
```sql
-- Get latest block
SELECT * FROM block 
WHERE block_no IS NOT NULL 
ORDER BY block_no DESC LIMIT 1;

-- Get transaction history
SELECT * FROM tx 
WHERE block_id IN (
    SELECT id FROM block 
    WHERE epoch_no = $epoch_number
);

-- Get stake distribution
SELECT * FROM epoch_stake 
WHERE epoch_no = $epoch_number;
```

### 4. Midnight Node Integration [WIP]
**Note: This section is under development as the Midnight node integration progresses**

#### Planned Endpoints
```
POST /api/v1/transaction       # Submit transaction
GET  /api/v1/status           # Node status
GET  /api/v1/metrics          # Node metrics
```

#### Expected Integration Points
1. Chain Synchronization
   ```
   [Cardano Node] <-> [Midnight Node]
                  |
                  v
             [DB Sync]
   ```

2. Transaction Flow
   ```
   [Client] -> [Midnight Node] -> [Cardano Node]
                              <- [Chain Status]
   ```

#### Security Considerations [TBD]
- Authentication mechanisms
- Authorization levels
- Rate limiting
- Encryption requirements

## API Security

### Authentication
- API keys for sensitive endpoints
- JWT tokens for session management
- Rate limiting configuration

### SSL/TLS Configuration
```nginx
# Example Nginx configuration for SSL
server {
    listen 443 ssl;
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    # ... additional SSL settings
}
```

### Rate Limiting
```nginx
# Example rate limiting configuration
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
```

## Monitoring and Metrics

### Health Check Endpoints
```
GET /health           # Basic health check
GET /metrics          # Prometheus metrics
GET /status           # Detailed status
```

### Prometheus Metrics
```
# Available metrics
cardano_node_blocks_forged_total
cardano_node_epoch_number
cardano_node_peers_connected
# ... additional metrics
```

## Error Handling

### Common Error Codes
```json
{
    "400": "Bad Request - Invalid parameters",
    "401": "Unauthorized - Authentication required",
    "403": "Forbidden - Insufficient permissions",
    "404": "Not Found - Resource doesn't exist",
    "429": "Too Many Requests - Rate limit exceeded",
    "500": "Internal Server Error - Server-side issue"
}
```

### Error Response Format
```json
{
    "error": {
        "code": "ERROR_CODE",
        "message": "Human readable message",
        "details": {
            "additional": "error specific information"
        }
    }
}
```
