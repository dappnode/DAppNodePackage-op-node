#!/bin/sh

# If CUSTOM_L1_RPC is set, use it. Otherwise, use the proper value depending on the _DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET variable
if [ ! -z "$CUSTOM_L1_RPC" ]; then
  L1_RPC=$CUSTOM_L1_RPC
  L1_RPC_TRUST=false
elif [ ! -z "$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET" ]; then
  case $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_MAINNET in
  "geth.dnp.dappnode.eth")
    L1_RPC="http://geth.dappnode:8545"
    L1_RPC_TRUST=true
    ;;
  "nethermind.public.dappnode.eth")
    L1_RPC="http://nethermind.public.dappnode:8545"
    L1_RPC_TRUST=true
    ;;
  "erigon.dnp.dappnode.eth")
    L1_RPC="http://erigon.dappnode:8545"
    L1_RPC_TRUST=true
    ;;
  "besu.public.dappnode.eth")
    L1_RPC="http://besu.public.dappnode:8545"
    L1_RPC_TRUST=true
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

case $_DAPPNODE_GLOBAL_OP_EXECUTION_CLIENT in
"op-geth.dnp.dappnode.eth")
  L2_ENGINE="http://op-geth.dappnode:8551"
  JWT_PATH="/security/op-geth/jwtsecret.hex"
  ;;
"op-erigon.dnp.dappnode.eth")
  L2_ENGINE="http://op-erigon.dappnode:8551"
  JWT_PATH="/security/op-erigon/jwtsecret.hex"
  ;;
*)
  echo "Unknown value for _DAPPNODE_GLOBAL_OP_EXECUTION_CLIENT: $_DAPPNODE_GLOBAL_OP_EXECUTION_CLIENT"
  sleep 60
  exit 1
  ;;
esac

while true; do
  op-node --network=mainnet \
    --l1="$L1_RPC" \
    --l1.trust.rpc=$L1_RPC_TRUST \
    --l2="$L2_ENGINE" \
    --l2.jwt-secret="$JWT_PATH" \
    --rpc.addr=0.0.0.0 \
    --rpc.port=9545 \
    ${EXTRA_OPTS}

  STATUS=$?

  if [ $STATUS -ne 0 ]; then
    echo "[ERROR - entrypoint ] op-node command failed with status $STATUS. Retrying in 1 minute..."
    echo "[ERROR - entrypoint ] L2 Client might be unreachable or not ready yet (downloading chain data can take hours)"
    sleep 60
  else
    break
  fi
done
