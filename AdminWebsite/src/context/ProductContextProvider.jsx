import { createContext, useEffect, useState, useCallback, useMemo } from "react";
import axios from "axios";
import { toast } from "react-toastify";

export const ProductContext = createContext(null);

const ProductContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [productList, setProductList] = useState([]);
    const [productId, setProductId] = useState(null);
    const url = "http://localhost:9004";


    const fetchProductList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/v1/api/product/get`);
            if (response.data.metadata) {
                setProductList(response.data.metadata.product);
            } else {
                toast.error("Lỗi khi lấy danh sách sản phẩm");
            }
        } catch (error) {
            toast.error("Lỗi khi lấy danh sách sản phẩm: " + error.message);
        }
    }, []);

    const fetchProductId = useCallback(async (productId) => {
        try {
            const response = await axios.get(`${url}/v1/api/product/get/${productId}`);
            setProductId(response.data.metadata.product);
        } catch (error) {
            toast.error("Lỗi khi lấy thông tin sản phẩm: " + error.message);
        }
    }, []);

    const updateProductId = useCallback(async (productId, data) => {
        try {
            const response = await axios.post(`${url}/v1/api/product/update/${productId}`, data);
            setProductId(response.data.metadata.product);
            toast.success("Cập nhật sản phẩm thành công");
        } catch (error) {
            toast.error("Lỗi khi cập nhật sản phẩm: " + error.message);
        }
    }, []);

    const removeProduct = useCallback(async (productId) => {
        try {
            const response = await axios.delete(`${url}/v1/api/product/delete/${productId}`);
            if (response.data.status) {
                toast.success(response.data.message.product);
                await fetchProductList(); // Làm mới danh sách sau khi xóa
            } else {
                toast.error("Lỗi khi xóa sản phẩm");
            }
        } catch (error) {
            toast.error("Lỗi khi xóa sản phẩm: " + error.message);
        }
    }, [fetchProductList]);

    useEffect(() => {
        fetchProductList(); // Lấy danh sách sản phẩm khi component mount
    }, [fetchProductList]);

    const contextValue = useMemo(
        () => ({
            productList,
            productId,
            fetchProductList,
            fetchProductId,
            updateProductId,
            removeProduct,
        }),
        [productList, productId, fetchProductList, fetchProductId, updateProductId, removeProduct]
    );

    return (
        <ProductContext.Provider value={contextValue}>
            {children}
        </ProductContext.Provider>
    );
};

export default ProductContextProvider;