import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';
import configureStore from './store/store';
import { Provider } from 'react-redux';
import csrfFetch from './store/csrf';


const store = configureStore();

if (import.meta.env.MODE !== "production") {
  window.store = store;
  window.csrfFetch = csrfFetch;
}






ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <Provider store={store}>
      <App />
    </Provider>
  </React.StrictMode>
);
