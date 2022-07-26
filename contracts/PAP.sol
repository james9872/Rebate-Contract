// SPDX-License-Identifier: MIT


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


pragma solidity ^0.8.7;


interface IOracle {
    function update() external;
    function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut);
    function twap(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

contract PAMP is Ownable {

    struct Asset {
        bool isAdded;
        uint256 multiplier;
        address oracle;
        bool isLP;
        address pair;
    }

    struct VestingSchedule {
        uint256 amount;
        uint256 period;
        uint256 end;
        uint256 claimed;
        uint256 lastClaimed;
    }

    IERC20 public Pbl;
    IOracle public PblOracle;

    mapping (address => Asset) public assets;
    mapping (address => VestingSchedule) public vesting;

    uint256 public discount = 100000;

    uint256 public bondVesting = 7 days;
    uint256 public totalVested = 0;

    uint256 public lastBuyback;

    address public constant WETH = 0x74b23882a30290451A17c44f4F05243b6b58C76d;
    uint256 public constant DENOMINATOR = 1e6;
    address public treasury = 0x4B4E90970c7603ecAF6cdd5223ac12b4375Bed98;

    uint256[] public  tierTwap=
    [
        694200000000000000
        ,1000000000000000000
        ,1500000000000000000
        ,2000000000000000000
        ,2500000000000000000
        ,3000000000000000000
        ,3500000000000000000
        ,4000000000000000000
        ,4500000000000000000
        ,5000000000000000000
    ];
    uint256[] public  tierRelease=
    [
        20 ether
        ,18 ether
        ,16 ether
        ,14 ether
        ,12 ether
        ,10 ether
        ,8 ether
        ,6 ether
        ,4 ether
        ,2 ether
    ];
    uint256 public limit = 0;
    uint256 public tier = 0;
    /*
     * ---------
     * MODIFIERS
     * ---------
     */
    
    // Only allow a function to be called with a bondable asset

    modifier onlyAsset(address token) {
        require(assets[token].isAdded, "PAMP: token is not a bondable asset");
        _;
    }

    /*
     * ------------------
     * EXTERNAL FUNCTIONS
     * ------------------
     */

    // Initialize parameters

    constructor(address pbl, address pblOracle) {
        Pbl = IERC20(pbl);
        PblOracle = IOracle(pblOracle);
    }
    
    // Bond asset for discounted Pbl at bond rate

    function bond(address token, uint256 amount) external onlyAsset(token) {
        updateTier();
        require(amount > 0, "PAMP: invalid bond amount");
        uint256 pblAmount = getPblReturn(token, amount);
        require(Pbl.balanceOf(address(this))>= limit, "PAMP: insufficient pbl balance");
        require(limit >= totalVested && pblAmount <= limit - totalVested, "PAMP: insufficient limit");

        IERC20(token).transferFrom(msg.sender, treasury, amount);
        _claimVested(msg.sender);

        VestingSchedule storage schedule = vesting[msg.sender];
        schedule.amount = schedule.amount - schedule.claimed + pblAmount;
        schedule.period = bondVesting;
        schedule.end = block.timestamp + bondVesting;
        schedule.claimed = 0;
        schedule.lastClaimed = block.timestamp;
        totalVested += pblAmount;
    }

    // Claim available Pbl rewards from bonding

    function claimRewards() external {
        _claimVested(msg.sender);
    }

    /*
     * --------------------
     * RESTRICTED FUNCTIONS
     * --------------------
     */
    
    // Set Pbl token

    function setPbl(address pbl) external onlyOwner {
        Pbl = IERC20(pbl);
    }

    function setTreasury(address tre) external onlyOwner {
        treasury = tre;
    }

    // Set Pbl oracle

    function setPblOracle(address oracle) external onlyOwner {
        PblOracle = IOracle(oracle);
    }
    
    // Set bonding parameters of token
    
    function setAsset(
        address token,
        bool isAdded,
        uint256 multiplier,
        address oracle,
        bool isLP,
        address pair
    ) external onlyOwner {
        assets[token].isAdded = isAdded;
        assets[token].multiplier = multiplier;
        assets[token].oracle = oracle;
        assets[token].isLP = isLP;
        assets[token].pair = pair;
    }

    // Set bond pricing parameters

    function setBondParameters(
        uint256 _discount,
        uint256 _vestingPeriod
    ) external onlyOwner {
        discount = _discount;
        bondVesting = _vestingPeriod;
    }

    /*
     * ------------------
     * INTERNAL FUNCTIONS
     * ------------------
     */

    function _claimVested(address account) internal {
        VestingSchedule storage schedule = vesting[account];
        if (schedule.amount == 0 || schedule.amount == schedule.claimed) return;
        if (block.timestamp <= schedule.lastClaimed || schedule.lastClaimed >= schedule.end) return;

        uint256 duration = (block.timestamp > schedule.end ? schedule.end : block.timestamp) - schedule.lastClaimed;
        uint256 claimable = schedule.amount * duration / schedule.period;
        if (claimable == 0) return;

        schedule.claimed += claimable;
        schedule.lastClaimed = block.timestamp > schedule.end ? schedule.end : block.timestamp;
        totalVested -= claimable;
        Pbl.transfer(account, claimable);
    }

    /*
     * --------------
     * VIEW FUNCTIONS
     * --------------
     */

    // Calculate Pbl return of bonding amount of token

    function getPblReturn(address token, uint256 amount) public view onlyAsset(token) returns (uint256) {
        uint256 pblPrice = getPblPrice();
        uint256 tokenPrice = getTokenPrice(token);
        return amount * tokenPrice * (discount + DENOMINATOR) * assets[token].multiplier / (DENOMINATOR * DENOMINATOR) / pblPrice;
    }


    // Get Pbl price from Oracle

    function getPblPrice() public view returns (uint256) {
        return PblOracle.consult(address(Pbl), 1e18);
    }

    function updateTier() public {
        PblOracle.update();
        uint256 pblPrice = PblOracle.consult(address(Pbl), 1e18);
        while( tier < 10 && tierTwap[tier] <= pblPrice){
            limit += tierRelease[tier];
            tier++;
        }
    }

    // Get token price from Oracle

    function getTokenPrice(address token) public view onlyAsset(token) returns (uint256) {
        Asset memory asset = assets[token];
        IOracle Oracle = IOracle(asset.oracle);
        if (!asset.isLP) {
            return Oracle.consult(token, 1e18);
        }

        IUniswapV2Pair Pair = IUniswapV2Pair(asset.pair);
        uint256 totalPairSupply = Pair.totalSupply();
        address token0 = Pair.token0();
        address token1 = Pair.token1();
        (uint256 reserve0, uint256 reserve1,) = Pair.getReserves();

        if (token1 == WETH) {
            uint256 tokenPrice = Oracle.consult(token0, 1e18);
            return tokenPrice * reserve0 / totalPairSupply +
                   reserve1 * 1e18 / totalPairSupply;
        } else {
            uint256 tokenPrice = Oracle.consult(token1, 1e18);
            return tokenPrice * reserve1 / totalPairSupply +
                   reserve0 * 1e18 / totalPairSupply;
        }
    }

    // Get claimable vested Pbl for account

    function claimablePbl(address account) external view returns (uint256) {
        VestingSchedule memory schedule = vesting[account];
        if (block.timestamp <= schedule.lastClaimed || schedule.lastClaimed >= schedule.end) return 0;
        uint256 duration = (block.timestamp > schedule.end ? schedule.end : block.timestamp) - schedule.lastClaimed;
        return schedule.amount * duration / schedule.period;
    }

    function emergencyWithdraw(IERC20 token, uint256 amnt) external onlyOwner {
        token.transfer(owner(), amnt);
    }

}