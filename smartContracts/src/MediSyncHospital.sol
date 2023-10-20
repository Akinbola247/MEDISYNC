// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import '../src/interfaces/IMediSyncRecords.sol';
interface IMediSyncFactory {
    //function signature needs to be refactored in MedisyncFactory;
    //mapping of address => bytes 
    //address and calldata is sent to factory, factory abi.decodes, add position of doctor in a the array
    //encodes it back and sends it to record contract as bytes 
    //to be saved as a mapping of address => bytes.
    function registerDoctors(address doctorsAddress, bytes memory _calldata) external;
}


contract MediSyncHospital {
    address[3] adminstrator;
    address recordsContractAddr;
    address factoryAddress;
    // Doctor[] private HospitalDoctors;
    uint sessionIDgenerator;
    uint doctorsIDgenerator;
    
    // mapping (bytes => patientRecord[]) private allPatientRecords; //will not be saved here, going to records contract
    // bytes[] keyhash; //precompile hash, prequisite to view certain info. going to the records contract 

    
    struct patientBio{
        address patientAddr;
        string first_name;
        string last_name;
        uint Age;
        gender Sex;
        gtype Genotype;
        string email;
        uint phoneNumber;
        string country;
    }
    struct sessionDetails {
        uint bookedDoctorID;
        address patientAddr;
        uint time;
        // patient complaint/vitals
        uint blood_pressure;
        uint heart_rate;
        uint Temperature;
        string complaint;
        // Medical history
        string PreExistingCondition;
        string Allergies;
        string FamilyMedHistory;
        // ongoing treatment
        string ongoingMedications;
        // test result
        string CID;
        string doctorsDiagnosis;
        sessionStatus status;
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
    enum gender {Male,Female}
    enum sessionStatus {open,examined,closed}
    enum gtype {AA,AS,SS}
    struct doctorSessionNote{
        address patientAddress;
        uint sessionID;
    }    
    

    mapping (address => uint)doctorAddressToID ;
    mapping (address => doctorSessionNote[]) requestedSessionInfo;
    mapping (uint => address) doctorIDtoAddress;
    mapping (address => bool) isDoctorRegistered;
    mapping (address => bytes32) hashDet;

    modifier isDoctor {
        require(isDoctorRegistered[msg.sender], 'not doctor');
        _;
    }
    modifier isAdmin {
        require(msg.sender == adminstrator[0] ||
        msg.sender == adminstrator[1] ||
        msg.sender == adminstrator[2], 'NOT_ADMIN');
        _;
    }
    constructor(address[3] memory admins){
        adminstrator[0] = admins[0];
        adminstrator[1] = admins[1];
        adminstrator[2] = admins[2];
        sessionIDgenerator = 1;
        doctorsIDgenerator = 1;
    }

    //stores patient bio in records contract
    function storePatientBio(string memory _firstName,
        string memory _lastName,
        uint _age,
        gender _sex,
        gtype _genotype,
        string memory _email,
        uint _phoneNumber,
        string memory _country,
        string memory choose_passkey)public{
        //check if patient has record. else, create record
        require(IMediSyncRecords(recordsContractAddr).confirmBioRecord(msg.sender), 'RECORD_EXISTS');
        patientBio memory bio = patientBio(msg.sender, _firstName, _lastName, _age, _sex, _genotype, _email, _phoneNumber, _country);
        bytes memory _calldata = abi.encode(bio);
        //makes call to record contract to save patient bio
        IMediSyncRecords(recordsContractAddr).bioEntry(_calldata, msg.sender);
        hashDet[msg.sender] = keccak256(abi.encodePacked(choose_passkey)); 

    }


    //patient books session with doctor
    //todo: check if amount paid is correct
    function bookDoctorSession(uint _doctorID,
        uint _bloodPressure,
        uint _heartRate,
        uint temprature,
        string memory _complaint,
        string memory _existingCondition,
        string memory _allergies,
        string memory _familyMedHistory,
        string memory _ongoingMedications,
        string memory _ipfsCID
     )public payable{
        // address doctor_ = doctorIDtoAddress[_doctorID];
        require(IMediSyncRecords(recordsContractAddr).confirmBioRecord(msg.sender), 'RECORD_EXISTS');
        //To do Check doctor's price
        sessionDetails memory session = sessionDetails(
           _doctorID,
           msg.sender,
           block.timestamp,
           _bloodPressure,
           _heartRate,
           temprature,
           _complaint,
           _existingCondition,
           _allergies,
           _familyMedHistory,
           _ongoingMedications,
           _ipfsCID, 
           'NULL',
           sessionStatus.open 
        );
        bytes memory _calldata = abi.encode(session);
        address doctors_address = doctorIDtoAddress[_doctorID];
        require(doctors_address != address(0), 'INCORRECT_DOCTOR_ID');
        IMediSyncRecords(recordsContractAddr).healthRecordBySessionId(sessionIDgenerator,_calldata, msg.sender);
        requestedSessionInfo[doctors_address].push(doctorSessionNote(msg.sender,sessionIDgenerator));
        sessionIDgenerator++;
        //To do: check doctor's availability before booking
    }

    //Only admin can call
    function registerDoctor(address _doctorAddress,  
    string memory _name,
    string memory _specialization,
    string memory _language,
    uint _pricePerHour)public isAdmin(){     
        Doctor memory doctorDetails = Doctor(
            _name,
            _specialization,
            _doctorAddress,
            address(this),
            _language,
            _pricePerHour,
            0
        );
        bytes memory _calldata = abi.encode(doctorDetails);
        //factory contract has to abi.decode, add arraynumber, convert 
        //it back to byte before sending it to records contract or saving it in itself
        IMediSyncFactory(factoryAddress).registerDoctors(_doctorAddress, _calldata);
        isDoctorRegistered[msg.sender] = true;
        doctorAddressToID[_doctorAddress] = doctorsIDgenerator;
        doctorIDtoAddress[doctorsIDgenerator] = _doctorAddress;
        doctorsIDgenerator++;
//to do: the factory contract should return position in Array before pushing to array of hospital doctors
//      _calldata.positionInArray = ''
//      HospitalDoctors.push(_calldata);
//to do: assign key

    }

    function handleConsultation(address _patient,uint _sessionID, bytes memory _passkey, sessionStatus status_, string memory _diagnosis, string memory _prescription)public isDoctor() {
        (, sessionDetails memory session_, ) = retrieveRecord(_patient, _sessionID,_passkey);
        require(session_.bookedDoctorID == doctorAddressToID[msg.sender], 'Not_assigned_doctor');
        sessionDetails memory computeSession = sessionDetails(
            session_.bookedDoctorID,
            session_.patientAddr,
            session_.time,
            session_.blood_pressure,
            session_.heart_rate,
            session_.Temperature,
            session_.complaint,
            session_.PreExistingCondition,
            session_.Allergies,
            session_.FamilyMedHistory,
            session_.ongoingMedications,
            session_.CID,
            _diagnosis,
            status_
        );
        bytes memory _calldata = abi.encode(computeSession);
        IMediSyncRecords(recordsContractAddr).healthRecordBySessionId(_sessionID,_calldata, _patient);
        //to do: update prescription contract.
    }
  
    //set doctors availability, only doctors
    function setavailability()public isDoctor() {
        //to do: set availability in factory contract doctor struct
    }
    //Only admin can call
    function unregisterDoctor()public{
        //to do: unregister doctor from factory
    }

    //add or remove admin
    function addAdmin(address _newAdmin, uint index)public isAdmin(){
        require(_newAdmin != address(0), 'Invalid address');
        require(adminstrator[index] == address(0), 'position_occupied');
        adminstrator[index] = _newAdmin;
    }

    function removeAdmin (address AdminTobeRemoved, uint index)public isAdmin(){
        require(AdminTobeRemoved != address(0), 'Invalid address');
        require(adminstrator[index] == AdminTobeRemoved, 'Invalid_Admin');
        adminstrator[index] = address(0);
    }

    function retrieveRecord(address _patientAddress, uint _sessionID, bytes memory _key) internal returns(patientBio memory bioData, sessionDetails memory currentSessionDetail, sessionDetails[] memory prevSessions){
       (bytes memory bio_, bytes memory session_, bytes[] memory sessionHistories) = IMediSyncRecords(recordsContractAddr).retrieveHealthRecordBySessionId(_sessionID,_patientAddress,_key);
       bioData = abi.decode(bio_,(patientBio));
       currentSessionDetail = abi.decode(session_,(sessionDetails));
          if (sessionHistories.length > 0) {
        prevSessions = new sessionDetails[](sessionHistories.length);
        for (uint i = 0; i < sessionHistories.length; i++) {
            prevSessions[i] = abi.decode(sessionHistories[i], (sessionDetails));
        }
    }
    }
    function checkBookedSessions(address _doctor) public view returns(doctorSessionNote[] memory){
         return requestedSessionInfo[_doctor];
    }
    function previewMedicalData(address _patient,uint _sessionID, bytes memory _passkey) public returns (patientBio memory, sessionDetails memory, sessionDetails[] memory prevSessions){
        (patientBio memory bio_, sessionDetails memory session_, sessionDetails[] memory prevSessions_) = retrieveRecord(_patient, _sessionID, _passkey);
        return (bio_,session_,prevSessions_);
    }

    function PatientMedicalPreview(address patient, string memory _passKey) view public{
        //check hashing
        require(keccak256(abi.encodePacked(_passKey)) == hashDet[patient], 'Key_Invalid');
        

    }
}