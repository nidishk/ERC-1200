pragma solidity ^0.4.11;

import './CrowdsaleControl.sol';
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 Simple Token based on OpenZeppelin token contract
 */
contract ControlCentre is CrowdsaleControl {

    /**
    * @dev Constructor that gives msg.sender all of existing tokens.
    */
    function ControlCentre(address _satellite, address _dataCentreAddr) public
        CrowdsaleControl(_satellite, _dataCentreAddr)
    {

    }

    // Owner Functions
    function setContracts(address _satellite, address _dataCentreAddr) public onlyAdmins whenPaused(address(0)) {
        dataCentreAddr = _dataCentreAddr;
        satellite = _satellite;
    }

    function kill(address _newController) public onlyAdmins whenPaused(address(0)) {
        if (dataCentreAddr != address(0)) {
            Ownable(dataCentreAddr).transferOwnership(_newController);
        }

        if (satellite != address(0)) {
            Ownable(satellite).transferOwnership(_newController);
        }

        selfdestruct(_newController);
    }

}