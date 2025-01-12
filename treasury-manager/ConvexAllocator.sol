// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
    //     require(address(this).balance >= value, "Address: insufficient balance for call");
    //     return _functionCallWithValue(target, data, value, errorMessage);
    // }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function addressToString(address _address)
        internal
        pure
        returns (string memory)
    {
        bytes32 _bytes = bytes32(uint256(_address));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _addr = new bytes(42);

        _addr[0] = "0";
        _addr[1] = "x";

        for (uint256 i = 0; i < 20; i++) {
            _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }

        return string(_addr);
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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

    function decimals() external view returns (uint8);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IOwnable {
    function policy() external view returns (address);

    function renounceManagement() external;

    function pushManagement(address newOwner_) external;

    function pullManagement() external;
}

contract Ownable is IOwnable {
    address internal _owner;
    address internal _newOwner;

    event OwnershipPushed(
        address indexed previousOwner,
        address indexed newOwner
    );
    event OwnershipPulled(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
        emit OwnershipPushed(address(0), _owner);
    }

    function policy() public view override returns (address) {
        return _owner;
    }

    modifier onlyPolicy() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceManagement() public virtual override onlyPolicy {
        emit OwnershipPushed(_owner, address(0));
        _owner = address(0);
    }

    function pushManagement(address newOwner_)
        public
        virtual
        override
        onlyPolicy
    {
        require(
            newOwner_ != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipPushed(_owner, newOwner_);
        _newOwner = newOwner_;
    }

    function pullManagement() public virtual override {
        require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
        emit OwnershipPulled(_owner, _newOwner);
        _owner = _newOwner;
    }
}

interface ITreasury {
    function deposit(
        uint256 _amount,
        address _token,
        uint256 _profit
    ) external returns (uint256 send_);

    function manage(address _token, uint256 _amount) external;

    function valueOf(address _token, uint256 _amount)
        external
        view
        returns (uint256 value_);
}

interface ICurve3Pool {
    // add liquidity (frax) to receive back FRAX3CRV-f
    function add_liquidity(
        address _pool,
        uint256[4] memory _deposit_amounts,
        uint256 _min_mint_amount
    ) external returns (uint256);

    // remove liquidity (FRAX3CRV-f) to recieve back Frax
    function remove_liquidity_one_coin(
        address _pool,
        uint256 _burn_amount,
        int128 i,
        uint256 _min_amount
    ) external returns (uint256);
}

//main Convex contract(booster.sol) basic interface
interface IConvex {
    function poolInfo(uint256 pid)
        external
        returns (
            address lptoken,
            address token,
            address gauge,
            address crvRewards,
            address stash,
            bool shutdown
        );

    //deposit into convex, receive a tokenized deposit.  parameter to stake immediately
    function deposit(
        uint256 _pid,
        uint256 _amount,
        bool _stake
    ) external returns (bool);

    //burn a tokenized deposit to receive curve lp tokens back
    function withdraw(uint256 _pid, uint256 _amount) external returns (bool);
}

//sample convex reward contracts interface
interface IConvexRewards {
    //get balance of an address
    function balanceOf(address _account) external returns (uint256);

    //withdraw to a convex tokenized deposit
    function withdraw(uint256 _amount, bool _claim) external returns (bool);

    //withdraw directly to curve LP token
    function withdrawAndUnwrap(uint256 _amount, bool _claim)
        external
        returns (bool);

    //claim rewards
    function getReward() external returns (bool);

    //stake a convex tokenized deposit
    function stake(uint256 _amount) external returns (bool);

    //stake a convex tokenized deposit for another address(transfering ownership)
    function stakeFor(address _account, uint256 _amount)
        external
        returns (bool);

    //get rewards for an address
    function earned(address _account) external view returns (uint256);
}

interface IAnyswapERC20 {
    function underlying() external view returns (address);

    function withdraw(uint256 amount) external returns (uint256);
}

interface IAnyswapRouter {
    function anySwapOutUnderlying(
        address token,
        address to,
        uint256 amount,
        uint256 toChainID
    ) external;
}

/**
 *  Contract deploys reserves from treasury into the Convex lending pool,
 *  earning interest and $CVX.
 */

contract ConvexAllocator is Ownable {
    /* ======== DEPENDENCIES ======== */

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    /* ======== STRUCTS ======== */

    struct tokenData {
        address underlying;
        address anyswapERC20;
        uint256 deployed;
        uint256 returned;
    }

    struct rewardPid {
        address rewardPool;
        uint256 pid;
    }

    /* ======== STATE VARIABLES ======== */

    IConvex public immutable booster; // Convex deposit contract
    //IConvexRewards public rewardPool; // Convex reward contract
    IAnyswapRouter public immutable anyswapRouter; // anyswap router
    ICurve3Pool public curve3Pool; // Curve 3Pool
    address public rewardCollector;

    mapping(address => tokenData) public tokenInfo; // info for deposited tokens
    //mapping(address => uint) public pidForReserve; // convex pid for reward pool
    rewardPid[] public pidForReserve;

    uint256 public totalValueDeployed; // total RFV deployed into lending pool
    uint256 public totalValueReturned;

    uint256 public immutable timelockInBlocks; // timelock to raise deployment limit

    address[] rewardTokens;

    uint256 public chainId = 250;
    uint256 public chainIdCandidate;
    uint256 constant INDEX_NOT_FOUND = 999999;
    address public ftmAddress;
    address public ftmAddressCandidate;
    uint256 public immutable ftmAddressChangeTimelock;
    uint256 public ftmAddressActiveblock;

    /* ======== CONSTRUCTOR ======== */

    constructor(
        address _anyswapRouter,
        address _booster,
        // address _rewardPool,
        address _curve3Pool,
        address _rewardCollector,
        address _ftmAddress,
        uint256 _ftmAddressChangeTimelock,
        uint256 _timelockInBlocks
    ) {
        require(_anyswapRouter != address(0));
        anyswapRouter = IAnyswapRouter(_anyswapRouter);

        require(_booster != address(0));
        booster = IConvex(_booster);

        // require( _rewardPool != address(0) );
        // rewardPool = IConvexRewards( _rewardPool );

        require(_curve3Pool != address(0));
        curve3Pool = ICurve3Pool(_curve3Pool);

        require(_rewardCollector != address(0));
        rewardCollector = _rewardCollector;

        timelockInBlocks = _timelockInBlocks;

        require(_ftmAddress != address(0));
        ftmAddress = _ftmAddress;

        ftmAddressChangeTimelock = _ftmAddressChangeTimelock;
    }

    /* ======== OPEN FUNCTIONS ======== */

    /**
     *  @notice claims accrued CVX rewards for all tracked crvTokens
     */
    function harvest() public {
        //claim rewards for all crvTokens
        for (uint256 i = 0; i < pidForReserve.length; i++) {
            address rewardPool = pidForReserve[i].rewardPool;
            require(rewardPool != address(0), "Invalid reward pool address");

            //Claim rewards
            IConvexRewards(rewardPool).getReward();
        }

        for (uint256 i = 0; i < rewardTokens.length; i++) {
            uint256 balance = IERC20(rewardTokens[i]).balanceOf(address(this));

            if (balance > 0) {
                IERC20(rewardTokens[i]).safeTransfer(rewardCollector, balance);
            }
        }
    }

    /* ======== POLICY FUNCTIONS ======== */

    /**
     *  @notice withdraws asset from treasury, deposits asset into lending pool, then deposits crvToken into convex
     *  @param token address
     *  @param amount uint
     *  @param amounts uint[]
     *  @param minAmount uint
     *  @param pid uint
     *  @param curveToken address
     */
    function deposit(
        address token,
        uint256 amount,
        uint256[4] calldata amounts,
        uint256 minAmount,
        uint256 pid,
        address curveToken
    ) public onlyPolicy {
        require(curve3Pool != ICurve3Pool(0), "Invalid curv3pool address");
        (address _lptoken, , , address _crvRewards, , ) = booster.poolInfo(pid);

        require(_lptoken == curveToken, "Invalid curve token address");

        //Update pidForReserve
        _addPidRewardItem(_crvRewards, pid);

        //treasury.manage( token, amount ); // retrieve amount of asset from treasury

        // account for deposit
        //uint value = treasury.valueOf( token, amount );

        uint256 value = valueOf(token, amount);

        accountingFor(token, amount, value, true);

        IERC20(token).approve(address(curve3Pool), amount); // approve curve pool to spend tokens
        uint256 curveAmount = curve3Pool.add_liquidity(
            curveToken,
            amounts,
            minAmount
        ); // deposit into curve

        IERC20(curveToken).approve(address(booster), curveAmount); // approve to deposit to convex
        booster.deposit(pid, curveAmount, true); // deposit into convex
    }

    function valueOf(address token, uint256 amount)
        public
        view
        returns (uint256 value)
    {
        uint256 decimals = IERC20(token).decimals();
        if (decimals > 9) {
            amount.div(10**(decimals - 9));
        } else if (decimals < 9) {
            amount.mul(10**(9 - decimals));
        } else {
            value = amount;
        }
    }

    /**
     *  @notice adds Convex reward pool/pid pair
     *  @param _rewardPool address
     *  @param pid uint256
     */
    function addPidRewardItem(address _rewardPool, uint256 pid)
        external
        onlyPolicy
    {
        require(_rewardPool != address(0), "Invalid reward");
        _addPidRewardItem(_rewardPool, pid);
    }

    /**
     *  @notice removes Convex reward pool/pid pair
     *  @param _rewardPool address
     *  @param pid uint256
     */
    function removePidRewardItem(address _rewardPool, uint256 pid)
        external
        onlyPolicy
    {
        _removePidRewardItem(_rewardPool, pid);
    }

    function _addPidRewardItem(address _rewardPool, uint256 pid) internal {
        if (pidForReserve.length == 0)
            pidForReserve.push(rewardPid(_rewardPool, pid));
        else {
            //check for duplication
            for (uint256 i = 0; i < pidForReserve.length; i++) {
                if (
                    pidForReserve[i].rewardPool != _rewardPool &&
                    pidForReserve[i].pid != pid
                ) {
                    pidForReserve.push(rewardPid(_rewardPool, pid));
                }
            }
        }
    }

    function _removePidRewardItem(address _rewardPool, uint256 pid) internal {
        uint256 index = INDEX_NOT_FOUND;
        for (uint256 i = 0; i < pidForReserve.length; i++) {
            if (
                pidForReserve[i].rewardPool == _rewardPool &&
                pidForReserve[i].pid == pid
            ) {
                index = i;
            }
        }

        //resize array
        if (index != INDEX_NOT_FOUND) {
            _removeArrayGap(index);
        }
    }

    function _removeArrayGap(uint256 _index) internal {
        require(_index < pidForReserve.length, "index out of bound");

        for (uint256 i = _index; i < pidForReserve.length - 1; i++) {
            pidForReserve[i] = pidForReserve[i + 1];
        }
        pidForReserve.pop();
    }

    /**
     *  @notice withdraws crvToken from convex, withdraws from lending pool, then deposits asset into treasury
     *  @param token address
     *  @param amount uint
     *  @param minAmount uint
     *  @param tokenIndexInPool int128
     *  @param pid uint
     *  @param curveToken address
     */
    function withdraw(
        address token,
        uint256 amount,
        uint256 minAmount,
        int128 tokenIndexInPool,
        uint256 pid,
        address curveToken
    ) public onlyPolicy {
        require(curve3Pool != ICurve3Pool(0), "Invalid curv3pool address");
        (address _lptoken, , , address _crvRewards, , ) = booster.poolInfo(pid);

        require(_lptoken == curveToken, "Invalid curve token address");
        require(_crvRewards != address(0), "Invalid reward pool address");

        IConvexRewards(_crvRewards).withdrawAndUnwrap(amount, false); // withdraw to curve token

        IERC20(curveToken).approve(address(curve3Pool), amount); // approve 3Pool to spend curveToken
        curve3Pool.remove_liquidity_one_coin(
            curveToken,
            amount,
            tokenIndexInPool, //order of token in the Curve pool
            minAmount
        ); // withdraw from curve

        uint256 balance = IERC20(token).balanceOf(address(this)); // balance of asset withdrawn

        // account for withdrawal
        //uint value = treasury.valueOf( token, balance );
        uint256 value = valueOf(token, balance);
        accountingFor(token, balance, value, false);

        //IERC20( token ).approve( address( treasury ), balance ); // approve to deposit asset into treasury
        //treasury.deposit( balance, token, value ); // deposit using value as profit so no HEC is minted

        IERC20(token).approve(address(anyswapRouter), balance); // approve anyswap router to spend tokens
        anyswapRouter.anySwapOutUnderlying(
            tokenInfo[token].anyswapERC20,
            ftmAddress,
            balance,
            chainId
        );
    }

    function withdrawAnyswapERC20(address anyswapERC20Token, uint256 amount)
        public
        onlyPolicy
    {
        IAnyswapERC20(anyswapERC20Token).withdraw(amount);
    }

    function queueFtmAddress(uint256 _chainId, address _ftmAddress)
        external
        onlyPolicy
    {
        require(
            _ftmAddress != address(0) && _chainId != 0,
            "invalid chainid or address"
        );
        ftmAddressActiveblock = block.number.add(ftmAddressChangeTimelock);
        ftmAddressCandidate = _ftmAddress;
        chainIdCandidate = _chainId;
    }

    function setFtmAddress() external onlyPolicy {
        require(
            ftmAddressCandidate != address(0) && chainIdCandidate != 0,
            "put new address in queue first"
        );
        require(block.number >= ftmAddressActiveblock, "still in queue");

        ftmAddress = ftmAddressCandidate;
        ftmAddressCandidate = address(0);

        chainId = chainIdCandidate;
        chainIdCandidate = 0;
    }

    /**
     *  @notice sets reward collector address
     *  @param _rewardCollector address
     */
    function setRewardCollector(address _rewardCollector) external onlyPolicy {
        require(
            _rewardCollector != address(0) &&
                rewardCollector != _rewardCollector,
            ""
        );
        rewardCollector = _rewardCollector;
    }

    /**
     *  @notice adds asset and corresponding crvToken to mapping
     *  @param principleToken address
     */
    function addToken(address principleToken, address anyswapERC20Token)
        external
        onlyPolicy
    {
        require(anyswapERC20Token != address(0), "invalid anyswap erc20 token");
        address token = IAnyswapERC20(anyswapERC20Token).underlying();
        require(
            token != address(0) && principleToken == token,
            "principle token not matched with anyswap ERC20 underlying token"
        );

        require(tokenInfo[token].deployed <= tokenInfo[token].returned);

        tokenInfo[token] = tokenData({
            underlying: token,
            anyswapERC20: anyswapERC20Token,
            deployed: 0,
            returned: 0
        });
    }

    /**
     *  @notice add new reward token to be harvested
     *  @param token address
     */
    function addRewardToken(address token) external onlyPolicy {
        require(IERC20(token).totalSupply() > 0, "Invalid address");
        require(token != address(0));
        rewardTokens.push(token);
    }

    /* ======== INTERNAL FUNCTIONS ======== */

    /**
     *  @notice accounting of deposits/withdrawals of assets
     *  @param token address
     *  @param amount uint
     *  @param value uint
     *  @param add bool
     */
    function accountingFor(
        address token,
        uint256 amount,
        uint256 value,
        bool add
    ) internal {
        if (add) {
            tokenInfo[token].deployed = tokenInfo[token].deployed.add(amount); // track amount allocated into pool

            totalValueDeployed = totalValueDeployed.add(value); // track total value allocated into pools
        } else {
            // track amount allocated into pool
            tokenInfo[token].returned = tokenInfo[token].returned.add(amount);

            // track total value allocated into pools
            totalValueReturned = totalValueReturned.add(value);
        }
    }

    /* ======== VIEW FUNCTIONS ======== */

    /**
     *  @notice query all pending rewards
     *  @return uint
     */
    function rewardsPending() public view returns (uint256) {
        uint256 rewardAmount;

        //query all pending rewards
        for (uint256 i = 0; i < pidForReserve.length; i++) {
            address rewardPool = pidForReserve[i].rewardPool;
            require(rewardPool != address(0), "Invalid reward pool address");

            rewardAmount += IConvexRewards(rewardPool).earned(address(this));
        }

        return rewardAmount;
    }
}
