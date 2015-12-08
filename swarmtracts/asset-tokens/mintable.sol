/*
This creates a digital cryptocurrency that is controlled by another contract.
That contract–the "mint"-has the powers to create new tokens out of thin air,
and freeze and unfreeze accounts, preventing them from sending these tokens.

This contract is intended for educational purposes, you are fully responsible
for compliance with present or future regulations of finance, communications
and the universal rights of digital beings.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
*/

contract mintableToken {
    /* Public variables of the token */
    string public name;
    string public symbol;
    uint8 public decimals;
    address public issuer;

    /* This creates an array with all balances */
    mapping (address => uint) public balanceOf;
    mapping (address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function mintableToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol, address centralMinter) {
        /* if supply not given then generate 1 million of the smallest unit of the token */
        if (initialSupply == 0) initialSupply = 1000000;

        if(centralMinter == 0) centralMinter = msg.sender;
        issuer = centralMinter;

        /* Unless you add other functions these variables will never change */
        balanceOf[centralMinter] = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;

        /* If you want a divisible token then add the amount of decimals the base unit has  */
        decimals = decimalUnits;
    }

    /* Send coins */
    function transfer(address recipient, uint256 amount) {
        /* if the sender doenst have enough balance then stop */
        if (balanceOf[msg.sender] < amount  /* has enough funds? */
            || balanceOf[recipient] + amount < balanceOf[recipient] /* Checks for overflows */
            || frozenAccount[msg.sender])  /* is frozen? */
            throw;

        /* Add and subtract new balances */
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        /* Notifiy anyone listening that this transfer took place */
        Transfer(msg.sender, recipient, amount);
    }

    modifier onlyIssuer {
        if (msg.sender != issuer) throw;
        _
    }

    function mintToken(address target, uint256 mintedAmount) onlyIssuer {
        balanceOf[target] += mintedAmount;

        Transfer(0, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyIssuer {
        frozenAccount[target] = freeze;

        FrozenFunds(target, freeze);
    }
}
