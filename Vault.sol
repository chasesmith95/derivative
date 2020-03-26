pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Vault
 */
contract Vault {
    address[] public derivatives;
    address owner;
    map (uint256 => address);
    address[] public oracles;
    mapping (address => address[]) public userDerivatives;
    mapping (address => bool) public acceptedCollateralTokens;
    uint256 public vaultFee;
    mapping(orachuint256 contractBalances;

    // check that money is transferred to the  //check that it is from the correct contract (receives the tokens)
    function issueDerivative(address derivativeAddress) public returns (bool) {
        // call external function derivative.issueDerivative for money
        // success = call deriative function to mint shorts + longs, send money to derivative,
        ///take vaultFee as a percentage of the amount that are created
        return true
    }

    // function updateDerivative(address derivativeAddress) public {
    //     //for timestamps in derivatives {
    //         //if timestamp/block number fits then update {
    //             //get derivative address and call update
    //             //then call the derivative update function
    //         }
    //     }
    // }

    //(check that it is in collateral)
    function receiveTokens() {

    }

    // function withdraw(uint256 amount) private onlyOwner {
    //     //check that the amount is there
    //     //subtract the amount
    //     //transfer the amount from the erc20 contract
    // }

    function settleDerivative(interface position, address account) public {
        uint256 nextPrice = getAssetPrice(position.derivativeProductAddress); //call function from derivative asset
        position. //cast position to Position
        bytes[] owed = (position.short - position.long) * nextPrice
        //subtract assets
        //remove position
        //check account has enough money
        accounts[account] -= owed
    }


    function addDerivative(address derivativeAddress) public onlyOwner {
        assets[derivativeAddress] = true
    }

    function removeDerivative(address derivativeAddress) public onlyOwner{
        assets[derivativeAddress] = false
    }

    // function getUserPositions() returns (bool) {
    //     Position[] userPositions; // get user positions
    //     //return Position[]
    // }

    function getDerivatives() public returns (address[]) {
        return this.derivatives
    }


}
