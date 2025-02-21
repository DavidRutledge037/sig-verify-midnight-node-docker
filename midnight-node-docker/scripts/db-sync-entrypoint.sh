#!/bin/bash
set -e

# Create directory and symlink
mkdir -p /node-ipc
ln -sf /ipc/node.socket /node-ipc/node.socket

# Run the original command
exec "$@"
