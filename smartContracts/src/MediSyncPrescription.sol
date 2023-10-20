// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "./interfaces/IMediSyncFactory.sol";


struct Prescription {
    uint256 prescription_id;
    address doctor;
    address patientAddress;
    string prescription;
    string recommendation;
    uint256 timestamp;
}



contract MediSyncPrescription {

    address public factory;

    mapping(address patientAddress => mapping(uint256 prescriptionId => Prescription prescription)) public PatiientToPrescriptionIdToprescription;
    mapping(address patientAddress => uint256 prescriptionId) public PatientAddressToPrescriptionId;


    mapping (bytes32 => bool) public isHospital;

    mapping (address => bytes32) public patientAddressToAccessKey;


    modifier OnlyHospital(bytes32 _accessKey) {
        bool _isHospital = isHospital[_accessKey];
        require(_isHospital, "Only hospital can call this function");
        _;
    }


    modifier OnlyFactory {
        require(msg.sender = factory, "Only hospital can call this function");
        _;
    }

    constructor (address _factory) public {
        factory = _factory;
    }

    functio

    function prescribe(bytes32 _accessKey, address _patientAddress, string memory _prescription, string memory _recommendation) public OnlyHospital(_accessKey) returns (Prescription memory userPrescription) {
        uint256 _prescriptionId = PatientAddressToPrescriptionId[_patientAddress];
        userPrescription = PatiientToPrescriptionIdToprescription[_patientAddress][_prescriptionId];
        userPrescription.doctor = doctor;
        userPrescription.patientAddress = _patientAddress;
        userPrescription.prescription = _prescription;
        userPrescription.prescription_id = _prescriptionId;
        userPrescription.recommendation = _recommendation;
        userPrescription.timestamp = block.timestamp;

        PatiientToPrescriptionIdToprescription[_patientAddress][_prescriptionId] = userPrescription;

        PatientAddressToPrescriptionId[_patientAddress]++;
    }


    function verify_prescription(uint256 _prescriptionId, address _patientAddress) public view returns (bool) {
        Prescription memory userPrescription = PatiientToPrescriptionIdToprescription[_patientAddress][_prescriptionId];

        if (userPrescription.doctor != doctor) {
            return(false);
        }

        if (userPrescription.patientAddress != _patientAddress) {
            return(false);
        }

        return(true);
    }


    function viewPrescription(uint256 _prescriptionId) public view returns (string memory prescription) {
        // require only patient to call this
    }
}