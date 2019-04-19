Fonero Core staging tree 0.13.0.5
===============================

## Development Resources

###### Resources:

- Whitepaper: [whitepaper.pdf](https://github.com/fonero-project/fonero/blob/master/fonero-docs/whitepaper.pdf)
- Official site: https://fonero.org
- Block explorer: https://explorer.fonero.org
- Sentinel: https://github.com/fonero-project/fonero-sentinel
- Masternodes: https://github.com/fonero-project/fonero/blob/master/MASTERNODE.md

###### Exchanges:  
- Dexas: https://dex.as/market/DEXAS.FNO_DEXAS.BTC
- Stocks.exchange: https://app.stocks.exchange/en/basic-trade/pair/BTC/FNO/1D
- Btc-trade.com.ua: https://btc-trade.com.ua/stock/fno_uah
- Crex24.com [close]: https://crex24.com/exchange/FNO-BTC

###### Nodes:  
- addnode=85.10.194.14:19190
- addnode=188.40.62.51:19190
- addnode=37.9.52.254:19190
- addnode=37.9.52.253:19190
- addnode=37.9.52.252:19190
- addnode=5.188.205.146:19190
- addnode=5.188.205.112:19190
- addnode=5.188.204.7:19190
- addnode=5.188.204.5:19190
- addnode=5.188.204.4:19190
- addnode=5.188.204.3:19190
- addnode=5.188.63.248:19190
- addnode=5.188.63.247:19190
- addnode=5.188.63.102:19190
- addnode=5.188.63.50:19190
- addnode=37.9.52.17:19190
- addnode=37.9.52.16:19190
- addnode=193.47.33.49:19190
- addnode=193.47.33.48:19190
- addnode=193.47.33.47:19190
- addnode=193.47.33.46:19190
- addnode=193.47.33.45:19190
- addnode=193.47.33.44:19190
- addnode=193.47.33.43:19190
- addnode=193.47.33.42:19190
- addnode=193.47.33.41:19190
- addnode=193.47.33.40:19190
- addnode=193.47.33.39:19190
- addnode=193.47.33.38:19190
- addnode=193.47.33.37:19190
- addnode=5.188.205.161:19190

License
-------

Fonero Core is released under the terms of the MIT license. See [COPYING](COPYING) for more
information or see https://opensource.org/licenses/MIT.

Development Process
-------------------

The `master` branch is meant to be stable. Development is normally done in separate branches.
[Tags](https://github.com/fonero-project/fonero/tags) are created to indicate new official,
stable release versions of Fonero Core.

The contribution workflow is described in [CONTRIBUTING.md](CONTRIBUTING.md).

Testing
-------

Testing and code review is the bottleneck for development; we get more pull
requests than we can review and test on short notice. Please be patient and help out by testing
other people's pull requests, and remember this is a security-critical project where any mistake might cost people
lots of money.

### Automated Testing

Developers are strongly encouraged to write [unit tests](/doc/unit-tests.md) for new code, and to
submit new unit tests for old code. Unit tests can be compiled and run
(assuming they weren't disabled in configure) with: `make check`

There are also [regression and integration tests](/qa) of the RPC interface, written
in Python, that are run automatically on the build server.
These tests can be run (if the [test dependencies](/qa) are installed) with: `qa/pull-tester/rpc-tests.py`

The Travis CI system makes sure that every pull request is built for Windows
and Linux, OS X, and that unit and sanity tests are automatically run.

### Manual Quality Assurance (QA) Testing

Changes should be tested by somebody other than the developer who wrote the
code. This is especially important for large or high-risk changes. It is useful
to add a test plan to the pull request description if testing the changes is
not straightforward.

### MacOS SDK

cd depends  
wget https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/MacOSX10.11.sdk.tar.xz  
tar vxf MacOSX10.11.sdk.tar.xz  
make HOST=x86_64-apple-darwin11 SDK_PATH=$PWD -j8  
