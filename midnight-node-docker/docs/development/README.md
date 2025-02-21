# Development Guide

## Quick Start

### Prerequisites
- Docker Desktop
- Git
- Text editor (VSCode recommended)
- 16GB RAM minimum
- 100GB free disk space

### Development Environment Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/YourOrg/sig-verify-midnight-node-docker.git
   cd sig-verify-midnight-node-docker/midnight-node-docker
   ```

2. Set up environment:
   ```bash
   cp .env.example .env
   # Edit .env with your preferred settings
   ```

3. Start services:
   ```bash
   docker compose -f compose-partner-chains.yml up -d
   ```

## Project Structure
```
midnight-node-docker/
├── cardano/                  # Cardano node configuration
│   └── config/              # Network configs
├── scripts/                 # Utility scripts
├── node-ipc/               # Socket directory
├── compose-partner-chains.yml  # Main compose file
└── .env                    # Environment variables
```

## Making Changes

### Service Configuration
1. Edit `compose-partner-chains.yml` for service changes
2. Update environment variables in `.env`
3. Modify configurations in `cardano/config/`

### Testing Changes
```bash
# Restart services with new configuration
docker compose -f compose-partner-chains.yml down
docker compose -f compose-partner-chains.yml up -d

# Check logs
docker compose -f compose-partner-chains.yml logs -f
```

## Common Development Tasks

### Checking Service Status
```bash
# View all services
docker compose -f compose-partner-chains.yml ps

# Check specific service logs
docker logs cardano-node
docker logs db-sync
```

### Debugging
1. Check service logs
2. Verify socket connections
3. Monitor resource usage
4. Review PostgreSQL status

## Version Information
Current stable versions:
- Cardano Node: 8.7.3
- DB Sync: 13.1.1.2
- Kupo: v2.9.0
- Ogmios: v6.0.0

## Need Help?
- Check the troubleshooting guide
- Review service logs
- Consult documentation
- Raise an issue on GitHub
