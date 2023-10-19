// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Patient_Record {
    address factoryContract;
    mapping(address => bool) private isAdmin;
    mapping(address => bool) public isMediSyncHospital;
    mapping(address => bytes) private patientBioDetails;
    mapping(address => mapping(uint => bytes)) private patientRecordBySessionId;
    mapping(address => mapping(uint => bytes[])) private patientMedicalHistory;

    constructor(address _factoryContract) {
        isAdmin[msg.sender] = true;
        factoryContract = _factoryContract;
    }

    modifier onlyHospital() {
        require(isMediSyncHospital[msg.sender] == true, "Unauthorized Entity");
        _;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender] == true, "Unauthorized Personnel");
        _;
    }

    modifier onlyFactoryContract() {
        require(msg.sender == factoryContract, "Unauthorized entity");
        _;
    }

    function registerHospital(
        address _hospitalAddress
    ) public onlyFactoryContract {
        isMediSyncHospital[_hospitalAddress] = true;
    }

    function bioEntry(
        bytes memory _calldata,
        address _patientAddress
    ) public onlyHospital {
        patientBioDetails[_patientAddress] = _calldata;
    }

    function healthRecordBySessionId(
        uint _sessionId,
        bytes memory _calldata,
        address _patientAddress
    ) public onlyHospital {
        patientRecordBySessionId[_patientAddress][_sessionId] = _calldata;
    }

    function medicalHistoryEntry(
        uint _sessionId,
        bytes memory _calldata,
        address _patientAddress
    ) public onlyHospital {
        patientMedicalHistory[_patientAddress][_sessionId].push(_calldata);
    }

    function retrieveHealthRecordBySessionId(
        uint _sessionId,
        address _patientAddress
    ) public view returns (bytes memory, bytes memory) {
        require(
            isMediSyncHospital[msg.sender] == true ||
                isAdmin[msg.sender] == true,
            "Unauthorized Entity"
        );
        return (
            patientBioDetails[_patientAddress],
            patientRecordBySessionId[_patientAddress][_sessionId]
        );
    }

    function retrieveMedicalHistory(
        uint _sessionId,
        address _patientAddress
    ) public view returns (bytes memory, bytes[] memory) {
        return (
            patientBioDetails[_patientAddress],
            patientMedicalHistory[_patientAddress][_sessionId]
        );
    }
}
