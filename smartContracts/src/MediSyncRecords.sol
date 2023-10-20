// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Patient_Record {
    address factoryContract;
    mapping(address => bool) private isAdmin;
    mapping(address => bool) public isMediSyncHospital;
    mapping(address => bytes) private patientBioDetails;
    mapping(address => mapping(uint => bytes)) private patientRecordBySessionId;
    mapping(address => mapping(uint => bytes[])) private patientMedicalHistory;
    mapping(address => bool) public isRegistered;
    mapping(bytes => bool) public dataAccessKey;
    bytes[] patientsBioDatabase;
    mapping(bytes => bool) private dataBaseKey;

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

    function setDataBaseKey(
        bytes memory _dataBaseKey
    ) public onlyFactoryContract {
        dataBaseKey[_dataBaseKey] = true;
    }

    function registerHospital(
        address _hospitalAddress,
        bytes memory _accessKey
    ) public onlyFactoryContract {
        isMediSyncHospital[_hospitalAddress] = true;
        dataAccessKey[_accessKey] = true;
    }

    function confirmBioRecord(
        address _patientAddress
    ) public view returns (bool) {
        return (isRegistered[_patientAddress]);
    }

    function bioEntry(
        bytes memory _calldata,
        address _patientAddress
    ) public onlyHospital {
        patientBioDetails[_patientAddress] = _calldata;
        isRegistered[_patientAddress] = true;
        patientsBioDatabase.push(_calldata);
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

    function retrieveAllPatientsBio(
        bytes memory _accessKey
    ) public view returns (bytes[] memory) {
        require(dataBaseKey[_accessKey] == true, "Unauthorized Entity");
        return (patientsBioDatabase);
    }

    function retrieveHealthRecordBySessionId(
        uint _sessionId,
        address _patientAddress,
        bytes memory _accessKey
    ) public view returns (bytes memory, bytes memory, bytes[] memory) {
        require(dataAccessKey[_accessKey] == true, "Unauthorized Entity");
        return (
            patientBioDetails[_patientAddress],
            patientRecordBySessionId[_patientAddress][_sessionId],
            patientMedicalHistory[_patientAddress][_sessionId]
        );
    }

    function retrieveMedicalHistory(
        uint _sessionId,
        address _patientAddress,
        bytes memory _accessKey
    ) public view returns (bytes memory, bytes[] memory) {
        require(dataAccessKey[_accessKey] == true, "Unauthorized Entity");
        return (
            patientBioDetails[_patientAddress],
            patientMedicalHistory[_patientAddress][_sessionId]
        );
    }
}
