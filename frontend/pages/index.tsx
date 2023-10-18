import type { NextPage } from 'next';
import styles from '../styles/Home.module.css';
import Layout from '../components/Layout';
import HomePage from '../components/HomePage';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Layout>
        <HomePage />
      </Layout>
    </div>
  );
};

export default Home;
