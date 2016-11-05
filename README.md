# FairTokenSale

Token sales have a quandary: if they don't set a cap, or set a very high cap, then people might go overboard and send way more money than required, even enough to be a global risk like TheDAO. But if a sale sets a low cap, the tokens can sell out fast and people get locked out.

Fairsale.sol lets people contribute as much as they like, then give refunds in proportion to how much you exceed the cap. E.g. if your cap is $1 million and you collect $2 million, then everybody gets half their contribution back. If you collect $3 million then everyone gets 2/3 back, and so on.

