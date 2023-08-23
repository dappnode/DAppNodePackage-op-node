#!/bin/sh

case $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET in
"geth.dnp.dappnode.eth")
  L1_RPC="http://geth.dappnode:8545"
  ;;
"nethermind.public.dappnode.eth")
  L1_RPC="http://nethermind.public.dappnode:8545"
  ;;
"erigon.dnp.dappnode.eth")
  L1_RPC="http://erigon.dappnode:8545"
  ;;
"besu.public.dappnode.eth")
  L1_RPC="http://besu.public.dappnode:8545"
  ;;
*)
  echo "Unknown value for _DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET: $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET"
  L1_RPC=$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET
  ;;
esac

case $L2_CLIENT in
"op-geth.dnp.dappnode.eth")
  L2_RPC="http://op-geth.dnp.dappnode:8545"
  JWT_PATH="/config/security/op-geth/jwtsecret.hex"
  ;;
"op-erigon.dnp.dappnode.eth")
  L2_RPC="http://op-erigon.dnp.dappnode:8545"
  JWT_PATH="/config/security/op-erigon/jwtsecret.hex"
  ;;
*)
  echo "Unknown value for L2_CLIENT: $L2_CLIENT"
  L2_RPC=$L2_CLIENT
  mkdir -p /config/security/user
  echo $USER_JWT >/config/security/user/jwtsecret.hex
  JWT_PATH="/config/security/user/jwtsecret.hex"
  ;;
esac

op-node --l1=$L1_RPC \
  --l2=$L2_RPC \
  --network=beta-1 \
  --rpc.addr=0.0.0.0 \
  --rpc.port=9545 \
  --l2.jwt-secret=$JWT_PATH \
  ${EXTRA_FLAGS}
