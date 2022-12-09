import React from 'react';
import '../App.css';
import { Button } from './Button';
import './DynamicBackground.css';
//import backgroundImg from'../img-1.jpg'


function DynamicBackground() {
  return (
    <div className='hero-container'>
      {/* //<video src='/videos/driving_stock.mp4' autoPlay loop muted />
      <img src={backgroundImg} /> */}
      <h1>CONNECTED AND AUTONOMOUS VEHICLES LAB</h1>
      <p>AUTOMOTIVE AND ROBOTICS AI RESEARCH</p>
      <div className='hero-btns'>
        <Button
          className='btns'
          buttonStyle='btn--outline'
          buttonSize='btn--large'
        >
          GET STARTED
        </Button>
        <Button
          className='btns'
          buttonStyle='btn--primary'
          buttonSize='btn--large'
          onClick={console.log('hey')}
        >
          WATCH TRAILER <i className='far fa-play-circle' />
        </Button>
      </div>
    </div>
  );
}

export default DynamicBackground;
