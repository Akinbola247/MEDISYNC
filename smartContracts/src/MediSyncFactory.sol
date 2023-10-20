// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./MediSyncHospital.sol";


struct requestStatus {
    uint index;
    bool status;
}

struct Hospital {
    string name;
    address HospitalAddress;
    string Country;
    bytes32 registratioNumber;
    address[] doctors;
    address[3] admins;
    bool approved;
    uint positionInArray;
    uint requestID;
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
    // mapping (address => address[]) public hospitalToDoctors;
    // mapping (address => address) public doctorToHospital;
    mapping (address => Doctor) public DoctorDetails;
    mapping (address => Hospital) public HospitalDetails;
    mapping (uint => requestStatus) public requestIdToIndex;



    modifier validHospital() {
        bool status = HospitalDetails[msg.sender].approved;
        require (status, "NOT AN ACTIVE HOSPITAL");
        _;
    }

    modifier onlyModerator() {
        require (msg.sender == Admin, "NOT VALID CALLER");
        _;
    }

    constructor(address _prescriptionFactory, address _patientRecordContract){
        Admin = msg.sender;
        PrescriptionFactory = _prescriptionFactory;
        patientRecordContract = _patientRecordContract;
    }

    function ApplyToCreateHospital(string memory name, string memory Country, bytes32 registratioNumber, address[3] memory _admins) public {
        verifyHospitalData(name, Country, registratioNumber, _admins);
        requestId ++;
        Hospital memory newHospital;
        newHospital.name = name;
        newHospital.Country = Country;
        newHospital.admins = _admins;
        newHospital.registratioNumber = registratioNumber;
        newHospital.positionInArray = hospitalRequest.length - 1;
        newHospital.requestID = requestId;

        requestStatus memory newStatus;
        newStatus.index = newHospital.positionInArray;
        requestIdToIndex[requestId] = newStatus;
        hospitalRequest.push(newHospital);
    } 

    function ApproveCreateHospital(uint256 id) public onlyModerator{
        require (requestId > id, "INVALID ID");
        require (requestIdToIndex[requestId].status == false, "HOSPITAL ALREADY APPROVED");
        Hospital memory approvedHospital = hospitalRequest[requestIdToIndex[requestId].index];
        address[3] memory _admins = approvedHospital.admins;
        MediSyncHospital newHospital = new MediSyncHospital(_admins);
       
        // pop hospital from request array
        initializeNewHospital(id);

        approvedHospital.approved = true;
        approvedHospital.positionInArray = hospitals.length - 1;
        hospitals.push(address(newHospital));
        requestIdToIndex[requestId].status = true;
        // populate HospitalDetails Mapping
    }

    function registerDoctors(Doctor memory doctorDetails) public validHospital {
        verifyDoctorData(doctorDetails);
        doctors.push(doctorDetails.DocAddress);
        DoctorDetails[doctorDetails.DocAddress] = doctorDetails;
        doctorDetails.positionInArray = doctors.length - 1;
        HospitalDetails[doctorDetails.Hospital].doctors.push(doctorDetails.DocAddress);
    }

    function placeDonationAdvert(DonorRequest memory newDonorRequest ) public validHospital {
        require (newDonorRequest.Hospital != address(0), "INVALID HOSPITAL");
        require(keccak256(abi.encodePacked(newDonorRequest.organ)) != keccak256(abi.encodePacked('')), 'INVALID ORGAN NAME');
        require(keccak256(abi.encodePacked(newDonorRequest.Description)) != keccak256(abi.encodePacked('')), 'INVALID REQUEST DESCRIPTION');
        newDonorRequest.positionInArray = DonorRequests.length - 1;
        DonorRequests.push(newDonorRequest);
    }

    function viewHospitals() public view returns(address[] memory) {
        return hospitals;
    }

    function viewDoctors() public view returns (address[] memory ){
        return doctors;
    }

    function getDoctorsHospital(address _Doctor) public view returns(address doctorsHospital) {
        require(_Doctor != address(0), "Invalid address zero");
        doctorsHospital = DoctorDetails[_Doctor].Hospital;
    }

    function viewDonationAddverts() public view returns(DonorRequest[] memory ) {
        return DonorRequests;
    }

    function viewDoctorsHospital( address _doctor) public view returns(address) { 
        return DoctorDetails[_doctor].Hospital;
    }
    function verifyDoctorData(Doctor memory newDoctor) internal pure {
        require(keccak256(abi.encodePacked(newDoctor.name)) != keccak256(abi.encodePacked('')), 'INVALID DOCTORS NAME');
        require(keccak256(abi.encodePacked(newDoctor.specialization)) != keccak256(abi.encodePacked('')), 'INVALID DOCTORS SPECIALIZATION');
        require(newDoctor.Hospital != address(0), 'INVALID HOSPITAL');
        require(newDoctor.DocAddress != address(0), 'INVALID DOC ADDRESS');
    }

    function verifyHospitalData(string memory name, string memory Country, bytes32 registratioNumber, address[3] memory _admins) internal pure {
        require(keccak256(abi.encodePacked(name)) != keccak256(abi.encodePacked('')), 'INVALID HOSPITAL NAME');
        require(keccak256(abi.encodePacked(Country)) != keccak256(abi.encodePacked('')), 'INVALID HOSPITAL LOCATION');
        require(registratioNumber != keccak256(abi.encodePacked('')), 'INVALID HOSPITAL REGISTRATION NUMBER');
        require(_admins.length == 3, "Imcomplete Admins");
        for (uint i = 0; i < _admins.length; i++) {
                require(_admins[i] != address(0), "INVALID ADMIN ADDRESS");
        }
    }

    function initializeNewHospital(uint id) internal {
        // SHOULD REMOVETHE HOSPITAL FROM THE REQUEST ARRAY THEN ADD IT
        // TO THE HOSPITALS ARRAY, IT SHOULD ALSO UPDATE THE INDEX OF THE HOSPITAL IN BOTH THE HOSPITAL ARRAY AND THE REQUEST ARRAY
    }

    function unregisterDoctor(uint id) external {
        
    }
}