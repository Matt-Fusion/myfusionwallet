'use strict';
var walletBalanceCtrl = function ($scope, $sce, walletService, $rootScope) {
    $scope.init = function () {
        if (!$scope.tx || !$scope.wallet) {
            return
        }
        $scope.getShortAddressNotation();
        $scope.getBalance();
    };
    $scope.mayRunState = false;
    $scope.provider;
    $scope.addressNotation = {'value': '', 'state': ''};
    $scope.ajaxReq = ajaxReq;
    $scope.requestedSAN = false;
    $scope.viewDetailsModal = new Modal(document.getElementById('viewDetailsModal'));
    walletService.wallet = null;
    walletService.password = '';
    $scope.tokensLoaded = false;
    $scope.showAllTokens = false;
    $scope.inputPassword = '';
    $scope.showPkState = false;
    $scope.localToken = {
        contractAdd: "",
        symbol: "",
        decimals: "",
        type: "custom",
    };

    $scope.slide = 1;

    $scope.customTokenField = false;

    $scope.saveTokenToLocal = function () {
        globalFuncs.saveTokenToLocal($scope.localToken, function (data) {
            if (!data.error) {
                $scope.addressDrtv.ensAddressField = "";
                $scope.localToken = {
                    contractAdd: "",
                    symbol: "",
                    decimals: "",
                    type: "custom"
                };
                $scope.wallet.setTokens();
                $scope.validateLocalToken = $sce.trustAsHtml('');
                $scope.customTokenField = false;
            } else {
                $scope.notifier.danger(data.msg);
            }
        });
    }


    $scope.setAndVerifyBalance = function (token) {
        if (token.balance == 'Click to Load') {
            token.balance = 'loading';

            token.setBalance(function () {
                var autoTokens = globalFuncs.localStorage.getItem('autoLoadTokens')
                $scope.autoLoadTokens = autoTokens ? JSON.parse(autoTokens) : [];

                console.log(token.balance)
                console.log(token.contractAddress)

                if (parseInt(token.balance) > 0) {
                    $scope.autoLoadTokens.push(token.contractAddress);
                    globalFuncs.localStorage.setItem('autoLoadTokens', JSON.stringify($scope.autoLoadTokens));
                    console.log(token)
                }
            });
        }
    }

    $scope.showPk = function (set) {
        if (set === 'show') {
            if ($scope.inputPassword === walletService.password) {
                $scope.$eval(function () {
                    $scope.showPkState = true;
                })
            } else {
                $scope.$eval(function () {
                    $scope.showPkState = false;
                })
            }
        }
        if (set === 'hide') {
            $scope.$eval(function () {
                $scope.inputPassword = '';
                $scope.showPkState = false;
            })
        }
    }

    $scope.viewDetailsModalClose = function () {
        $scope.inputPassword = '';
        $scope.showPk('hide');
        $scope.viewDetailsModal.close();

    };


    $scope.$watch('wallet', function () {
        if ($scope.wallet === null) {
            $scope.mayRunState = false;
        } else {
            $scope.mayRunState = true;
            $scope.init();
        }
    });

    // $scope.reverseLookup = function() {
    // var _ens = new ens();
    // _ens.getName($scope.wallet.getAddressString().substring(2) + '.addr.reverse', function(data) {
    // if (data.error) uiFuncs.notifier.danger(data.msg);
    // else if (data.data == '0x') {
    // $scope.showens = false;
    // } else {
    // $scope.ensAddress = data.data;
    // $scope.showens = true;
    // }
    // });
    // }
    //

    $scope.removeTokenFromLocal = function (tokensymbol) {
        globalFuncs.removeTokenFromLocal(tokensymbol, $scope.wallet.tokenObjs);
        $rootScope.rootScopeShowRawTx = false;
    }

    $scope.showDisplayOnTrezor = function () {
        return ($scope.wallet != null && $scope.wallet.hwType === 'trezor');
    }

    $scope.displayOnTrezor = function () {
        TrezorConnect.ethereumGetAddress({
            path: $scope.wallet.path,
            showOnTrezor: true
        });
    }

    $scope.showDisplayOnLedger = function () {
        return ($scope.wallet != null && $scope.wallet.hwType === 'ledger');
    }

    $scope.displayOnLedger = function () {
        var app = new ledgerEth($scope.wallet.getHWTransport());
        app.getAddress($scope.wallet.path, function () {
        }, true, false);
    }

    $scope.countDecimals = function (decimals) {
        let returnDecimals = '1';
        for (let i = 0; i < decimals; i++) {
            returnDecimals += '0';
        }
        return parseInt(returnDecimals);
    }

    setInterval(function () {
        if (!$scope.tx || !$scope.wallet) {
            return
        }
        $scope.getBalance();
        $scope.getShortAddressNotation();
    }, 15000);

    $scope.toHexString = function (byteArray) {
        var s = '0x';
        byteArray.forEach(function (byte) {
            s += ('0' + (byte & 0xFF).toString(16)).slice(-2);
        });
        return s;
    }

    $scope.getBalance = async function () {
        if ($scope.mayRunState = true) {
            let accountData = uiFuncs.getTxData($scope);
            let walletAddress = accountData.from;
            let balance = '';

            await web3.fsn.getBalance("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", walletAddress).then(function (res) {
                balance = res;
            });

            balance = balance / $scope.countDecimals(18);
            $scope.$apply(function () {
                $scope.web3WalletBalance = balance;
                $scope.web3WalletBalance = balance;
            });
        }
    }


    $scope.getShortAddressNotation = async function () {
        if ($scope.mayRunState = true) {
            let accountData = uiFuncs.getTxData($scope);
            let walletAddress = accountData.from;
            let notation = '';

            await web3.fsn.getNotation(walletAddress).then(function (res) {
                notation = res;
            });


            if ($scope.requestedSAN == false) {
                $scope.addressNotation.value = 'It looks like you don’t have a Short Account Number (SAN) yet. Fusion’s SAN is an 8 character version of your wallet address that’s as easy to remember as your phone number. Click the button below to generate one.';
            }

            if ($scope.requestedSAN == true) {
                $scope.addressNotation.value = 'USAN Requested';
            }

            if (notation === 0) {
                $scope.addressNotation.state = false;
            } else {
                $scope.addressNotation.state = true;
                $scope.$apply(function () {
                    $scope.addressNotation.value = notation;
                    $scope.addressNotation.value = notation;
                });
            }

            return notation;
        }
    }


    $scope.setShortAddressNotation = async function () {
        if ($scope.mayRunState = true) {
            let accountData = uiFuncs.getTxData($scope);
            let walletAddress = accountData.from;

            if ($scope.wallet.hwType === 'ledger') {
                // debugger
                // var app = new ledgerEth($scope.wallet.getHWTransport());
                //
                // // app.getAddress($scope.wallet.path, function () {
                // // }, true, false);
                //
                // await web3.fsntx.buildGenNotationTx(
                //     {
                //         from: walletAddress
                //     }
                // ).then((tx) => {
                //     let txToSign = ethUtil.rlp.encode(tx);
                //     console.log(tx);
                //     console.log(txToSign);
                //     app.signTransaction($scope.wallet.path, txToSign.toString('hex'), function () {
                //     })
                //
                // })

                debugger
                let data = '';
                await web3.fsntx.buildGenNotationTx(
                    {from: walletAddress}
                ).then((tx) => {
                    data = tx;
                    console.log(tx);
                })

                let txData = {
                    to: data.to,
                    value: data.value,
                    gasLimit: "0x1E8480",
                    from: $scope.wallet.getAddressString(),
                    data: data.input,
                    privKey: $scope.wallet.privKey ? $scope.wallet.getPrivateKeyString() : '',
                    path: $scope.wallet.getPath(),
                    hwType: $scope.wallet.getHWType(),
                    hwTransport: $scope.wallet.getHWTransport()
                }

                var rawTx = {
                    chainId: 1,
                    nonce: ethFuncs.sanitizeHex(data.nonce),
                    gasLimit: "0x1E8480",
                    to: ethFuncs.sanitizeHex(txData.to),
                    value: txData.value,
                    data: ethFuncs.sanitizeHex(txData.data),
                    input: ethFuncs.sanitizeHex(txData.data)
                }
                if (ajaxReq.eip155) rawTx.chainId = ajaxReq.chainId;
                rawTx.data = rawTx.data == '' ? '0x' : rawTx.data;
                var eTx = new ethUtil.Tx(rawTx);
                if (txData.hwType == "ledger") {
                    var app = new ledgerEth(txData.hwTransport);
                    var EIP155Supported = false;
                    var localCallback = function (result, error) {
                        if (typeof error != "undefined") {
                            if (callback !== undefined) callback({
                                isError: true,
                                error: error
                            });
                            return;
                        }
                        var splitVersion = result['version'].split('.');
                        if (parseInt(splitVersion[0]) > 1) {
                            EIP155Supported = true;
                        } else if (parseInt(splitVersion[1]) > 0) {
                            EIP155Supported = true;
                        } else if (parseInt(splitVersion[2]) > 2) {
                            EIP155Supported = true;
                        }

                        uiFuncs.signTxLedger(app, eTx, rawTx, txData, !EIP155Supported, function (res) {
                            uiFuncs.sendTx(res.signedTx, function (resp) {
                                if (!resp.isError) {
                                    $scope.notifier.success('Working', 0);
                                } else {
                                    $scope.notifier.danger(resp.error);
                                }
                            })
                        });


                        console.log(app);
                        console.log(eTx);
                        console.log(rawTx);
                        console.log(txData);

                    }
                    app.getAppConfiguration(localCallback);
                }
            } else {

                if (!$scope.account) {
                    $scope.account = web3.eth.accounts.privateKeyToAccount($scope.toHexString($scope.wallet.getPrivateKey()));
                }

                await web3.fsntx.buildGenNotationTx({
                    from: walletAddress
                }).then((tx) => {
                    console.log(tx);
                    return web3.fsn.signAndTransmit(tx, $scope.account.signTransaction).then(txHash => {
                        $scope.requestedSAN = true;
                        $scope.$apply(function () {
                            $scope.addressNotation.value = 'USAN Requested';
                            $scope.addressNotation.value = 'USAN Requested';
                        });
                    })
                });
                await $scope.getShortAddressNotation();
            }
        }
    }
};

module.exports = walletBalanceCtrl;
