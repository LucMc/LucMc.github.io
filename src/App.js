import React from 'react';
import Navbar from './components/Navbar';
import './App.css';
import Home from './components/pages/Home';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Publications from './components/pages/Publications';
import AboutUs from './components/pages/AboutUs';
import Blog from './components/pages/Blog';

function App() {
  return (
    <>
      <Router>
        <Navbar />
        <Switch>
          <Route path='/' exact component={Home} />
          <Route path='/aboutus' component={AboutUs} />
          <Route path='/publications' component={Publications} />
          <Route path='/blog' component={Blog} />
        </Switch>
      </Router>
    </>
  );
}

export default App;
