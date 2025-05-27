import { createContext, useEffect, useState, useCallback, useMemo } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';

export const CategoryContext = createContext(null);

const CategoryContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [categoryList, setCategoryList] = useState([]);
    const [categoryId, setCategoryId] = useState(null);
    const url = 'http://localhost:9004/v1/api/product/category';

    const fetchCategoryList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/get`);
            if (response.data.metadata) {
                setCategoryList(response.data.metadata);
            } else {
                toast.error('Lỗi khi lấy danh sách danh mục');
            }
        } catch (error) {
            toast.error('Lỗi khi lấy danh sách danh mục: ' + error.message);
        }
    }, []);

    const fetchCategoryById = useCallback(async (categoryId) => {
        try {
            const response = await axios.get(`${url}/get/${categoryId}`);
            setCategoryId(response.data.metadata);
            return response.data.metadata;
        } catch (error) {
            toast.error('Lỗi khi lấy thông tin danh mục: ' + error.message);
            throw error;
        }
    }, []);

    const createCategory = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/create`, data, {
                headers: { 'Content-Type': 'multipart/form-data' },
            });
            toast.success('Tạo danh mục thành công');
            await fetchCategoryList();
            return response.data.metadata;
        } catch (error) {
            toast.error('Lỗi khi tạo danh mục: ' + error.message);
            throw error;
        }
    }, [fetchCategoryList]);

    const softDeleteCategory = useCallback(async (categoryId) => {
        try {
            const response = await axios.delete(`${url}/softDelete/${categoryId}`);
            if (response.data.status) {
                toast.success(response.data.message || 'Xóa mềm danh mục thành công');
                await fetchCategoryList();
            } else {
                toast.error('Lỗi khi xóa mềm danh mục');
            }
        } catch (error) {
            toast.error('Lỗi khi xóa mềm danh mục: ' + error.message);
        }
    }, [fetchCategoryList]);

    const deleteCategory = useCallback(async (categoryId) => {
        try {
            const response = await axios.delete(`${url}/delete/${categoryId}`);
            if (response.data.status) {
                toast.success(response.data.message || 'Xóa danh mục thành công');
                await fetchCategoryList();
            } else {
                toast.error('Lỗi khi xóa danh mục');
            }
        } catch (error) {
            toast.error('Lỗi khi xóa danh mục: ' + error.message);
        }
    }, [fetchCategoryList]);

    useEffect(() => {
        fetchCategoryList();
    }, [fetchCategoryList]);

    const contextValue = useMemo(
        () => ({
            categoryList,
            categoryId,
            fetchCategoryList,
            fetchCategoryById,
            createCategory,
            softDeleteCategory,
            deleteCategory,
        }),
        [
            categoryList,
            categoryId,
            fetchCategoryList,
            fetchCategoryById,
            createCategory,
            softDeleteCategory,
            deleteCategory,
        ]
    );

    return (
        <CategoryContext.Provider value={contextValue}>
            {children}
        </CategoryContext.Provider>
    );
};

export default CategoryContextProvider;