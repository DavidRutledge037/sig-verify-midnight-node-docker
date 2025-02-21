#!/bin/bash

CONFIG_DIR="cardano/config/preview/cardano-node"

# Download preview network configuration files
wget -P ${CONFIG_DIR} https://raw.githubusercontent.com/input-output-hk/cardano-world/master/docs/environments/preview/config.json
wget -P ${CONFIG_DIR} https://raw.githubusercontent.com/input-output-hk/cardano-world/master/docs/environments/preview/topology.json
wget -P ${CONFIG_DIR} https://raw.githubusercontent.com/input-output-hk/cardano-world/master/docs/environments/preview/byron-genesis.json
wget -P ${CONFIG_DIR} https://raw.githubusercontent.com/input-output-hk/cardano-world/master/docs/environments/preview/shelley-genesis.json
wget -P ${CONFIG_DIR} https://raw.githubusercontent.com/input-output-hk/cardano-world/master/docs/environments/preview/alonzo-genesis.json
wget -P ${CONFIG_DIR} https://raw.githubusercontent.com/input-output-hk/cardano-world/master/docs/environments/preview/conway-genesis.json
