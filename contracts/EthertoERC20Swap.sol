pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

interface ERC20Swapper {
    /// @dev swaps the `msg.value` Ether to at least `minAmount` of tokens in `address`, or reverts
    /// @param token The address of ERC-20 token to swap
    /// @param minAmount The minimum amount of tokens transferred to msg.sender
    /// @return The actual amount of transferred tokens
    function swapEtherToToken(address token, uint minAmount) external payable returns (uint);
}

contract EthertoERC20Swap is ERC20Swapper, Initializable, AccessControlUpgradeable, UUPSUpgradeable {

    struct Swap {
        uint256 value;
        address ethTrader;
        uint erc20Value;
        address erc20ContractAddress;
        uint256 swapDate;
    }

    enum States {
        ISSUE,
        OPEN,
        SUCCESS
    }

    mapping (address => Swap[]) public swapLogs;

    mapping (bytes32 => Swap) private swaps;
    mapping (bytes32 => States) private swapStates;

    event Open(bytes32 _swapID, address _withdrawTrader,bytes32 _secretLock);
    event InitSwap(bytes32 _swapID, address swapperAddress);
    event Close(bytes32 _swapID, States );

    AggregatorV3Interface public priceFeed;

    IERC20 ercToken;

    modifier isAdmin() {
        hasRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _;
    }

    function initialize(address aggregatorAddr) initializer public { 
        
        __AccessControl_init();
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        priceFeed = AggregatorV3Interface(aggregatorAddr); 
    
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(DEFAULT_ADMIN_ROLE)
        override
    {}

   function getETHPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function swapEtherToToken(address token, uint minAmount) external payable returns (uint) {

        require(minAmount > 0, "Token amount should be greater then zero");

        // As the current implementation does not uses any DEX, so for the purpose of calculating amount to be swapped with ETH, 
        // I have set the price of ERC20[in USD] in dollars.
        uint256 erc20TokenPrice = 2; 

        //fetching the ETH price in dollars by using ChainLink aggregator function.
        uint256 ethPrice =  uint256(getETHPrice());

        //3% will go as fee
        uint256 ethAmountWithFee = (msg.value * 97) / 1000; 
        uint256 erc20tokenAmount =(ethAmountWithFee * ethPrice) / erc20TokenPrice;
        
        ercToken = IERC20(token);

        require(ercToken.balanceOf(msg.sender) >= uint256(erc20tokenAmount), "Insufficient balance");
        require(minAmount >= uint(erc20tokenAmount), "output amount should be more then minAmount");

        bytes32 uniqueSwapID = keccak256(abi.encodePacked(msg.sender,token,ethAmountWithFee, block.timestamp)); 

        Swap memory swap = Swap({
                value: ethAmountWithFee,
                ethTrader: msg.sender,
                erc20Value: erc20tokenAmount,
                erc20ContractAddress: token,
                swapDate: block.timestamp
            });

        swaps[uniqueSwapID] = swap;
        swapStates[uniqueSwapID] = States.OPEN;

        bool successSecond = ercToken.transfer(msg.sender, uint(erc20tokenAmount));

        if(successSecond == false) {
            swapStates[uniqueSwapID] = States.ISSUE;
            emit Close(uniqueSwapID, States.ISSUE);
            revert("Token transfer failed");
        } else {
            swapStates[uniqueSwapID] = States.SUCCESS;
            emit Close(uniqueSwapID, States.SUCCESS);
        }

        emit InitSwap(uniqueSwapID, msg.sender);
        return uint(erc20tokenAmount);
       
    }

    function addAdmin(address account) external virtual isAdmin {
        grantRole(DEFAULT_ADMIN_ROLE, account);
    }

    function removeAdmin(address account) external virtual isAdmin {
        revokeRole(DEFAULT_ADMIN_ROLE, account);
    }
   
}

