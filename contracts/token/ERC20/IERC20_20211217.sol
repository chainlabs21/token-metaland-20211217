// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20_20211217 {

//	function  _timelock_taperdown (address _address) returns 
	function owner() external view  returns (address) ;
	function transferOwnership(address newOwner) external  ;	
	function set_timelock_taperdown (address _address 
		, uint _start_year
		, uint _start_month
		, uint _start_day
		, uint _duration_in_months
		, uint _start_unix
		, uint _end_unix		
		, bool _active
	) external ;
	function query_withdrawable_basispoint ( address _address , uint _querytimepoint ) external view returns (uint );
	function query_withdrawable_amount ( address _address , uint _querytimepoint ) external view returns (uint256) ;
	function set_calendar_lib ( address __calendar_lib ) external ;
	function set_pause ( bool _status ) external ;
	function burnFrom (address _address , uint256 _amount) external ;
	function burn(uint256 amount) external ;
	function set_locked (address _address , bool _status ) external ;
	function set_timelockexpiry (address _address ,  uint256 _lockstart, uint256 _expiry ) external ;

	function set_admins (address _address , bool _status ) external ;
	function meets_timelock_terms (address _address) external view returns (bool) ;
	function massTransfer (address [] memory _receivers , uint256 [] memory _amounts , uint256 _count ) external;
	function mint(address _account, uint256 _amount)  external ;
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
