import React, { useState, useEffect } from 'react'
import { ethers } from "ethers";
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoBird from "../abis/KryptoBird.json";

export default function App() {
    const [account, setAccount] = useState("");
    const [contract, setContract] = useState(null)
    // eslint-disable-next-line
    const [totalSupply, setTotalSupply] = useState(0)
    const [kryptoBirdz, setKryptoBirdz] = useState([])

    useEffect(() => {
        loadWeb3();
        loadBlockchainData();
    }, [])

    // Detect metamask
    const loadWeb3 = async () => {
        // modern browser
        // this returns the provider, or null if it wasn't detected
        const provider = await detectEthereumProvider();

        if (provider) {
            startApp(provider); // Initialize your app
            console.log("Ethereum wallet is connected")
        } else {
            console.log("No ethereum wallet detected!");
        }

        function startApp(provider) {
            // If the provider returned by detectEthereumProvider is not the same as
            // window.ethereum, something is overwriting it, perhaps another wallet.
            if (provider !== window.ethereum) {
                console.error('Do you have multiple wallets installed?');
            }
            // Access the decentralized web!
        }
    }

    const loadBlockchainData = async () => {
        const web3 = window.ethereum;
        const accounts = await web3.request({
            method: "eth_requestAccounts",
        })
        setAccount(accounts[0])
        const networkId = await web3.request({ method: 'net_version' });
        const networkData = KryptoBird.networks[networkId]
        if (networkData) {
            const abi = KryptoBird.abi;
            const address = networkData.address;
            // A Web3Provider wraps a standard Web3 provider, which is
            // what MetaMask injects as window.ethereum into each page
            const provider = new ethers.providers.Web3Provider(web3)
            const signer = provider.getSigner()
            const contract = new ethers.Contract(address, abi, signer)
            setContract(contract)
            const totalSupply = await contract.totalSupply()
            setTotalSupply(totalSupply)
            // set up an array to keep track of token 
            // and load the kryptoBirds
            for (let i = 1; i <= totalSupply; i++) {
                const KryptoBird = await contract.kryptobirdz(i - 1)
                setKryptoBirdz(kryptoBirdz => [...kryptoBirdz, KryptoBird])
            }
        } else {
            alert("Smart contract not deployed!")
        }
    }

    const mint = async (KryptoBird) => {
        contract.mint(KryptoBird).then(() => {
            setKryptoBirdz(kryptoBirdz => [...kryptoBirdz, KryptoBird])
        })
    }

    return (
        <div>
            <nav className="navbar navbar-expand-lg navbar-dark bg-dark text-white">
                <a className="navbar-brand" href="/"> KryptoBird NFTs (Non-fungible Token)</a>
                <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>

                <div className="collapse navbar-collapse" id="navbarSupportedContent">

                    <div className="ml-auto"
                    >
                        <small>{account}</small>
                    </div>
                </div>
            </nav>
            <div className="container-fluid mt-1">
                <div className="">
                    <main role="main">
                        <form className="form mt-2" onSubmit={
                            (e) => {
                                e.preventDefault();
                                mint(e.target.text.value)
                            }
                        } >
                            <h1 className="my-2">KryptoBirdz- NFT Marketplace</h1>
                            <div className="form-group">
                                <input type="text" className="form-control"
                                    placeholder="Add a file location"
                                    id="text" style={{
                                        width: "50%",
                                        margin: ".5rem auto"
                                    }} />
                                <input type="submit" className="btn" value="MINT" />
                            </div>
                        </form>
                        <hr />
                        <div className="">
                            {kryptoBirdz.map((kbird, key) => {
                                return (
                                    <div className="card" key={kbird}
                                        style={{
                                            
                                        }}>
                                        <img src={kbird} className="card-img-top" alt="..."
                                        style={{
                                            border: ".3px rgba(#e0e0e0)",
                                            boxShadow: "10px 10px 8px rgba(#111111)",
                                            borderRadius: "14px",
                                            padding: "15px",
                                            width: "100%",
                                            marginTop: "10px"
                                        }}
                                        />
                                        <div className="card-body">
                                            <h5 className="card-title">KryptoBird</h5>
                                            <p className="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                            <button className="btn ">
                                                {/* eslint-disable-next-line */}
                                                <a href="" download={kbird}
                                                style={{
                                                    textDecoration: "none",
                                                    color: 'white'
                                                }}>Download</a>
                                            </button>
                                        </div>
                                    </div>
                                )
                            })}
                        </div>
                    </main>
                </div>
            </div>
        </div>
    )
}
