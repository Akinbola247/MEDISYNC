import { useState } from 'react';
import styles from '../styles/Home.module.css';
import { Identity } from '@semaphore-protocol/identity';
import { Group } from '@semaphore-protocol/group';

const GroupPage = () => {

    // Generate User
    const [trapdoor, setTrapdoor] = useState("");
    const [nullifier, setNullifier] = useState("");
    const [commitment, setCommitment] = useState("");
    const [secret, setSecret] = useState("");

    function generate_user_details(secret: any) {
        const { trapdoor, nullifier, commitment } = new Identity(secret);
        setTrapdoor(trapdoor.toString());
        setNullifier(nullifier.toString());
        setCommitment(commitment.toString());

    }


    // Create Group
    const [groupId, setGroupId] = useState<any>();
    const [group, setGroup] = useState<any>();
    const [memberToAdd, setMemberToAdd] = useState<any>();

    function create_group(group_id: any) {
        const group = new Group(group_id);
        setGroup(group)
    }

    function add_member(member_to_add: any) {
        group?.addMember(member_to_add)
    }


  return (
    <div className={styles.container}>
        <p>Enter secret</p>
        <input type="password" name="secret" id="" onChange={(e) => {setSecret(e.target.value)}} />
        <input type="button" value="Generate details" onClick={() => generate_user_details(secret)} />

        <div>
            <h1>User Details</h1>
            <div>
                <p>Your Trapdoor: {trapdoor}</p>
                <p>Your Nullifier: {nullifier}</p>
                <p>Your Commitment: {commitment}</p>
            </div>
        </div>

        <div>
            <h1>Remedy Groups</h1>
            <div>
                <h1>Create Group</h1>
                <div>
                    <input type="text" name="group_id" placeholder='Group Id' id="" onChange={(e) => setGroupId(e.target.value)} />
                    <input type="button" value="Create Group" onClick={() => create_group(groupId)} />
                </div>
            </div>
            <div>
                <p>Group Id: {group?._id}</p>
                <p>Group Root: {group?.merkleTree?._hash}</p>
                <p>Group Tree depth: {group?.merkleTree?._depth}</p>
                <p>Group Tree nodes: {group?.merkleTree?._nodes}</p>
                <p>Group Tree zeroes: {group?.merkleTree?._zeros}</p>
                <p>Group Tree arity: {group?.merkleTree?._arity}</p>
                <p>Total members: </p>
                <p>Maximum members: </p>
            </div>
        </div>

        <div>
            <h1>Add member</h1>
            <div>
                <input type="text" name="member-to-add" id="" onChange={(e) => {setMemberToAdd(e.target.value)}} />
                <input type="button" value="Add member" onClick={() => {add_member(memberToAdd)}} />
            </div>
        </div>

        <div>
            <h1>Get Group</h1>
            <input type="text" name="group-id" id="" placeholder='Group ID' />
            <input type="button" value="Get Group" />
        </div>
    </div>
  );
};

export default GroupPage;
