<div style="text-align:center;">

# Fraxlend
[![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: ISC][license-badge]][license]

[gha]: https://github.com/lenx-finance/fraxlend/actions
[gha-badge]: https://github.com/lenx-finance/fraxlend/actions/workflows/test.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/license/ISC
[license-badge]: https://img.shields.io/badge/License-ISC-blue.svg

For guidance, refer to the Fraxlend [docs](https://docs.frax.finance/fraxlend/fraxlend-overview).
</div>

## Overview

  Fraxlend is a lending platform that allows anyone to create a market between a pair of ERC-20 tokens. Any token part of a Chainlink data feed can be lent to borrowers or used as collateral.  Each pair is an isolated, permission-less market which allows anyone to create and participate in lending and borrowing activities.

  Fraxlend adheres to the EIP-4626: Tokenized Vault Standard, lenders are able to deposit ERC-20 assets into the pair and receive yield-bearing fTokens.  

![https://github.com/FraxFinance/fraxlend/raw/main/documentation/_images/PairOverview.png](https://github.com/FraxFinance/fraxlend/raw/main/documentation/_images/PairOverview.png)

### Dependencies

```shell
npm install
```

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Lint

```shell
forge fmt
```

<!-- ### Deploy

Copy `.env.example` to `.env` and configure the parameters.

```shell
cp .env.example .env
```

Run the deployment script.

```shell
source .env && forge script DeployCounter --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_KEY --verify --broadcast
``` -->

## License
Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
