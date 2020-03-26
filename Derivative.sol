pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Storage
 * @dev Store & retreive value in a variable
 */
contract Derivative {

    string assetName;
    string derivateSymbol;
    string derivativeName;
    string baseAssetName;
    address oracle;
    address assetContractAddress;
    address baseAssetContractAddress;
    uint256 buffer;


    mapping(address => uint256) shorts;
    mapping(address => uint256) longs;
    address[] users;
    mapping(address => uint256) balances;


    uint256 totalShort;
    uint256 totalLong;

    uint256 assetPrice;



    uint256 offset; //something mod the entire duration
    uint256 timestampUpdate;
    uint256 issuingDuration;
    uint256 activeDuration;
    uint256 settlingDuration;


    uint256 nextTimeStamp;
    uint256 margin;

        //modifiers

        //check collateral and exposure
            modifier  {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }


        modifier notPaused {
                  require(
                0 == 0,
             "."
            );
            _;
        }
        //contract is active/not paused or in stages
            modifier onlySettling {
        require(
            0 == 0,
            "."
        );
        _;
    }

        modifier onlyActive {
        require(
            0 == 0,
            "."
        );
        _;
    }

    modifier onlyIssuing {
    require(
            0 == 0,
            "."
        );
        _;
    }

    modifier isSettled {
        require(
                0 == 0,
                "."
            );
            _;
    }




      /**
     * @dev Create a new derivative for an asset and range
     * @param {probability, settlementTime,
     */
    constructor(bytes[] memory derivativeAssetData) public {}


    function issueDerivative(uint256 amount) public onlyIssuing verifiedAccount {
        //calculate numbers on both ends
        //amount to shares long and short
        userLongs = 0
        userShorts = 0

        //mint the tokens
        //base value for an account, with quantity based on some other thing
        //amount is taken by the thing ..
        //get x shorts, and y longs
    }


    function withdraw(uint256 amount) public {
        //transfer to the address that desires it
        //return (this.getExposure() <= this.getAccoountBalance(msg.sender) )
    }

    function transitionDerivativeState() {
        blockstamp = 4
        if (this.State == Active && blockstamp <= this.activeCutoff) {
            this.State = Settling
            this.isSettled = this.settleAllPositions()
            this.lastTimeStamp = blockstamp

        }
        if (this.State == Settling && this.isSettled && it is the correct timestamp) {
                this.State = Issuing
        }

        if (this.State == Issuing && it is the correct timestamp) {
                this.State = Active
        }
    }

function settleAllPositions() public onlyActive onlyEnd (bool) {
    while (this.users.length > 0) {
        user = this.users.pop()
        this.settle(user)
    }
    return true
}

    function settle(address) private {
        userLongs = this.longs[user]
        userShorts = this.shorts[user]
        change = (userLongs - userShorts)*this.assetPrice
        if (change) < 0 {
            change = change * -1
        }
        this.longs[user] = 0
        this.shorts[user] = 0
        this.totalLong -= userLongs
        this.totalShort -= userShorts
        this.balances[user] += change
    }

    function getAccoountBalance(address user) public (uint256) {
        return this.balances[user]
    }

    function setAccountBalance(address user, uint256 newBalance) {
        this.balances[user] = newBalance
    }

    function setPrice(uint256 newPrice) {
        this.assetPrice = newPrice
    }

    function getPrice(uint256 time) public payable {
        newPrice =1000    //get from oracle
        this.setPrice(newPrice)
        return this.prce
    }

    function updateExposure(address user) public {
        this.exposure[user] = calculateExposure(this.longs[user], this.shorts[user], this.getPrice())
    }

    function calculateExposure(uint256 longs, uint256 shorts, uint256 price) public (uint256) {
        return price * abs(shorts - longs)
    }

    function getExposure(address user) public (uint256) {
        return this.exposure[user]
    }


}
