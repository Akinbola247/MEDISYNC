import styles from '../styles/Home.module.css';

const PrescriptionPage = () => {

    const prescribe = () => {
        //
    }


  return (
    <div className={styles.container}>

        <div>
            <h1>Session Details</h1>
            <div>
                <p>Doctor: {}</p>
                <p>Patient: {}</p>
                <p>Session start: {}</p>
            </div>
        </div>

        <div>
            <h1>Prescription</h1>
            <div>
                <h1>Prescribe</h1>
                <div>
                    <input type="date" name="date" id="" />
                    <input type="text" name="doctor" placeholder='Doctor Address' id="" className='' />
                    <input type="text" name="patient_commitment" placeholder='Patient Commitment' id="" />
                    <input type="text" name="prescription" placeholder='Prescription' id="" />
                    <input type="text" name="recomendation" placeholder='Recommendation' id="" />
                    <input type="button" value="Prescribe" onClick={() => prescribe()} />
                </div>
            </div>

            <div>
                <h1>Prescription Summary</h1>
                <div>
                    <p>Prescription Id:</p>
                    <p>Doctor: </p>
                    <p>Patient Commitment: </p>
                    <p>Prescription: </p>
                    <p>Recommendation: </p>
                    <p>Date/Time: </p>
                </div>
            </div>
        </div>
    </div>
  );
};

export default PrescriptionPage;
