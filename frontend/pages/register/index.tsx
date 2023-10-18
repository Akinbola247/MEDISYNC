import type { NextPage } from 'next';
import styles from '../../styles/Home.module.css';
import Layout from '../../components/Layout';
import RegisterDoctorPage from '../../components/RegisterDoctor';
import RegisterHospitalPage from '../../components/RegisterHospital';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
        <Layout>
            <RegisterDoctorPage />
            <RegisterHospitalPage />
        </Layout>
    </div>
  );
};

export default Home;
