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

exec op-node --network=mainnet \
  --l1=$L1_RPC \
  --l2=$L2_ENGINE \
  --l2.jwt-secret=$JWT_PATH \
  --rpc.addr=0.0.0.0 \
  --rpc.port=9545 \
  ${EXTRA_FLAGS}
