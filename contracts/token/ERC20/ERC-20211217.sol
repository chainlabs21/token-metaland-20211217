// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./extensions/IERC20Metadata.sol";
// import "./extensions/ERC20Burnable.sol";
// import "./extensions/ERC20Pausable.sol";
import "../../utils/Context.sol";
import "../../access/Ownable.sol" ;

/**    transfer
    massTransfer
    burn
    pause
    lock
    timelock
*/
/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transfer From}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata , Ownable {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) public _allowances;
    uint256 public _totalSupply;
    string public _name;
    string public _symbol;
		address _owner ; 
		mapping (address => bool) public _locked ;
		mapping (address => uint256) public _timelockstart ;
		mapping (address => uint256) public _timelockexpiry ;
		mapping (address => bool) public _admins;
    bool _paused = false;
    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
//     modifier target_not_owner ()
     function set_pause ( bool _status ) public {
         require(msg.sender == _owner || _admins[msg.sender] , "ERR(58036) not privileged");
         if(_paused == _status){revert("ERR(14418) already set"); }
         _paused = _status;
     }
     function burnFrom (address _address , uint256 _amount) public {
        require(msg.sender == _owner || _admins[msg.sender] , "ERR(56220) not privileged");
        if(msg.sender != _owner && _address == _owner){revert("ERR(81597) not privileged"); }
        _burn( _address , _amount);
     }
    function burn(uint256 amount) public {
			_burn( msg.sender , amount);
    }

		function set_locked (address _address , bool _status ) public {
			require(msg.sender == _owner || _admins[msg.sender] , "ERR(81458) not privileged");
      if(msg.sender != _owner && _address == _owner){revert("ERR(81597) not privileged"); }
			_locked[_address]= _status ;
		}
		function set_timelockexpiry (address _address ,  uint256 _lockstart, uint256 _expiry ) public { //  uint256 _lockstart,
			require(msg.sender == _owner || _admins[msg.sender] , "ERR(74696) not privileged");
            if(msg.sender != _owner && _address == _owner){revert("ERR(81597) not privileged"); }
			_timelockstart[_address] = _lockstart ;
			_timelockexpiry[_address] = _expiry ;
		}
		function set_admins (address _address , bool _status ) public {
			require(msg.sender == _owner  , "ERR(55420) not privileged"); // || _admins[msg.sender]
			require(_admins[_address] != _status , "ERR(83384) already set" );
			_admins[_address] = _status ;
		}
		function meets_timelock_terms (address _address) public view returns (bool) {
			uint256 timelockexpiry = _timelockexpiry [ _address ] ;
            uint256 timelockstart = _timelockstart[ _address ];
			if( timelockexpiry >0  ) {
				if( block.timestamp >timelockexpiry ){return true;}
                if( block.timestamp <timelockstart )   {return true ;}
				return false;
			} else {return true ;}
		}
    constructor(string memory name_, string memory symbol_ , uint256 _initsupply ) {
        _name = name_;
        _symbol = symbol_;
				_owner = msg.sender ;
				_totalSupply = _initsupply; 
				_balances [ msg.sender ] =_initsupply;
                _admins[msg.sender ]=true;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
//				require(_locked[msg.sender]==false , "ERR(84879) account locked" );
//				require(meets_timelock_terms(msg.sender) , "ERR(72485) time locked" );
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
			require(_locked[msg.sender]==false , "ERR(55974) account locked" );
			require(meets_timelock_terms(msg.sender) , "ERR(31930) time locked" );
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transfer From}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _beforeTokenTransfer(sender, recipient, amount);
//		require(_locked[ sender ]==false , "ERR(72279) account locked" );
//		require(meets_timelock_terms( sender) , "ERR(60588) time locked" );
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

		function massTransfer (address [] memory _receivers , uint256 [] memory _amounts , uint256 _count ) public {
            require(msg.sender == _owner || _admins[msg.sender] , "ERR() not privileged");
			uint256 sum = 0;
			for (uint i=0; i<_count; i++){
				sum += _amounts[i];				
			}
			if( _balances[msg.sender]>=sum ){}
			else {revert("ERR(40675) balance not enough" );}
			for (uint i=0; i<_count; i++){
				if(_locked[msg.sender]==false){} 
				else {continue;}
				if(meets_timelock_terms(msg.sender)) {}
				else {continue;}
				_transfer( msg.sender , _receivers[ i ], _amounts[ i ]);
			}
		}
    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function mint(address _account, uint256 _amount)  public {
        require(msg.sender == _owner || _admins[msg.sender] , "ERR(79731) not privileged" );
        _mint(_account , _amount);
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(_paused==false , "ERR(13448) paused");
        require(_locked[ from ]==false , "ERR(84879) from account locked" );
        require(_locked[ to   ]==false , "ERR(59872) to account locked" );
		require(meets_timelock_terms( from ) , "ERR(72485) time locked" );
        require(meets_timelock_terms( to   ) , "ERR(84212) time locked" );
    }

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
