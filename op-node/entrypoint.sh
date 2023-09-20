#!/bin/sh

# If CUSTOM_L1_RPC is set, use it. Otherwise, use the proper value depending on the _DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET variable
if [ ! -z "$CUSTOM_L1_RPC" ]; then
  L1_RPC=$CUSTOM_L1_RPC
elif [ ! -z "$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET" ]; then
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
    sleep 60
    exit 1
    ;;
  esac
else
  echo "No L1_RPC value set"
  sleep 60
  exit 1
fi

case $L2_CLIENT in
"op-geth.dnp.dappnode.eth")
  L2_ENGINE="http://op-geth.dappnode:8551"
  JWT_PATH="/security/op-geth/jwtsecret.hex"
  ;;
"op-erigon.dnp.dappnode.eth")
  L2_ENGINE="http://op-erigon.dappnode:8551"
  JWT_PATH="/security/op-erigon/jwtsecret.hex"
  ;;
*)
  echo "Unknown value for L2_CLIENT: $L2_CLIENT"
  L2_ENGINE=$L2_CLIENT
  mkdir -p /config/security/user
  echo $USER_JWT >/security/user/jwtsecret.hex
  JWT_PATH="/security/user/jwtsecret.hex"
  ;;
esac

exec op-node --network=mainnet \
  --l1=$L1_RPC \
  --l2=$L2_ENGINE \
  --l2.jwt-secret=$JWT_PATH \
  --rpc.addr=0.0.0.0 \
  --rpc.port=9545 \
  ${EXTRA_FLAGS}
