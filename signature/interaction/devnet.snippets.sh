WALLET_PEM="../../../../../dev-wallet/main1.pem"
PROXY="https://devnet-gateway.multiversx.com"
CHAIN_ID="D"

# UPDATE THIS AFTER EACH DEPLOY
VILLAGERS_ADDRESS="erd1qqqqqqqqqqqqqpgq50tqyfdlsffxeu8yhc9vshfl8zz3r50x4juswlk8mc"

# . ./devnet.snippets.sh && deploy
deploy() {
    mxpy --verbose contract deploy --recall-nonce \
        --metadata-payable \
        --pem=${WALLET_PEM} \
        --gas-limit=100000000 \
        --proxy=${PROXY} --chain=${CHAIN_ID} \
        --bytecode="../output/signature.wasm" \
        --outfile="deploy.interaction.json" --send || return

    ADDRESS=$(mxpy data parse --file="deploy.interaction.json" --expression="data['contractAddress']")

    echo ""
    echo "Smart Contract address: ${ADDRESS}"
}

# . ./devnet.snippets.sh && upgrade
upgrade() {
    mxpy --verbose contract upgrade ${VILLAGERS_ADDRESS} --recall-nonce \
        --metadata-payable \
        --pem=${WALLET_PEM} \
        --gas-limit=100000000 \
        --proxy=${PROXY} --chain=${CHAIN_ID} \
        --bytecode="../output/signature.wasm" \
        --outfile="deploy.interaction.json" --send || return

    ADDRESS=$(mxpy data parse --file="deploy.interaction.json" --expression="data['contractAddress']")

    echo ""
    echo "Smart Contract address: ${ADDRESS}"
}

# . ./devnet.snippets.sh && verify 0x6d6573616a31 0xdbebd5d008fbcf619bd74c580d55a6d9a9051730b834ccddbdefc66047c792b91d9fbca205a6474afdabf297e13631a5f55da32b1994a36dafbb19bc0bc44309
verify() {
    mxpy --verbose contract call ${VILLAGERS_ADDRESS}  --recall-nonce \
        --pem=${WALLET_PEM} \
        --gas-limit=10000000 \
        --proxy=${PROXY} --chain=${CHAIN_ID} \
        --arguments $1 $2  \
        --function="verify" \
        --outfile="deploy.interaction.json" --send || return

    ADDRESS=$(mxpy data parse --file="deploy.interaction.json" --expression="data['contractAddress']")

    echo ""
    echo "Smart Contract address: ${ADDRESS}"
}
