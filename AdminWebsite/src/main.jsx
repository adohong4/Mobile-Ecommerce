import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'
import App from './pages/Admin/AdminHome'
import { BrowserRouter } from 'react-router-dom'
import StoreContextProvider from './context/StoreContext.jsx'
import ProductContextProvider from './context/ProductContextProvider.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <BrowserRouter>
    <StoreContextProvider>
      <ProductContextProvider>
        <App />
      </ProductContextProvider>
    </StoreContextProvider>
  </BrowserRouter>
)
