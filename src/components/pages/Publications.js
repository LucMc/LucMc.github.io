import React from 'react';
import '../../App.css';
import './Pages.css'
import Footer from '../Footer';

export default function Publications() {
  return (
    <>
      <div class="PublicationsBody">

        <br></br><br></br>
        <h1 className='publications'>PUBLICATIONS</h1>
        <br></br><br></br>

        <div class="info">
          <ul>
            <li>
              M. Raisi, A. Noohian, L. Mccutcheon, and S. Fallah,
              “Value Summation: A novel Scoring Function for MPC-based Model-based reinforcement learning”,
              arXiv:2209.08169, 2022.

            </li><br></br>
            <li>
              M. Yildirim, S. Mozaffari, L. McCutcheon, M. Dianati, and S. Fallah,
              “Prediction based decision making for autonomous highway driving”,
              arXiv:2209.02106, 2022.
            </li>

          </ul>
          <br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br>
        </div>
        <br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br>

      </div>
    <Footer/>
    </>
  );
}
