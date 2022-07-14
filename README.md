<img align="right" width="150" height="150" top="100" src="./assets/shield.png">

# huffers • [![ci](https://github.com/huff-language/huffers/actions/workflows/ci.yml/badge.svg)](https://github.com/huff-language/huffers/actions/workflows/ci.yml) ![license](https://img.shields.io/github/license/huff-language/huffers?label=license) ![solidity](https://img.shields.io/badge/solidity-^0.8.15-lightgrey)

Fully Onchain Badges for [Huff Language](https://huff.sh) GitHub Contributors.


## Overview

[huffers](https://github.com/huff-language/huffers) are onchain dynamically-rendered svg nft badges that are based off of [renoun](https://github.com/Jon-Becker/renoun).

**Deployment Status**

[Polygon] [`Shield`](./src/Shield.sol): `0x0` [WIP]
[Polygon] [`BadgeRenderer`](./src/BadgeRenderer.sol): `0x0` [WIP]


## Blueprint

```ml
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
├─ solmate — https://github.com/Rari-Capital/solmate
scripts
├─ Deploy.s.sol — Deployment Script
src
├─ interfaces
|  └─ IBadgeRenderer — BadgeRenderer Interface
├─ BadgeRenderer — The renderer for Shields
├─ base64 — The base64 encoding library
├─ Shield — A contribution badge for Huff Language GitHub Contributors
test
└─ Integration — Integration Tests
```


## License

[AGPL-3.0-only](https://github.com/huff-language/huffers/blob/master/LICENSE)


## Acknowledgements

- [renoun](https://github.com/Jon-Becker/renoun)
- [femplate](https://github.com/abigger87/femplate)
- [foundry](https://github.com/foundry-rs/foundry)
- [solmate](https://github.com/Rari-Capital/solmate)
- [forge-std](https://github.com/brockelmore/forge-std)


## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._
