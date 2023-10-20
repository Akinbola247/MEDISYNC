import styles from '../styles/Home.module.css';

const HospitalPage = () => {


  return (
    <div className={styles.container}>
        <div>
            <h1>Hospital Name:</h1>
            <div>
                <p>Name:</p>
                <p>Address:</p>
                <p>Email:</p>
            </div>
        </div>
    </div>
  );
};

export default HospitalPage;
