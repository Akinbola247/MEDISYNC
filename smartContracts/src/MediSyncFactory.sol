// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./MediSyncHospital.sol";
import "../src/interfaces/IMediSyncRecords.sol";

struct requestStatus {
    uint index;
    bool status;
}

struct Hospital {
    string name;
    address HospitalAddress;
    string Country;
    bytes32 registratioNumber;
    address[3] admins;
    bool approved;
    uint positionInArray;
    uint requestID;
    bytes32 hash_;
}

struct Doctor {
    string name;
    string specialization;
    address DocAddress;
    address Hospital;
    string Language;
    uint pricePerHour;
    uint positionInArray;
    uint doctorsID;
    bool isAvailable;
}

struct DonorRequest {
    address Hospital;
    string organ;
    string Description;
    uint positionInArray;
}

contract MediSyncFactory {
    address Admin;
    address PrescriptionFactory;
    address patientRecordContract;
    address[] hospitals;
    address[] doctors;
    Hospital[] hospitalRequest;
    DonorRequest[] DonorRequests;
    uint requestId;
    uint doctorsIDgenerator;
    // mapping (address => address[]) public hospitalToDoctors;
    // mapping (address => address) public doctorToHospital;
    mapping(address => Doctor) public DoctorDetails;
    mapping(address => Hospital) public HospitalDetails;
    mapping(uint => requestStatus) public requestIdToIndex;
    mapping(address => mapping(address => bool)) isDoctorAtHospital;

    modifier validHospital() {
        bool status = HospitalDetails[msg.sender].approved;
        require(status, "NOT AN ACTIVE HOSPITAL");
        _;
    }

    modifier onlyModerator() {
        require(msg.sender == Admin, "NOT VALID CALLER");
        _;
    }

    constructor(address _prescriptionFactory, address _patientRecordContract) {
        Admin = msg.sender;
        PrescriptionFactory = _prescriptionFactory;
        patientRecordContract = _patientRecordContract;
    }


    function ApplyToCreateHospital(
        string memory name,
        string memory Country,
        bytes32 registratioNumber,
        string memory _accessKey,
        address[3] memory _admins
    ) public {
        verifyHospitalData(name, Country, registratioNumber, _admins);
        requestId++;
        bytes32 hashRes = keccak256(abi.encodePacked(_accessKey));
        Hospital memory newHospital;
        newHospital.name = name;
        newHospital.Country = Country;
        newHospital.admins = _admins;
        newHospital.registratioNumber = registratioNumber;
        newHospital.positionInArray = hospitalRequest.length - 1;
        newHospital.requestID = requestId;
        newHospital.hash_ = hashRes;

        requestStatus memory newStatus;
        newStatus.index = newHospital.positionInArray;
        requestIdToIndex[requestId] = newStatus;
        hospitalRequest.push(newHospital);
    }

    function ApproveCreateHospital(uint256 id) public onlyModerator {
        require(requestId > id, "INVALID ID");
        require(
            requestIdToIndex[id].status == false,
            "HOSPITAL ALREADY APPROVED"
        );
        Hospital memory approvedHospital = hospitalRequest[
            requestIdToIndex[id].index
        ];
        address[3] memory _admins = approvedHospital.admins;
        MediSyncHospital newHospital = new MediSyncHospital(_admins);

        // pop hospital from request array
        initializeNewHospital(id);

        approvedHospital.approved = true;
        approvedHospital.positionInArray = hospitals.length - 1;
        hospitals.push(address(newHospital));

        IMediSyncRecords(patientRecordContract).registerHospital(
            address(newHospital),
            approvedHospital.hash_
        );
        // populate HospitalDetails Mapping
    }


    function placeDonationAdvert(
        DonorRequest memory newDonorRequest
    ) public validHospital {
        require(newDonorRequest.Hospital != address(0), "INVALID HOSPITAL");
        require(
            keccak256(abi.encodePacked(newDonorRequest.organ)) !=
                keccak256(abi.encodePacked("")),
            "INVALID ORGAN NAME"
        );
        require(
            keccak256(abi.encodePacked(newDonorRequest.Description)) !=
                keccak256(abi.encodePacked("")),
            "INVALID REQUEST DESCRIPTION"
        );
        newDonorRequest.positionInArray = DonorRequests.length - 1;
        DonorRequests.push(newDonorRequest);
    }

    function registerDoctors(
        bytes memory _calldata
    ) public validHospital returns (uint, uint) {
        Doctor memory doctorDetails = abi.decode(_calldata, (Doctor));
        doctorDetails.doctorsID = doctorsIDgenerator;
        uint returnID = doctorsIDgenerator;
        verifyDoctorData(doctorDetails);
        doctors.push(doctorDetails.DocAddress);
        DoctorDetails[doctorDetails.DocAddress] = doctorDetails;
        doctorDetails.positionInArray = doctors.length - 1;
        isDoctorAtHospital[msg.sender][doctorDetails.DocAddress] = true;
        doctorsIDgenerator++;
        // Hospital2DoctorsId2Index
        return ((doctors.length - 1), returnID);
    }


    function viewDoctors() public view returns (address[] memory) {
        return doctors;
    }

    function viewHospitals() public view returns (address[] memory) {
        return hospitals;
    }

    function viewDonationAddverts()
        public
        view
        returns (DonorRequest[] memory)
    {
        return DonorRequests;
    }

    function getDoctorsHospital(
        address _Doctor
    ) public view returns (address doctorsHospital) {
        require(_Doctor != address(0), "Invalid address zero");
        doctorsHospital = DoctorDetails[_Doctor].Hospital;
    }

    function viewDoctorsHospital(
        address _doctor
    ) public view returns (address) {
        return DoctorDetails[_doctor].Hospital;
    }

    function verifyHospitalData(
        string memory name,
        string memory Country,
        bytes32 registratioNumber,
        address[3] memory _admins
    ) internal pure {
        require(
            keccak256(abi.encodePacked(name)) !=
                keccak256(abi.encodePacked("")),
            "INVALID HOSPITAL NAME"
        );
        require(
            keccak256(abi.encodePacked(Country)) !=
                keccak256(abi.encodePacked("")),
            "INVALID HOSPITAL LOCATION"
        );
        require(
            registratioNumber != keccak256(abi.encodePacked("")),
            "INVALID HOSPITAL REGISTRATION NUMBER"
        );
        require(_admins.length == 3, "Imcomplete Admins");
        for (uint i = 0; i < _admins.length; i++) {
            require(_admins[i] != address(0), "INVALID ADMIN ADDRESS");
        }
    }

    function verifyDoctorData(Doctor memory newDoctor) internal pure {
        require(
            keccak256(abi.encodePacked(newDoctor.name)) !=
                keccak256(abi.encodePacked("")),
            "INVALID DOCTORS NAME"
        );
        require(
            keccak256(abi.encodePacked(newDoctor.specialization)) !=
                keccak256(abi.encodePacked("")),
            "INVALID DOCTORS SPECIALIZATION"
        );
        require(newDoctor.Hospital != address(0), "INVALID HOSPITAL");
        require(newDoctor.DocAddress != address(0), "INVALID DOC ADDRESS");
    }

    function initializeNewHospital(uint id) internal {
        hospitalRequest[requestIdToIndex[id].index] = hospitalRequest[hospitalRequest.length];
        uint newPositionReqID = hospitalRequest[requestIdToIndex[id].index].requestID;
        requestIdToIndex[newPositionReqID].index = requestIdToIndex[id].index;
        hospitalRequest.pop();
    }

    function unregisterDoctor(address _doctor) validHospital external {
        require (isDoctorAtHospital[msg.sender][_doctor] == true, "INVALID DOCTOR");
        uint256 DocIndex = DoctorDetails[_doctor].positionInArray;
        doctors[DocIndex] = doctors[doctors.length - 1];
        doctors.pop();
        DoctorDetails[doctors[DocIndex]].positionInArray = DocIndex;
        Doctor memory defaultDoctor;
        DoctorDetails[_doctor] = defaultDoctor;
    }

    function replaceAdmins(address[] memory _newAdmin, uint[] memory index) validHospital external {
        require (_newAdmin.length == index.length, "LENGTH MISMATCH");
        address[3] memory newAdmins = HospitalDetails[msg.sender].admins;
        for (uint i = 0; i < index.length; i++){
            newAdmins[index[i]] = _newAdmin[i];
        }
        HospitalDetails[msg.sender].admins = newAdmins;
    }
}
