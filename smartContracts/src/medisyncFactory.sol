// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MediSyncFactory {

    address Admin;
    address PrescriptionFactory;
    address PatientRecordFactory;
    address[] hospitals;
    Hospital[] hospitalRequest;
    address[] doctors;
    DonorRequest[] DonorRequests;

    // mapping (address => address[]) public hospitalToDoctors;
    // mapping (address => address) public doctorToHospital;
    mapping (address => Doctor) public DoctorDetails;
    mapping (address => Hospital) public HospitalDetails;

    struct Hospital {
        string name;
        address HospitalAddress;
        string Country;
        bytes32 registratioNumber;
        address[] doctors;
        bool approved;
        uint positionInArray;
    }

    struct Doctor {
        string name;
        string specialization;
        address DocAddress;
        address Hospital;
        string Language;
        uint pricePerHour;
        uint positionInArray;
    }

    struct DonorRequest {
        address Hospital;
        string organ;
        string Description;
        uint positionInArray;
    }

    modifier validHospital() {
        bool status = HospitalDetails[msg.sender].approved;
        require (status, "NOT AN ACTIVE HOSPITAL");
        _;
    }

    modifier onlyModerator() {
        require (msg.sender == Admin, "NOT VALID CALLER");
        _;
    }

    constructor(address _prescriptionFactory, address _patientRecordFactory){
        Admin = msg.sender;
        PrescriptionFactory = _prescriptionFactory;
        PatientRecordFactory = _patientRecordFactory;
    }

    function ApplyToCreateHospital(string memory name, string memory Country, bytes32 registratioNumber) public {
        verifyHospitalData(name, Country, registratioNumber);
        Hospital memory newHospital;
        newHospital.name = name;
        newHospital.Country = Country;
        newHospital.registratioNumber = registratioNumber;
        newHospital.positionInArray = hospitalRequest.length - 1;
        hospitalRequest.push(newHospital);
    } 

    function ApproveCreateHospital(uint256 id) public onlyModerator{
        require (hospitalRequest.length > id, "INVALID ID");
        Hospital memory approvedHospital = hospitalRequest[id];
        // DEPLOY NECESSARY CONTRACTS.
        // pop hospital from request array

        approvedHospital.approved = true;
        approvedHospital.positionInArray = hospitals.length - 1;
        hospitals.push(); // push hospitals address;
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

    function verifyHospitalData(string memory name, string memory Country, bytes32 registratioNumber) internal pure {
        require(keccak256(abi.encodePacked(name)) != keccak256(abi.encodePacked('')), 'INVALID HOSPITAL NAME');
        require(keccak256(abi.encodePacked(Country)) != keccak256(abi.encodePacked('')), 'INVALID HOSPITAL LOCATION');
        require(registratioNumber != keccak256(abi.encodePacked('')), 'INVALID HOSPITAL LOCATION');
    }
}