// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DoctorsPrescriptionContract {
    
    address public doctor;
    address public doctor_id;
    // uint256 totalPrescriptions;
    // mapping(uint256 prescriptionId => Prescription prescription) public PrescriptionIdToPrescriptions;

    mapping(bytes32 patientCommitment => mapping(uint256 prescriptionId => Prescription prescription)) public PatiientToPrescriptionIdToprescription;
    mapping(bytes32 patientCommitment => uint256 prescriptionId) public PatientCommitmentToPrescriptionId;

    struct Prescription {
        uint256 prescription_id;
        address doctor;
        bytes32 patientCommitment;
        string prescription;
        string recommendation;
        uint256 timestamp;
    }

    modifier OnlyDoctor {
        require(msg.sender == doctor, "Only octor can prescribe");
        _;
    }

    function prescribe(bytes32 _patientCommitment, string memory _prescription, string memory _recommendation) public OnlyDoctor returns (Prescription memory userPrescription) {
        // userPrescription = PrescriptionIdToPrescriptions[totalPrescriptions];
        uint256 _prescriptionId = PatientCommitmentToPrescriptionId[_patientCommitment];
        userPrescription = PatiientToPrescriptionIdToprescription[_patientCommitment][_prescriptionId];
        userPrescription.doctor = doctor;
        userPrescription.patientCommitment = _patientCommitment;
        userPrescription.prescription = _prescription;
        userPrescription.prescription_id = _prescriptionId;
        userPrescription.recommendation = _recommendation;
        userPrescription.timestamp = block.timestamp;

        PatiientToPrescriptionIdToprescription[_patientCommitment][_prescriptionId] = userPrescription;

        PatientCommitmentToPrescriptionId[_patientCommitment]++;
    }


    function verify_prescription(uint256 _prescriptionId, bytes32 _patientCommitment) public view returns (bool) {
        Prescription memory userPrescription = PatiientToPrescriptionIdToprescription[_patientCommitment][_prescriptionId];

        if (userPrescription.doctor != doctor) {
            return(false);
        }

        if (userPrescription.patientCommitment != _patientCommitment) {
            return(false);
        }

        return(true);
    }
}