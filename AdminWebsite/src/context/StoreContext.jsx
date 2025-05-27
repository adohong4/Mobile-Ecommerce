import axios from "axios";
import { createContext, useEffect, useState } from "react";
import Cookies from 'js-cookie';

export const StoreContext = createContext(null);

const StoreContextProvider = (props) => {
    const [cartItems, setCartItems] = useState({});
    const [token, setToken] = useState("");
    const [product_list, setProductList] = useState([]);
    const [account_list, setAccount] = useState([]);
    const [product_id, setProductId] = useState(null);
    const [supplier_list, setSupplierList] = useState([]);
    const [invoice, setInvoice] = useState(null);
    const [invoiceStatistic, setInvoiceStatistic] = useState(null);
    const [order, setOrder] = useState([]);
    const [contacts, setContact] = useState([]);
    const [users, setUsers] = useState([]);

    const url = "http://localhost:4001";  // URL backend

    axios.defaults.withCredentials = true;


    const fectchInvoiceStatistic = async () => {
        try {
            const response = await axios.get(`${url}/v1/api/product/invoice/statistic`);
            setInvoiceStatistic(response.data.metadata.products);
        } catch (error) {
            console.error("Lỗi:", error);
        }
    }


    useEffect(() => {
        async function loadData() {
            const cookieToken = Cookies.get("token");
            if (cookieToken) {
                setToken(cookieToken);
            }
        }
        loadData();
    }, []);

    const contextValue = {
        fectchInvoiceStatistic, invoiceStatistic,
    };

    return (
        <StoreContext.Provider value={contextValue}>
            {props.children}
        </StoreContext.Provider>
    );
};

export default StoreContextProvider;
