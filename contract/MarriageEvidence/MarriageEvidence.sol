pragma solidity^0.4.25;
import "./EvidenceFactory.sol";
import "./Character.sol";

contract MarriageEvidence is Character{
    address admin;
    address eviContractAddress;
    address eviAddress;
    constructor() public Character{
        admin = msg.sender;
    }
    
    modifier adminOnly{
        require(msg.sender == admin ,"require admin");
        _;
    }
    modifier charactersMustBeAddedFirst{
        require(getAllCharater().length != 0,"It is null");
        _;
    }
    function deployEvi() external adminOnly charactersMustBeAddedFirst{
        addCharacter(msg.sender,"民政局");
        EvidenceFactory evi = new EvidenceFactory(getAllCharater());
        eviContractAddress = evi;
    }
    
    function getSigners() public constant returns(address[]){
        EvidenceFactory evi = EvidenceFactory(eviContractAddress);
        return evi.getSigners();
    }
    
    function newEvi(string _evi)public adminOnly returns(address){
        EvidenceFactory evi = EvidenceFactory(eviContractAddress);
        eviAddress = evi.newEvidence(_evi);
        return eviAddress;
    }
    
    function sign() public returns(bool) {
        EvidenceFactory evi = EvidenceFactory(eviContractAddress);
            return evi.addSignatures(eviAddress);
    }
    function getEvi() public constant returns(string,address[],address[]){
        EvidenceFactory evi = EvidenceFactory(eviContractAddress);
            return evi.getEvidence(eviAddress);
    }
}