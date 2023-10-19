import { ConnectButton } from '@rainbow-me/rainbowkit';
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
            <li>
                <Link href={"/register"} >Register</Link>
            </li>
        </ul>
        <ConnectButton />
      </main>
    </div>
  );
};

export default Navbar;
