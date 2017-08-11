pragma solidity ^0.4.8;

import "./HumanStandardToken.sol";

contract QToken is HumanStandardToken {
    
    mapping (address => bool) authorisers;
    address creator;
    bool canPay = true;
    
    function QToken() HumanStandardToken(0, "Q", 18, "QTQ"){
        creator = msg.sender;
    }
    
    /**
     *  Permissions modifiers
     */
    
    modifier ifCreator(){
        if(creator != msg.sender){
            revert();
        }
        _;
    }
    
    modifier ifAuthorised(){
        if(authorisers[msg.sender] || creator == msg.sender){
            _;
        }
        else{
            revert();
        }
    }
    
    modifier ifCanPay(){
        if(!canPay){
            revert();
        }
        _;
    }
    
    /**
     *  Events
     */
     
    event Authorise(bytes16 _message, address indexed _actioner, address indexed _actionee);
    
    /**
     *  User authorisation management methods
     */ 
    
    function authorise(address _address) ifAuthorised{
        authorisers[_address] = true;
        Authorise('Added', msg.sender, _address);
    }
    
    function unauthorise(address _address) ifAuthorised{
        delete authorisers[_address];
        Authorise('Removed', msg.sender, _address);
    }
    
    function replaceAuthorised(address _toReplace, address _new) ifAuthorised{
        delete authorisers[_toReplace];
        Authorise('Removed', msg.sender, _toReplace);
        
        authorisers[_new] = true;
        Authorise('Added', msg.sender, _new);
    }
    
    function isAuthorised(address _address) public constant returns(bool){
        return authorisers[_address] || (creator == _address);
    }
    
    /**
     *  Special transaction methods
     */ 
     
    function pay(address _address, uint256 _value) ifCanPay ifAuthorised{
        balances[_address] += _value;
        totalSupply += _value;
        
        Transfer(address(this), _address, _value);
    }
    
    function killPay() ifCreator{
        canPay = false;
    }
}