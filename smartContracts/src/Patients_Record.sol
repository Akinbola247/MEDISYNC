// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Patient_Record {
    enum gender {
        Male,
        Female
    }

    enum recordStatus {
        open,
        examined,
        closed
    }

    // genotype
    enum gtype {
        AA,
        AS,
        SS
    }
    // Patient details
    struct bio {
        address patientAddr;
        bytes first_name;
        bytes last_name;
        uint Age;
        gender Sex;
        gtype Genotype;
        bytes email;
        bytes phoneNumber;
        bytes country;
    }

    struct healthRecord {
        uint sessionId;
        address patientAddr;
        uint time;
        // patient complaint/vitals
        string blood_pressure;
        string heart_rate;
        string Temperature;
        string complaint;
        // Medical history
        string PreExistingCondition;
        string Allergies;
        string FamilyMedHistory;
        // ongoing treatment
        string ongoingMedications;
        // test result
        string CID;
        recordStatus status;
    }

    struct Dr_diagnosis {
        uint time;
        uint sessionId;
        string Diagnois;
        // Treatment Plan
        string prescriptions;
        string treatmentPlan;
    }
    uint sessionID = 1000;

    // patients bio data
    mapping(address => bio) patientBio;
    // confirms patient bio is registered in the database
    mapping(address => bool) patientRecordStatus;

    // all individual patient health records
    mapping(address => healthRecord[]) public patientRecord;
    // patient record by doctor's session
    mapping(address => mapping(uint => healthRecord)) public idToRecord;
    // confirms that sessionID exists
    mapping(address => mapping(uint => bool)) public idExist;

    // Doctor's diagnosis
    mapping(address => Dr_diagnosis[]) public patientDiagnosis;
    mapping(address => mapping(uint => Dr_diagnosis)) public idToDiagnosis;

    function bioEntry(
        address _patientAddr,
        bytes memory _firstName,
        bytes memory _lastName,
        uint _age,
        gender _sex,
        gtype _genotype,
        bytes memory _email,
        bytes memory _phoneNumber,
        bytes memory _country
    ) public {
        require(patientRecordStatus[msg.sender] == false, "RECORD_EXISTS");
        bio memory _bioEntry;
        _bioEntry.first_name = _firstName;
        _bioEntry.last_name = _lastName;
        _bioEntry.Age = _age;
        _bioEntry.Sex = _sex;
        _bioEntry.Genotype = _genotype;
        _bioEntry.email = _email;
        _bioEntry.phoneNumber = _phoneNumber;
        _bioEntry.country = _country;

        patientBio[_patientAddr] = _bioEntry;

        // confirms patient data added to database
        patientRecordStatus[msg.sender] = true;
    }

    function healthRecordEntry(
        address _patientAddr,
        // uint _time,
        string memory _blood_pressure,
        string memory _heart_rate,
        string memory _temperature,
        string memory _complaint,
        string memory _preExistingCondition,
        string memory _allergies,
        string memory _familyMedHistory,
        string memory _ongoingMedications,
        string memory _cid,
        recordStatus _status
    ) public {
        require(
            patientRecordStatus[_patientAddr] == true,
            "Complete Registration"
        );
        sessionID = sessionID + 1;
        healthRecord memory _healthRecord;
        _healthRecord.sessionId = sessionID;
        _healthRecord.patientAddr = _patientAddr;
        _healthRecord.time = block.timestamp;
        _healthRecord.blood_pressure = _blood_pressure;
        _healthRecord.heart_rate = _heart_rate;
        _healthRecord.Temperature = _temperature;
        _healthRecord.complaint = _complaint;
        _healthRecord.PreExistingCondition = _preExistingCondition;
        _healthRecord.Allergies = _allergies;
        _healthRecord.FamilyMedHistory = _familyMedHistory;
        _healthRecord.ongoingMedications = _ongoingMedications;
        _healthRecord.CID = _cid;

        patientRecord[_patientAddr].push(_healthRecord);
        idToRecord[_patientAddr][sessionID] = _healthRecord;
        idExist[_patientAddr][sessionID] = true;
    }

    function diagnosis(
        address _patientAddr,
        uint _sessionId,
        string memory _diagnosis,
        string memory _prescriptions,
        string memory _treatmentPlan
    ) public {
        require(idExist[_patientAddr][_sessionId] == true, "Invalid sessionId");
        Dr_diagnosis memory _dr_Diagnosis;
        _dr_Diagnosis.sessionId = _sessionId;
        _dr_Diagnosis.time = block.timestamp;
        _dr_Diagnosis.Diagnois = _diagnosis;
        _dr_Diagnosis.prescriptions = _prescriptions;
        _dr_Diagnosis.treatmentPlan = _treatmentPlan;

        patientDiagnosis[_patientAddr].push(_dr_Diagnosis);
        idToDiagnosis[_patientAddr][_sessionId] = _dr_Diagnosis;
    }

    function retrievePatientInfo(
        address _patientAddress
    )
        public
        view
        returns (bio memory, healthRecord[] memory, Dr_diagnosis[] memory)
    {
        return (
            patientBio[_patientAddress],
            patientRecord[_patientAddress],
            patientDiagnosis[_patientAddress]
        );
    }

    function retrieveFunctionBySessionId(
        address _patientAddress,
        uint _sessionId
    )
        public
        view
        returns (bio memory, healthRecord memory, Dr_diagnosis memory)
    {
        return (
            patientBio[_patientAddress],
            idToRecord[_patientAddress][_sessionId],
            idToDiagnosis[_patientAddress][_sessionId]
        );
    }

    function retrieveRecordStatus(
        address _patientAddress
    ) public view returns (bool) {
        return patientRecordStatus[_patientAddress];
    }
}
