// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Patient_Record {
    address factoryContract;
    mapping(address => bool) private isAdmin;
    mapping(address => bool) public isMediSyncHospital;
    mapping(address => bytes) private patientBioDetails;
    mapping(address => mapping(uint => bytes)) private patientRecordBySessionId;
    mapping(address => bytes[]) private patientMedicalHistory;
    mapping(address => bool) public isRegistered;
    mapping(address => bytes32) private hospitalAccessKey;
    mapping(address => bytes32) private patientsAccessKey;
    bytes[] patientsBioDatabase;

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
        address _hospitalAddress,
        bytes32 _hospitalAccessKey
    ) public onlyFactoryContract {
        isMediSyncHospital[_hospitalAddress] = true;
        hospitalAccessKey[_hospitalAddress] = _hospitalAccessKey;
    }

    function confirmBioRecord(
        address _patientAddress
    ) public view returns (bool) {
        return (isRegistered[_patientAddress]);
    }

    function bioEntry(
        bytes memory _calldata,
        address _patientAddress,
        bytes32 _accessKey
    ) public onlyHospital {
        patientBioDetails[_patientAddress] = _calldata;
        isRegistered[_patientAddress] = true;
        patientsBioDatabase.push(_calldata);
        patientsAccessKey[_patientAddress] = _accessKey;
    }

    function healthRecordBySessionId(
        uint _sessionId,
        bytes memory _calldata,
        address _patientAddress
    ) public onlyHospital {
        patientRecordBySessionId[_patientAddress][_sessionId] = _calldata;
        patientMedicalHistory[_patientAddress].push(_calldata);
    }

    function retrieveAllPatientsBio(
        string memory _accessKey
    ) public view returns (bytes[] memory) {
        bytes32 _key = keccak256(abi.encodePacked(_accessKey));
        require(_key == hospitalAccessKey[msg.sender], "Unauthorized Entity");
        return (patientsBioDatabase);
    }

    function retrieveHealthRecordBySessionId(
        uint _sessionId,
        address _patientAddress,
        string memory _accessKey
    ) public view returns (bytes memory, bytes memory, bytes[] memory) {
        bytes32 _key = keccak256(abi.encodePacked(_accessKey));
        require(_key == hospitalAccessKey[msg.sender], "Unauthorized Entity");
        return (
            patientBioDetails[_patientAddress],
            patientRecordBySessionId[_patientAddress][_sessionId],
            patientMedicalHistory[_patientAddress]
        );
    }

    function retrieveMedicalHistory(
        address _patientAddress,
        string memory _accessKey
    ) public view returns (bytes memory, bytes[] memory) {
        require(
            keccak256(abi.encodePacked(_accessKey)) ==
                patientsAccessKey[_patientAddress],
            "Key_Invalid"
        );
        return (
            patientBioDetails[_patientAddress],
            patientMedicalHistory[_patientAddress]
        );
    }
}
