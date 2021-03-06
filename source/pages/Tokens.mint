component Tokens {
  connect Application exposing { walletInfo }
  connect WalletStore exposing { currentWallet }
  connect TransactionStore exposing { sendError, sendSuccess }

  fun componentDidMount : Promise(Never, Void) {
    if (Maybe.isNothing(currentWallet)) {
      Window.navigate("/login")
    } else {
      Promise.never()
    }
  }

  fun render : Html {
    <Layout
      topNavigation=[<TopNavigation/>]
      leftNavigation=[<LeftNavigation current="tokens"/>]
      content=[renderPageContent]/>
  }

  get renderPageContent : Html {
    walletInfo
    |> Maybe.map(pageContent)
    |> Maybe.withDefault(loadingPageContent)
  }

  get loadingPageContent : Html {
    <div>"LOADING"</div>
  }

  fun pageContent (walletInfo : WalletInfo) : Html {
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-3">
        <AccountStatus/>
          <WalletBalances
            address={walletInfo.address}
            readable={walletInfo.readable}
            tokens={walletInfo.tokens}/>

          <News/>
        </div>

        <div class="col-md-9">
          <{ UiHelper.errorAlert(sendError) }>
          <{ UiHelper.successAlert(sendSuccess) }>

          <CreateCustomTokenTransaction
            senderAddress={walletInfo.address}
            tokens={walletInfo.tokens}/>

          <div class="row">
            <div class="col">
              <UpdateCustomTokenTransaction
                senderAddress={walletInfo.address}
                tokens={walletInfo.tokens}
                myTokens={unlockedTokens}/>
            </div>

            <div class="col">
              <LockCustomTokenTransaction
                senderAddress={walletInfo.address}
                tokens={walletInfo.tokens}
                myTokens={unlockedTokens}/>
            </div>

            <div class="col">
              <BurnCustomTokenTransaction
                senderAddress={walletInfo.address}
                tokens={walletInfo.tokens}/>
            </div>
          </div>
        </div>
      </div>
    </div>
  } where {
    unlockedTokens =
      walletInfo.myTokens
      |> Array.select((t : Token) { !t.isLocked })
  }
}
