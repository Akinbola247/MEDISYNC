import type { NextPage } from 'next';
import styles from '../../styles/Home.module.css';
import Layout from '../../components/Layout';
import PrescriptionPage from '../../components/PrescriptionPage';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
        <Layout>
            <PrescriptionPage />
        </Layout>
    </div>
  );
};

export default Home;
