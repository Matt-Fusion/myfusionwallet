<!-- Content -->

<div class="col-sm-3">
    <wallet-balance-drtv></wallet-balance-drtv>
</div>

<div class="col-sm-9">
    <!-- FUSION Assets -->
    <div class="row">
        <div class="col-md-6">
            <h3>Assets</h3>
        </div>
        <div class="col-md-6">
            <div class="float-right">
                <a class="btn btn-sm btn-secondary"
                   data-toggle="modal"
                   data-target="#createAsset"
                   ng-click="createAssetInit()"
                >
                    <i class="fa fa-plus"></i> Create Asset
                </a>
                <a class="btn btn-sm btn-primary"
                   ng-click="sendAssetModalOpen(); transactionType = 'none';"
                >
                    Send Assets
                </a></div>
        </div>
    </div>
    <article class="block" ng-hide="wallet.type=='addressOnly'">
        <section class="row form-group">
            <div class="col-sm-12 clearfix">
                <p class="p-2">The Assets section provides an overview of all the digital assets that are currently in
                    your Fusion PSN wallet.</p>
            </div>

            <div class="col-sm-12 clearfix text-center" ng-show="showNoAssets">
                <h4 class="small-gray-text">No available assets</h4>
            </div>

            <div class="col-sm-12 clearfix text-center" ng-show="assetListLoading">
                <h4 class="text-center">
                    <i class="fa fa-spinner" aria-hidden="true"></i>
                </h4>
                <h4 class="small-gray-text text-center">Loading assets</h4>

            </div>


            <div class="col-sm-12 clearfix" data-ng-init="getAllFsnAssets()">
                <div class="table-responsive" ng-show="assetListOwns != ''">
                    <table class="table">
                        <thead>
                        <tr class="small-gray-text text-left">
                            <th scope="col">Asset Name</th>
                            <th scope="col">Asset Info</th>
                            <th scope="col" class="text-right">Available</th>
                            <th scope="col" class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>

                        <tr ng-repeat="asset in assetListOwns track by $index">
                            <td>{{asset.name}} ({{asset.symbol}}) <span class="color-Active official-fusion-badge"
                                                                        ng-show="asset.contractaddress === '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'"><i
                                            class="fa fa-check-circle"></i> FSN Official</span> <br>
                                <div class="max-char">
                                    <span class="small-gray-text" data-toggle="tooltip" data-placement="top"
                                          title="{{asset.contractaddress}}">ID: {{asset.contractaddress}}</span>
                                </div>
                            </td>
                            <td><span class="badge badge-secondary m-1">Fusion Asset</span>
                                <br>
                                <span class="created m-1" ng-hide="asset.owner == ''">{{asset.owner}}</span>

                            </td>
                            <td class="text-right">{{asset.balance}} <br> <span class="small-gray-text"></span></td>
                            <td class="text-right">
                                <span ng-init="f = $index" style="display:none;"></span>
                                <button class="btn-sm btn-white action-button p-0"
                                        ng-click="sendAssetModalOpen(f, false)">Send
                                </button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </article>

    <div class="row">
        <div class="col-md-12">
            <h3>Time-Locked Assets</h3>
        </div>
    </div>
    <article class="block" ng-hide="wallet.type=='addressOnly'">
        <section class="row form-group">
            <div class="col-sm-12 clearfix">
                <p class="p-2">The Time-lock Assets section provides all relevant information about the time-locked
                    digital assets in your wallet.</p>
            </div>


            <div class="col-sm-12 clearfix text-center gray-bg p-2" ng-hide="timeLockList != ''">
                <h4 class="small-gray-text">No time-locked assets</h4>
            </div>

            <div class="col-sm-12 clearfix" ng-show="timeLockList != ''" data-ng-init="getTimeLockAssets()">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr class="small-gray-text text-left">
                            <th scope="col">Status</th>
                            <th scope="col">Asset Name</th>
                            <th scope="col">Time-lock Period</th>
                            <th scope="col">Amount</th>
                            <th scope="col">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr ng-repeat="asset in timeLockList track by $index"
                            ng-hide="asset.status === 'Expired'">
                            <td class="color-{{asset.status}}">● {{asset.status}}</td>
                            <td> {{asset.name}} ({{asset.symbol}}) <span class="color-Active official-fusion-badge"
                                                                         ng-show="asset.asset === '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'"><i
                                            class="fa fa-check-circle"></i> FSN Official</span>
                                <br>
                                <div class="max-char"><span class="small-gray-text" data-toggle="tooltip"
                                                            data-placement="top"
                                                            title="{{asset.asset}}">ID: {{asset.asset}}</span></div>
                            </td>
                            <td><span class="small-gray-text">From</span> {{asset.startTime}} <br><span
                                        class="small-gray-text">Until </span> {{asset.endTime}}</td>
                            <td>{{asset.value}}</td>
                            <td class="text-right">
                                <button class="btn-sm btn-white action-button p-0"
                                        ng-show="asset.status === 'Available'"
                                        data-toggle="tooltip"
                                        data-placement="top"
                                        title="Send back to Assets"
                                        ng-click="sendBackToAssets(asset.id)">
                                    <img src="images/group-5.svg" class="Group-6 m-0">
                                </button>
                                <button class="btn-sm btn-white action-button p-0" ng-hide="asset.status === 'Expired'"
                                        ng-click="sendAssetModalOpen(asset.id, true)"
                                >
                                    Send
                                </button>
                                <button class="btn-sm btn-white action-button p-0"
                                        ng-show="asset.status === 'Expired'"
                                        ng-click="hideExpired(asset.id)">
                                    Remove
                                </button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </article>
</div>

<div class="col-sm-9">
    <!-- If unlocked with address only -->
    <article class="block" ng-show="wallet.type=='addressOnly'">
        <div class="row form-group">
            <h4 translate="SEND_ViewOnly">
                You cannot send with only your address. You must use one of the other options to unlock your wallet in
                order to send.
            </h4>
            <h5 translate="X_HelpfulLinks">
                Helpful Links &amp; FAQs
            </h5>
            <ul>
                <li class="u__protip">
                    <a href="https://kb.myetherwallet.com/getting-started/accessing-your-new-eth-wallet.html"
                       target="_blank"
                       rel="noopener noreferrer"
                       translate="X_HelpfulLinks_1">
                        How to Access your Wallet
                    </a>
                </li>
                <li class="u__protip">
                    <a href="https://kb.myetherwallet.com/private-keys-passwords/lost-eth-private-key.html"
                       target="_blank"
                       rel="noopener noreferrer"
                       translate="X_HelpfulLinks_2">
                        I lost my private key
                    </a>
                </li>
                <li class="u__protip">
                    <a href="https://kb.myetherwallet.com/private-keys-passwords/accessing-different-address-same-private-key-ether.html"
                       target="_blank"
                       rel="noopener noreferrer"
                       translate="X_HelpfulLinks_3">
                        My private key opens a different address
                    </a>
                </li>
                <li class="u__protip">
                    <a href="https://kb.myetherwallet.com/migration/"
                       target="_blank"
                       rel="noopener noreferrer"
                       translate="X_HelpfulLinks_4">
                        Migrating to/from MyEtherWallet
                    </a>
                </li>
            </ul>
        </div>
    </article>


    <article class="modal fade" id="txModal" tabindex="-1">
        <section class="modal-dialog">
            <section class="modal-content">
                <article class="block" ng-hide="wallet.type=='addressOnly'">
                    <!-- If unlocked with PK -->
                    <article class="block" ng-hide="wallet.type=='addressOnly'">

                        <h3>Create Transaction</h3>
                        <!-- To Address -->
                        <div class="row form-group">
                            <address-field placeholder="0xDECAF9CD2367cdbb726E904cD6397eDFcAe6068D"
                                           var-name="tx.to"></address-field>
                        </div>


                        <!-- Amount to Send -->
                        <section class="row form-group">

                            <div class="col-sm-11">
                                <label translate="SEND_amount">
                                    Amount to Send:
                                </label>
                            </div>

                            <div class="col-sm-11">

                                <div class="input-group">

                                    <input type="text"
                                           class="form-control"
                                           placeholder="{{ 'SEND_amount_short' | translate }}"
                                           ng-model="tx.value"
                                           ng-disabled="tx.readOnly || checkTxReadOnly"
                                           ng-class="Validator.isPositiveNumber(tx.value) ? 'is-valid' : 'is-invalid'"/>

                                    <div class="input-group-btn">

                                        <a style="min-width: 170px"
                                           class="btn btn-default dropdown-toggle"
                                           class="dropdown-toggle"
                                           ng-click="dropdownAmount = !dropdownAmount"
                                           ng-class="dropdownEnabled ? '' : 'disabled'">
                                            <strong>
                                                {{unitReadable}}
                                                <i class="caret"></i>
                                            </strong>
                                        </a>

                                        <!-- Amount to Send - Dropdown -->
                                        <ul class="dropdown-menu dropdown-menu-right"
                                            ng-show="dropdownAmount && !tx.readOnly">
                                            <li>
                                                <a ng-class="{true:'active'}[tx.sendMode=='ether']"
                                                   ng-click="setSendMode('ether')">
                                                    {{ajaxReq.type}}
                                                </a>
                                            </li>
                                            <li ng-repeat="token in wallet.tokenObjs track by $index"
                                                ng-show="token.balance!=0 &&
                           token.balance!='loading' &&
                           token.balance!='Click to Load' &&
                           token.balance.trim()!='Not a valid ERC-20 token' ||
                           token.type!=='default'">
                                                <a ng-class="{true:'active'}[unitReadable == token.getSymbol()]"
                                                   ng-click="setSendMode('token', $index, token.getSymbol())">
                                                    {{token.getSymbol()}}
                                                </a>
                                            </li>
                                        </ul>

                                    </div>

                                </div>

                            </div>

                            <!-- Amount to Send - Load Token Balances
                            <a class="col-sm-1 send__load-tokens"
                               title="Load Token Balances"
                               ng-click="wallet.setTokens(); globalService.tokensLoaded=true"
                               ng-hide="globalService.tokensLoaded">
                                <img src="images/icon-load-tokens.svg" width="16" height="16" />
                                <p translate="SEND_LoadTokens">
                                  Load Tokens
                                </p>
                            </a>
                            -->

                            <!-- Amount to Send - Transfer Entire Balance -->
                            <p class="col-xs-12" ng-hide="tx.readOnly">
                                <a ng-click="transferAllBalance()">
          <span class="strong" translate="SEND_TransferTotal">
            Send Entire Balance
          </span>
                                </a>
                            </p>

                        </section>


                        <!-- Gas Limit -->
                        <section class="row form-group">
                            <div class="col-sm-11 clearfix">
                                <a class="account-help-icon"
                                   href="https://kb.myetherwallet.com/gas/what-is-gas-ethereum.html"
                                   target="_blank"
                                   rel="noopener noreferrer">
                                    <img src="images/icon-help.svg" class="help-icon"/>
                                    <p class="account-help-text" translate="GAS_LIMIT_Desc"></p>
                                </a>
                                <label translate="TRANS_gas">
                                    Gas Limit:
                                </label>
                                <input type="text"
                                       class="form-control"
                                       placeholder="21000"
                                       ng-model="tx.gasLimit"
                                       ng-change="gasLimitChanged=true"
                                       ng-disabled="tx.readOnly || checkTxReadOnly"
                                       ng-class="Validator.isPositiveNumber(tx.gasLimit) ? 'is-valid' : 'is-invalid'"/>
                            </div>
                        </section>

                        <!-- Advanced Option Panel -->
                        <a ng-click="showAdvance=true"
                           ng-show='globalService.currentTab==globalService.tabs.sendTransaction.id || tx.data != ""'>
                            <p class="strong" translate="TRANS_advanced">
                                + Advanced: Add Data
                            </p>
                        </a>


                        <div ng-show="showAdvance || checkTxPage">

                            <!-- Data -->
                            <section class="row form-group">
                                <div class="col-sm-11 clearfix" ng-show="tx.sendMode=='ether'">
          <span class="account-help-icon">
            <img src="images/icon-help.svg" class="help-icon"/>
            <p class="account-help-text" translate="OFFLINE_Step2_Label_6b">
              This is optional.
            </p>
          </span>

                                    <label translate="TRANS_data"> Data: </label>

                                    <input type="text"
                                           class="form-control"
                                           placeholder="0x6d79657468657277616c6c65742e636f6d20697320746865206265737421"
                                           ng-model="tx.data"
                                           ng-disabled="tx.readOnly || checkTxReadOnly"
                                           ng-class="Validator.isValidHex(tx.data) ? 'is-valid' : 'is-invalid'"/>

                                </div>
                            </section>


                            <!-- Nonce -->
                            <section class="row form-group" ng-show="checkTxPage">
                                <div class="col-sm-11 clearfix">

                                    <a class="account-help-icon"
                                       href="https://kb.myetherwallet.com/transactions/what-is-nonce.html"
                                       target="_blank"
                                       rel="noopener noreferrer">
                                        <img src="images/icon-help.svg" class="help-icon"/>
                                        <p class="account-help-text" translate="NONCE_Desc"></p>
                                    </a>

                                    <label translate="OFFLINE_Step2_Label_5">
                                        Nonce
                                    </label>
                                    <input type="text"
                                           class="form-control"
                                           placeholder="2"
                                           ng-model="tx.nonce"
                                           ng-disabled="checkTxReadOnly"
                                           ng-class="Validator.isPositiveNumber(tx.nonce) ? 'is-valid' : 'is-invalid'"/>

                                </div>
                            </section>


                            <!-- Gas Price -->
                            <section class="row form-group" ng-show="checkTxPage">
                                <div class="col-sm-11 clearfix">
                                    <a class="account-help-icon"
                                       href="https://kb.myetherwallet.com/gas/what-is-gas-ethereum.html"
                                       target="_blank"
                                       rel="noopener noreferrer">
                                        <img src="images/icon-help.svg" class="help-icon"/>
                                        <p class="account-help-text" translate="GAS_PRICE_Desc"></p>
                                    </a>

                                    <label translate="OFFLINE_Step2_Label_3">
                                        Gas Price:
                                    </label>
                                    <input type="text"
                                           class="form-control"
                                           placeholder="50"
                                           ng-model="tx.gasPrice"
                                           ng-disabled="checkTxReadOnly"
                                           ng-class="Validator.isPositiveNumber(tx.gasPrice) ? 'is-valid' : 'is-invalid'"/>

                                </div>
                            </section>

                        </div>
                        <!-- / Advanced Option Panel -->


                        <div class="clearfix form-group">
                            <div class="well" ng-show="wallet!=null && customGasMsg!=''">
                                <p>
          <span translate="SEND_CustomAddrMsg">
            A message regarding
          </span>
                                    {{tx.to}}
                                    <br/>
                                    <strong>
                                        {{customGasMsg}}
                                    </strong>
                                </p>
                            </div>
                        </div>


                        <div class="row form-group">
                            <div class="col-xs-12 clearfix">
                                <a class="btn btn-info btn-block"
                                   ng-click="generateTx()"
                                   translate="SEND_generate">
                                    Generate Transaction
                                </a>
                            </div>
                        </div>

                        <div class="row form-group" ng-show="rootScopeShowRawTx">

                            <div class="col-sm-6">
                                <label translate="SEND_raw">
                                    Raw Transaction
                                </label>
                                <textarea class="form-control" rows="4" readonly>{{rawTx}}</textarea>
                            </div>

                            <div class="col-sm-6">
                                <label translate="SEND_signed">
                                    Signed Transaction
                                </label>
                                <textarea class="form-control" rows="4" readonly>{{signedTx}}</textarea>
                            </div>

                        </div>

                        <div class="clearfix form-group" ng-show="rootScopeShowRawTx">
                            <a class="btn btn-primary btn-block col-sm-11"
                               data-toggle="modal"
                               data-target="#sendTransaction"
                               translate="SEND_trans"
                               ng-click="parseSignedTx( signedTx )">
                                Send Transaction
                            </a>
                        </div>


                    </article>
                </article>
            </section>
        </section>
    </article>

</div>
<article class="modal fade" id="sendAsset" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text" ng-click="sendAssetModal.close();">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <h3 ng-hide="showStaticTimeLockAsset === true">Send Asset</h3>
                <h3 ng-show="showStaticTimeLockAsset === true">Send Time-lock</h3>

                <div>
                    <section class="row form-group">
                        <div class="col-sm-12 clearfix">
                        </div>
                        <div class="col-sm-12 clearfix">
                            <span class="small-gray-text">
                                To Address:
                            </span>
                            <input type="text"
                                   class="form-control"
                                   ng-model="sendAsset.toAddress"
                                   placeholder="Enter a fusion address"/>
                        </div>

                        <div class="col-sm-12 mb-2" ng-show="showStaticAsset === true">
                            <div class="sendAssetBalanceAvailable">
                                <span class="text-fusion">{{assetName}}</span>
                                <div class="break-word">
                                    <span class="small-gray-text">{{assetToSend}}</span>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-12 clearfix">
                            <span class="small-gray-text" ng-hide="showStaticAsset === true">
                                Select Asset:
                            </span>
                            <select class="form-control" ng-model="assetToSend" ng-change="getAssetBalance()"
                                    ng-hide="showStaticAsset === true">
                                <option ng-repeat="asset in assetListOwns" value="{{asset.contractaddress}}">
                                    {{asset.symbol}}
                                    - {{asset.contractaddress}}
                                </option>
                            </select>
                            <div class="sendAssetBalanceAvailable" ng-hide="selectedAssetBalance == ''">
                                <span class="text-fusion">{{selectedAssetBalance}}</span> <span class="small-gray-text">available to send.</span>
                            </div>

                            <span class="small-gray-text">
                                Amount To Send:
                            </span>
                            <input type="text"
                                   class="form-control"
                                   min="0"
                                   ng-model="sendAsset.amountToSend"
                                   ng-class="{'is-invalid' : sendAsset.amountToSend > selectedAssetBalance}"
                                   placeholder="Enter an amount"/>
                            <div class="invalid-feedback" ng-show="sendAsset.amountToSend > selectedAssetBalance">
                                You don't have enough funds
                            </div>
                            <a class="small-gray-text" ng-click="setMaxBalance()" style="display:none;" ng-hide="selectedAssetBalance == ''">Send
                                Max</a>
                        </div>
                        <div class="col-md-12" ng-show="showStaticTimeLockAsset">
                            <div class="col-md-6 p-0">
                                <span class="small-gray-text">
                                        From
                                </span>
                                <br>
                                {{timeLockStartTime}}

                            </div>
                            <div class="col-md-6 p-0">
                                <span class="small-gray-text">
                                        Until
                                    </span>
                                <br>
                                {{timeLockEndTime}}

                            </div>
                        </div>
                        <div class="col-md-12" ng-hide="showStaticTimeLockAsset">
                            <span class="small-gray-text">
                                    Time-Lock
                                </span>
                            <br>
                            <div class="col-md-4 p-0 pb-2">
                                <button class="btn btn-sm btn-white w-100"
                                        ng-click="transactionType ='none'"
                                        ng-class="{'time-active' : transactionType == 'none'}"
                                >None
                                </button>
                            </div>
                            <div class="col-md-4 p-0 pb-2">
                                <button class="btn btn-sm btn-white w-100"
                                        ng-click="transactionType ='scheduled'"
                                        ng-class="{'time-active' : transactionType == 'scheduled'}"
                                >
                                    Date to Forever
                                </button>
                            </div>
                            <div class="col-md-4 p-0 pb-2">
                                <button class="btn btn-sm btn-white w-100"
                                        ng-click="transactionType ='daterange'"
                                        ng-class="{'time-active' : transactionType == 'daterange'}"
                                >
                                    Now to Date
                                </button>
                            </div>
                        </div>
                        <div ng-hide="transactionType =='none'">
                            <div class="col-md-6">
                            <span class="small-gray-text" ng-hide="transactionType == 'scheduled'">
                                    From
                            </span>
                                <span class="small-gray-text" ng-show="transactionType == 'scheduled'">
                                    From
                            </span>
                                <br>
                                <input class="form-control"
                                       type="date"
                                       ng-change="checkDate()"
                                       min="{{todayDate}}"
                                       onkeydown="return false"
                                       ng-model="sendAsset.fromTime"
                                       ng-show="transactionType == 'scheduled'"
                                >
                                <span class="b-form small-gray-text text-fusion fusion-text-14 p-1" ng-show="transactionType == 'daterange'">Now</span>

                            </div>
                            <span class="small-gray-text" ng-show="transactionType == 'scheduled'">
                                    Until
                            </span>
                            <br>
                            <div class="col-md-6 p-0" ng-show="transactionType == 'scheduled'">
                                <span class="b-form small-gray-text text-fusion fusion-text-14 p-1">∞ Forever</span>
                            </div>
                            <div class="col-md-6" ng-hide="transactionType == 'scheduled'">
                            <span class="small-gray-text">
                                    Until
                                </span>
                                <br>
                                <input class="form-control"
                                       type="date"
                                       ng-change="checkDate()"
                                       min="{{todayDate}}"
                                       onkeydown="return false"
                                       ng-model="sendAsset.tillTime">
                            </div>
                        </div>
                    </section>
                </div>
                <span class="small-gray-text" ng-show="wallet.balance < 0.00002">Insufficient funds to create transaction.</span>
                <div class="row form-group">
                    <div class="col-xs-6 clearfix">
                        <button class="btn btn-white btn-block"
                                ng-click="sendAssetModal.close()">
                            Cancel
                        </button>
                    </div>
                    <div class="col-xs-6 clearfix" ng-hide="wallet.balance < 0.00002">
                        <button class="btn btn-primary btn-block"
                                ng-click="sendAssetModalConfirm(assetToSend)"
                                ng-hide="showStaticTimeLockAsset"
                                ng-disabled="sendAsset.amountToSend > selectedAssetBalance; sendAsset.tillTime == ''; sendAsset.fromTime == '' ; sendAsset.amountToSend == ''; sendAsset.toAddress == '';">
                            Next
                        </button>
                        <button class="btn btn-primary btn-block"
                                ng-click="sendAssetModalConfirm(assetToSend)"
                                ng-show="showStaticTimeLockAsset"
                                ng-disabled="sendAsset.amountToSend > selectedAssetBalance; sendAsset.amountToSend == ''; sendAsset.toAddress == '';">
                            Next
                        </button>
                    </div>
                </div>
            </article>

        </section>
    </section>
</article>

<article class="modal fade" id="sendBackToAssetsModal" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text" ng-click="sendBackToAssetsModal.close();">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <h3>Send Time-Lock to Asset</h3>

                <p class="small-gray-text">Send your time-locked asset and send it back to your assets.</p>
                <section class="row form-group">
                    <div class="col-sm-8">
                            <span class="small-gray-text">
                                Asset:
                            </span>
                        <div class="gray-bg p-1">
                            <span class="mono wallet-balance">{{sendAsset.assetName}} ({{sendAsset.assetSymbol}})</span>
                            <br>
                            <span class="small-gray-text text-fusion fusion-text-14">{{assetToSend}}</span>
                        </div>
                    </div>
                    <div class="col-sm-4">
                          <span class="small-gray-text">
                                Amount:
                            </span>
                        <div class="gray-bg p-1">
                            <span class="mono wallet-balance">{{selectedAssetBalance}}</span> <span
                                    class="small-gray-text text-fusion fusion-text-14">{{sendAsset.assetSymbol}}</span>
                        </div>
                    </div>
                </section>
                <div class="row form-group">
                    <div class="col-xs-6 clearfix">
                        <button class="btn btn-white btn-block"
                                ng-click="sendBackToAssetsModal.close()">
                            Cancel
                        </button>
                    </div>
                    <div class="col-xs-6 clearfix">
                        <button class="btn btn-primary btn-block"
                                ng-click="sendBackToAssetsFunction()">
                            Send to Assets
                        </button>
                    </div>
                </div>
            </article>

        </section>
    </section>
</article>
<article class="modal fade" id="sendAssetConfirm" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text" ng-click="sendAssetConfirm.close(); sendAsset.close()">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <h3>Review Your Transaction Details</h3>
                <p>
                    Please carefully read the details of your transaction below before sending the transaction.
                </p>

                <div class="col-md-12">
                    <section class="row form-group">
                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Your Address:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{wallet.getChecksumAddressString()}}</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Recepient Address:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{sendAsset.toAddress}}</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2" ng-show="transactionType == 'standard'">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Send Type:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">Standard Send</span>
                            </div>
                            <br>
                        </div>

                        <div class="border-gray-bottom pb-2 pt-2" ng-show="transactionType == 'timed'">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Send Type:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">Timed Send</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2 inline w-100">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Asset:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{sendAsset.assetName}} ({{sendAsset.assetSymbol}})
                                    </span>
                                <br>
                                <span class="small-gray-text">{{sendAsset.assetHash}}</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2 w-100 inline">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Amount:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">
                                    <span class="mono wallet-balance">  {{sendAsset.amountToSend}} </span>
                                    {{sendAsset.assetSymbol}}
                                </span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2 w-100 inline">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Gas Price:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">
                                    <span class="mono wallet-balance">0.00002</span>
                                    FSN
                                </span>
                            </div>
                            <br>
                        </div>


                        <div ng-hide="transactionType =='none'">
                            <div class="float-left border-gray-bottom pb-2 pt-2 w-50"
                                 ng-class="{'w-100' : transactionType == 'scheduled'}">
                                <span class="small-gray-text" ng-hide="transactionType =='scheduled'">
                                    From
                                </span>
                                <span class="small-gray-text" ng-show="transactionType =='scheduled'">
                                    From
                                </span>
                                <br>
                                <span class="fusion-text-14" ng-hide="transactionType == 'daterange'">{{sendAsset.fromTimeString}}</span>
                                <span class="fusion-text-14" ng-show="transactionType == 'daterange'">Now</span>
                            </div>
                            <div class="float-right border-gray-bottom pb-2 pt-2 w-50"
                                 ng-hide="transactionType == 'scheduled'">
                                <span class="small-gray-text">
                                    Until
                                </span>
                                <br>
                                <span class="fusion-text-14" ng-hide="transactionType == 'scheduled'">{{sendAsset.tillTimeString}}</span>
                                <span class="fusion-text-14" ng-show="transactionType == 'scheduled'">∞ Forever</span>

                            </div>
                        </div>

                        <div class="col-md-12 p-0" ng-show="showStaticTimeLockAsset">
                            <div class="col-md-6 p-0">
                                <span class="small-gray-text">
                                        From
                                </span>
                                <br>
                                {{timeLockStartTime}}
                            </div>
                            <div class="col-md-6 p-0">
                                <span class="small-gray-text">
                                        Until
                                    </span>
                                <br>
                                {{timeLockEndTime}}
                            </div>
                        </div>

                        <div class="row form-group">
                            <div class="col-xs-6 clearfix">
                                <button class="btn btn-white btn-block"
                                        ng-click="sendAssetModal.open()">
                                    Edit Transaction
                                </button>
                            </div>
                            <div class="col-xs-6 clearfix" ng-hide="showStaticTimeLockAsset">
                                <button class="btn btn-primary btn-block"
                                        ng-click="sendAsset()">
                                    Send Asset
                                </button>
                            </div>
                            <div class="col-xs-6 clearfix" ng-show="showStaticTimeLockAsset">
                                <button class="btn btn-primary btn-block"
                                        ng-click="timeLockToTimeLock()">
                                    Send Asset
                                </button>
                            </div>
                        </div>
                    </section>
                </div>
            </article>

        </section>
    </section>
</article>
<article class="modal fade" id="successModal" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text"
                                        ng-click="successModal.close();">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <div class="col-md-12 text-center p-2">
                    <img src="images/check-circle.svg" class="text-center" height="80px" width="80px" alt="">
                </div>

                <h3 class="text-center">Success!</h3>
                <p class="text-center">
                    Your transaction was emitted and will show up shortly..
                </p>
            </article>

        </section>
    </section>
</article>
<article class="modal fade" id="errorModal" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text"
                                        ng-click="errorModal.close();">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <div class="col-md-12 text-center p-2">
                    <img src="images/exclamation-circle.svg" class="text-center" height="80px" width="80px" color="red"
                         alt="">
                </div>

                <h3 class="text-center">Oops</h3>
                <p class="text-center">
                    Something went wrong, please retry..
                </p>
            </article>

        </section>
    </section>
</article>
<article class="modal fade" id="sendAssetFinal" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text"
                                        ng-click="sendAssetFinal.close(); sendAssetConfirm.close(); sendAsset.close()">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <div class="col-md-12 text-center p-2">
                    <img src="images/check-circle.svg" class="text-center" height="80px" width="80px" alt="">
                </div>

                <h3 class="text-center">Asset Sent!</h3>
                <p class="text-center">
                    The transaction will be reflected in your account within the next 15 seconds.</p>

                <div class="col-md-12">
                    <section class="row form-group">
                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Transaction ID
                                </span>
                            </div>
                            <div class="float-right max-char">
   <span class="fusion-text-14" data-toggle="tooltip" data-placement="top"
         title="{{successHash}}"><a href="https://blocks.fusionnetwork.io/Transactions/{{successHash}}"
                                    target="_blank">{{successHash}}</a>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Your Address:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{wallet.getChecksumAddressString()}}</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Recepient Address:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{sendAsset.toAddress}}</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2 inline w-100">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Asset:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{sendAsset.assetName}} ({{sendAsset.assetSymbol}})
                                    </span>
                                <br>
                                <span class="small-gray-text">{{sendAsset.assetHash}}</span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2 w-100 inline">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Amount:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">
                                    <span class="mono wallet-balance">  {{sendAsset.amountToSend}} </span>
                                    {{sendAsset.assetSymbol}}
                                </span>
                            </div>
                            <br>
                        </div>
                        <div class="border-gray-bottom pb-2 pt-2 w-100 inline">
                            <div class="float-left">
                                <span class="small-gray-text">
                                Gas Price:
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">
                                    <span class="mono wallet-balance">0.000021</span>
                                    FSN
                                </span>
                            </div>
                            <br>
                        </div>
                        <div ng-hide="transactionType =='none'">
                            <div class="float-left border-gray-bottom pb-2 pt-2 w-50">
                                <span class="small-gray-text" ng-hide="transactionType =='scheduled'">
                                    From
                                </span>
                                <span class="small-gray-text" ng-show="transactionType =='scheduled'">
                                    Send On
                                </span>
                                <br>
                                <span class="fusion-text-14">{{sendAsset.fromTimeString}}</span>
                            </div>
                            <div class="float-right border-gray-bottom pb-2 pt-2 w-50"
                                 ng-hide="transactionType =='scheduled'">
                                <span class="small-gray-text">
                                    Until
                                </span>
                                <br>
                                <span class="fusion-text-14">{{sendAsset.tillTimeString}}</span>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-xs-12 clearfix">
                                <button class="btn btn-white btn-block"
                                        ng-click="sendAssetFinal.close(); sendAssetConfirm.close(); sendAsset.close()">
                                    Close
                                </button>
                            </div>
                        </div>
                    </section>
                </div>
            </article>

        </section>
    </section>
</article>
<article class="modal fade" id="createAsset" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text" ng-click="createAssetModal.close();">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>
                <h3 class="h3-title">Create Asset</h3>
                <p>Seamlessly generate your own unique digital asset and set all your desired parameters.
                    Created assets can use all of the functions on the Fusion PSN including send, quantum swap,
                    time-lock and more.

                </p>
                <section class="row form-group">
                    <div class="col-sm-12 clearfix">
                        <span class="small-gray-text">
                            Asset Name:
                        </span>
                        <input type="text"
                               class="form-control"
                               ng-model="assetCreate.assetName"
                               maxlength="35"
                               placeholder="Enter an Asset Name"/>
                        <span class="small-gray-text text-right w-100 float-right">{{assetCreate.assetName.length}}
                            /35</span>

                    </div>
                    <div class="col-sm-6">
                        <span class="small-gray-text">
                            Asset Symbol:
                        </span>
                        <input type="text"
                               class="form-control"
                               maxlength="4"
                               ng-model="assetCreate.assetSymbol"
                               placeholder="4 Characters or less"/>
                        <span class="small-gray-text text-right w-100 float-right">{{assetCreate.assetSymbol.length}}
                            /4</span>
                    </div>
                    <div class="col-sm-6">
                                               <span class="small-gray-text">

                            Decimals:
                        </span>
                        <input type="number"
                               min="0"
                               max="15"
                               class="form-control"
                               ng-model="assetCreate.decimals"
                               placeholder="Up to 15 Decimal Points"/>

                    </div>
                    <div class="col-sm-12 clearfix">
                        <span class="small-gray-text">
                            Total Supply:
                        </span>
                        <input type="number"
                               min="0"
                               step="1"
                               class="form-control"
                               ng-model="assetCreate.totalSupply"
                               placeholder="Enter the amount of this assets you want to create"/>
                    </div>
                </section>

                <div class="row form-group">
                    <div class="col-md-6 col-xs-12 clearfix">
                        <a class="btn btn-white btn-block"
                           ng-click="createAssetModal.close()">
                            Cancel
                        </a>
                    </div>
                    <div class="col-md-6 col-xs-12 clearfix">
                        <button class="btn btn-primary btn-block"
                                ng-class="{'disabled' : assetCreate.totalSupply <= 0}"
                                ng-click="createAsset()">
                            Generate Asset
                        </button>
                    </div>
                </div>

                <div class="col-lg-12 col-sm-12 col-xs-12 alert alert-danger" ng-show="assetCreate.errorMessage != ''">
                    <strong>Error!</strong> {{assetCreate.errorMessage}} <br>
                    Please, review and try again!
                </div>
            </article>

        </section>
    </section>
</article>
<article class="modal fade" id="createAssetFinal" tabindex="-1">
    <section class="modal-dialog">
        <section class="modal-content">
            <article class="block" ng-hide="wallet.type=='addressOnly'">
                <div class="col-md-12 p-0">
                    <div class="float-right">
                                  <span class="gray-text" ng-click="createAssetFinal.close(); createAsset.close()">                    <i
                                              class="fa fa-times"
                                              aria-hidden="true"></i>
</span>
                    </div>
                </div>

                <div class="col-md-12 text-center p-2">
                    <img src="images/check-circle.svg" class="text-center" height="80px" width="80px" alt="">
                </div>

                <h3 class="text-center">Asset Created!</h3>
                <p class="text-center">
                    The asset will show up in your wallet within the next 15 seconds
                </p>

                <div class="col-md-12">
                    <section class="row form-group">
                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Transaction ID
                                </span>
                            </div>
                            <div class="float-right max-char">
                                   <span class="fusion-text-14" data-toggle="tooltip" data-placement="top"
                                         title="{{assetCreate.assetHash}}">
                                       <a href="https://blocks.fusionnetwork.io/Transactions/{{assetCreate.assetHash}}"
                                          target="_blank">
                                </span>
                            </div>
                            <br>
                        </div>

                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Asset Name
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{assetCreate.assetName}}</span>
                            </div>
                            <br>
                        </div>

                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Asset Symbol
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{assetCreate.assetSymbol}}</span>
                            </div>
                            <br>
                        </div>

                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Decimal Points
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{assetCreate.decimals}}</span>
                            </div>
                            <br>
                        </div>

                        <div class="border-gray-bottom pb-2 pt-2">
                            <div class="float-left">
                                <span class="small-gray-text">
                                    Total Supply
                                </span>
                            </div>
                            <div class="float-right">
                                <span class="fusion-text-14">{{assetCreate.totalSupply}}</span>
                            </div>
                            <br>
                        </div>

                        <div class="row form-group">
                            <div class="col-xs-12 clearfix">
                                <button class="btn btn-white btn-block"
                                        ng-click="createAssetFinal.close(); createAsset.close()">
                                    Close
                                </button>
                            </div>
                        </div>
                    </section>
                </div>
            </article>

        </section>
    </section>
</article>


<div class="col-sm-9">

    <!-- Generate Asset -->

</div>
<!-- / Content -->


<!-- / Sidebar -->
