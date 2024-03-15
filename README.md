<div style="text-align:center;">

# Lenx Lending (Fraxlend Fork)
[![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: ISC][license-badge]][license]

[gha]: https://github.com/lenx-finance/lenx-lending/actions
[gha-badge]: https://github.com/lenx-finance/lenx-lending/actions/workflows/test.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/license/ISC
[license-badge]: https://img.shields.io/badge/License-ISC-blue.svg

For guidance, refer to the Fraxlend [docs](https://docs.frax.finance/fraxlend/fraxlend-overview).
</div>

![https://github.com/FraxFinance/fraxlend/raw/main/documentation/_images/PairOverview.png](https://github.com/FraxFinance/fraxlend/raw/main/documentation/_images/PairOverview.png)

## 1. Overview

Lenx Lending is a lending platform that allows anyone to create a market between a pair of ERC-20 tokens. 
Any token part of a Chainlink data feed can be lent to borrowers or used as collateral.  Each pair is an isolated, 
permission-less market which allows anyone to create and participate in lending and borrowing activities. 
Lenx Lending adheres to the EIP-4626: Tokenized Vault Standard, lenders are able to deposit ERC-20 assets into the 
pair and receive yield-bearing fTokens.

## 2. Install Dependencies

Install dependencies with npm.
```shell
npm install
```

## 3. Build, Test, Lint, and Deploy

### a. Build (Compile Smart Contracts)

```shell
forge build
```

### b. Test (Run Tests)    

```shell
forge test --rpc-url 
```

### c. Lint (Lint Code)

```shell
forge fmt
```

### d. Deploying to a network

Copy `.env.example` to `.env` and configure the parameters.

```shell
cp .env.example .env
```
Add your private key, RPC URL, and Etherscan API key to the `.env` file.

Run the deployment script.
```shell
source .env && 
forge script CONTRACT_TO_DEPLOY \
 --rpc-url $RPC_URL \
 --private-key $PRIVATE_KEY \
  --etherscan-api-key $ETHERSCAN_KEY \
  --verify \
  --broadcast
```

### e. Deploying to a local network

1) Copy `.env.example` to `.env` to configure the parameters.

2) Add `http://127.0.0.1:8545` as an RPC to metamask.

3) Add `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80` as an acocunt to metamask.

```shell
cp .env.example .env
```

```shell
source .env && 
anvil --fork-url $RPC_URL
```

```shell
source .env &&
forge script DeployFraxlend \
 --rpc-url http://127.0.0.1:8545 \
 --private-key $PRIVATE_KEY \
 --broadcast
```

#### Sepolia

| Contract Name          | Address                                                                                                                    |
|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| FraxlendPairHelper    | [0x000000e431149B554d6f3f58aa2e70a55FfFb7CA](https://sepolia.etherscan.io/address/0x000000e431149B554d6f3f58aa2e70a55FfFb7CA) |
| FraxlendPairDeployer  | [0x0000003a42E37Fd604C985e0c71181048CDfF1e2](https://sepolia.etherscan.io/address/0x0000003a42E37Fd604C985e0c71181048CDfF1e2) |
| VariableInterestRate  | [0x0000002d9b19BCc7BE22550b716921436C445144](https://sepolia.etherscan.io/address/0x0000002d9b19BCc7BE22550b716921436C445144) |
| LinearInterestRate    | [0x000000F002E6DC71B373B30a274f16a126609960](https://sepolia.etherscan.io/address/0x000000F002E6DC71B373B30a274f16a126609960) |


#### Holesky

| Contract Name          | Address                                                                                                                    |
|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| FraxlendPairHelper    | [0x000000e431149B554d6f3f58aa2e70a55FfFb7CA](https://holesky.etherscan.io/address/0x000000e431149B554d6f3f58aa2e70a55FfFb7CA) |
| FraxlendPairDeployer  | [0x0000003a42E37Fd604C985e0c71181048CDfF1e2](https://holesky.etherscan.io/address/0x0000003a42E37Fd604C985e0c71181048CDfF1e2) |
| VariableInterestRate  | [0x0000002d9b19BCc7BE22550b716921436C445144](https://holesky.etherscan.io/address/0x0000002d9b19BCc7BE22550b716921436C445144) |
| LinearInterestRate    | [0x000000F002E6DC71B373B30a274f16a126609960](https://holesky.etherscan.io/address/0x000000F002E6DC71B373B30a274f16a126609960) |


## 4. License
Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, 
provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, 
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
OF THIS SOFTWARE.