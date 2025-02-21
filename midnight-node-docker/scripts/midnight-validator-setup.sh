#!/bin/bash
set -e

# Configuration
CARDANO_CLI="docker exec cardano-node cardano-cli"
PARTNER_CHAINS_CLI="docker exec midnight-node partner-chains-cli"
CONFIG_DIR="midnight/config/preview"
NETWORK="--testnet-magic 2"  # Preview network

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Midnight Validator Setup Script"
echo "=============================="

# Check if cardano node is synced
check_sync_status() {
    echo "Checking Cardano node sync status..."
    SYNC_PROGRESS=$($CARDANO_CLI query tip $NETWORK | jq -r '.syncProgress')
    if [ "$SYNC_PROGRESS" != "100.00" ]; then
        echo -e "${RED}Error: Cardano node is not fully synced (${SYNC_PROGRESS}%)${NC}"
        echo "Please wait for full synchronization before proceeding."
        exit 1
    fi
    echo -e "${GREEN}Cardano node is fully synced${NC}"
}

# Check for required files
check_requirements() {
    echo "Checking requirements..."
    
    # Check for payment keys
    if [ ! -f "$CONFIG_DIR/payment.skey" ] || [ ! -f "$CONFIG_DIR/payment.vkey" ]; then
        echo -e "${RED}Error: Payment keys not found${NC}"
        echo "Please ensure payment.skey and payment.vkey are in $CONFIG_DIR"
        exit 1
    }

    # Check for stake keys
    if [ ! -f "$CONFIG_DIR/stake.skey" ] || [ ! -f "$CONFIG_DIR/stake.vkey" ]; then
        echo -e "${RED}Error: Stake keys not found${NC}"
        echo "Please ensure stake.skey and stake.vkey are in $CONFIG_DIR"
        exit 1
    }

    echo -e "${GREEN}All required files present${NC}"
}

# Generate validator keys
generate_validator_keys() {
    echo "Generating validator keys..."
    $PARTNER_CHAINS_CLI key generate \
        --output-file "$CONFIG_DIR/validator-key.json"
    
    echo -e "${GREEN}Validator keys generated${NC}"
}

# Register validator
register_validator() {
    echo "Registering validator..."
    
    # Get current tip
    SLOT=$($CARDANO_CLI query tip $NETWORK | jq -r '.slot')
    
    # Create registration transaction
    $PARTNER_CHAINS_CLI registration create-transaction \
        --payment-signing-key-file "$CONFIG_DIR/payment.skey" \
        --payment-verification-key-file "$CONFIG_DIR/payment.vkey" \
        --stake-signing-key-file "$CONFIG_DIR/stake.skey" \
        --stake-verification-key-file "$CONFIG_DIR/stake.vkey" \
        --validator-key-file "$CONFIG_DIR/validator-key.json" \
        --testnet \
        --out-file "$CONFIG_DIR/registration.tx"
    
    # Sign transaction
    $CARDANO_CLI transaction sign \
        --tx-file "$CONFIG_DIR/registration.tx" \
        --signing-key-file "$CONFIG_DIR/payment.skey" \
        --signing-key-file "$CONFIG_DIR/stake.skey" \
        $NETWORK \
        --out-file "$CONFIG_DIR/registration.signed"
    
    # Submit transaction
    $CARDANO_CLI transaction submit \
        --tx-file "$CONFIG_DIR/registration.signed" \
        $NETWORK
    
    echo -e "${GREEN}Validator registration transaction submitted${NC}"
}

# Main execution
main() {
    check_sync_status
    check_requirements
    generate_validator_keys
    register_validator
    
    echo -e "${GREEN}Validator setup completed successfully${NC}"
    echo "Please update midnight/config/preview/config.json to enable the validator"
}

# Run main function
main
