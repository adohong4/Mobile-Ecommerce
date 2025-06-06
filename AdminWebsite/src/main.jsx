import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'
import App from './pages/Admin/AdminHome'
import { BrowserRouter } from 'react-router-dom'

import ProductContextProvider from './context/ProductContextProvider.jsx'
import VoucherContextProvider from './context/VoucherContextProvider.jsx'
import CampaignContextProvider from './context/CampaignContextProvider.jsx'
import CategoryContextProvider from './context/CategoryContextProvider.jsx'
import AdvertiseContextProvider from './context/AdvertiseContextProvider.jsx'
import OrderContextProvider from './context/OrderContextProvider.jsx'
import AccountContextProvider from './context/AccountContextProvider.jsx'
import StoreContextProvider from './context/StoreContext.jsx'
import MessageContextProvider from './context/MessageContextProvider.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <BrowserRouter>

    <MessageContextProvider>
      <ProductContextProvider>
        <CategoryContextProvider>
          <AdvertiseContextProvider>
            <CampaignContextProvider>
              <VoucherContextProvider>
                <OrderContextProvider>

                  <App />

                </OrderContextProvider>
              </VoucherContextProvider>
            </CampaignContextProvider>
          </AdvertiseContextProvider>
        </CategoryContextProvider>
      </ProductContextProvider>
    </MessageContextProvider>

  </BrowserRouter>
)
