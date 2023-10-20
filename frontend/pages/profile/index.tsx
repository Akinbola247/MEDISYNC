import type { NextPage } from 'next';
import styles from '../../styles/Home.module.css';
import Layout from '../../components/Layout';
import DoctorProfilePage from '../../components/DoctorProfilePage';
import UserProfilePage from '../../components/UserProfilePage';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
        <Layout>
            <DoctorProfilePage />
            <UserProfilePage />
        </Layout>
    </div>
  );
};

export default Home;
