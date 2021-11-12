import "./App.css";
import lottery from "./lottery";
import React, { useState, useEffect } from "react";
import web3 from "./web3";

function App() {
  const [manager, setManager] = useState();
  const [players, setPlayers] = useState([]);
  const [balance, setBalance] = useState("");
  const [message, setMessage] = useState("");
  const [formData, setFormData] = useState({});

  useEffect(() => {
    fetchData();
  }, []);

  async function fetchData() {
    const fetchManager = await lottery.methods.manager().call();
    const fetchPlayers = await lottery.methods.getPlayers().call();
    const fetchBalance = await web3.eth.getBalance(lottery.options.address);

    if (fetchManager) setManager(fetchManager);
    if (fetchPlayers) setPlayers(fetchPlayers);
    if (fetchBalance) setBalance(fetchBalance);
  }

  const updateInput = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleApplication = async (e) => {
    e.preventDefault();

    const accounts = await web3.eth.getAccounts();

    setMessage("Waiting on transaction response...");

    await lottery.methods.enter().send({
      from: accounts[0],
      value: web3.utils.toWei(formData.entryValue, "ether"),
    });

    setMessage(
      "You have been successfully entered. Congratulations and good luck!"
    );

    await fetchData();

    setFormData({
      entryValue: "",
    });
  };

  const pickWinner = async () => {
    const accounts = await web3.eth.getAccounts();

    setMessage("Waiting on transaction response...");

    await lottery.methods.pickWinner().send({
      from: accounts[0],
    });

    setMessage(
      "A winner has been picked and successfully sent the total jackpot!"
    );

    await fetchData();
  };

  return (
    <div className="app">
      <h3>Lottery Contract</h3>
      <p>This contract is managed by {manager}.</p>
      <p>There are currently {players.length} players entered.</p>
      <p>Competing to win {web3.utils.fromWei(balance, "ether")} eth.</p>
      <hr />

      <div className="entry-form">
        <h3>Enter the lottery below to win big!</h3>

        <form onSubmit={handleApplication}>
          <input
            type="text"
            name="entryValue"
            placeholder="Enter ether amount"
            onChange={updateInput}
            value={formData.entryValue || ""}
          />
          <button type="submit">Enter Lottery</button>
        </form>
      </div>
      <p className="message">{message}</p>
      <hr />
      <h3>Pick a winner</h3>
      <p>
        Feeling lucky? Hit the button below to pick a winner from the players
        entered. They take home all the money
      </p>
      <button onClick={pickWinner}>Pick a winner</button>
    </div>
  );
}

export default App;
