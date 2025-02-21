# Midnight Validator Setup Guide

## Prerequisites
- Fully synced Cardano node
- Payment and stake keys for registration
- Sufficient ADA for registration transaction

## Setup Process

1. **Prepare Configuration**
   ```bash
   # Copy your keys to the config directory
   cp /path/to/payment.* midnight/config/preview/
   cp /path/to/stake.* midnight/config/preview/
   ```

2. **Configure Validator**
   - Edit `midnight/config/preview/validator.json`
   - Update pool information
   - Set pledge amount
   - Configure relays

3. **Run Setup Script**
   ```bash
   ./scripts/midnight-validator-setup.sh
   ```

4. **Enable Validator**
   Edit `midnight/config/preview/config.json`:
   ```json
   {
       "validator": {
           "enabled": true,
           "keyFile": "/config/validator-key.json"
       }
   }
   ```

5. **Restart Services**
   ```bash
   docker compose -f compose-partner-chains.yml -f compose-midnight.yml down
   docker compose -f compose-partner-chains.yml -f compose-midnight.yml up -d
   ```

## Monitoring

Check validator status:
```bash
docker exec midnight-node partner-chains-cli status
```

View validator logs:
```bash
docker logs -f midnight-node
```

## Important Notes
- Ensure Cardano node is fully synced before registration
- Keep your keys secure
- Monitor validator performance
- Regular maintenance is required
