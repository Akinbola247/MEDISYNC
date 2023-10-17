import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import Head from 'next/head';
import styles from '../styles/Home.module.css';
import Link from 'next/link';

const Navbar = () => {
  return (
    <div className={styles.container}>
      <main className={""}>
        <ul>
            <li>
                <Link href={"/"} >Home</Link>
            </li>
            <li>
                <Link href={"/groups"} >Groups</Link>
            </li>
            <li>
                <Link href={"/prescription"} >Prescription</Link>
            </li>
        </ul>
        <ConnectButton />
      </main>
    </div>
  );
};

export default Navbar;
