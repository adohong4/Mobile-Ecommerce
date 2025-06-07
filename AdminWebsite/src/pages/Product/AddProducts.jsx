import React, { useState, useContext, useEffect } from 'react';
import '../styles/styles.css';
import { assets } from '../../assets/assets';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Tab, Tabs } from 'react-bootstrap';
import { ProductContext } from '../../context/ProductContextProvider';
import { CategoryContext } from '../../context/CategoryContextProvider';
import TiptapEditor from '../../components/TiptapEditor';

const AddProduct = () => {
    const { url } = useContext(ProductContext);
    const { categoryList, fetchCategoryList } = useContext(CategoryContext);
    const [images, setImage] = useState([]);
    const [data, setData] = useState({
        title: "",
        nameProduct: "",
        price: "",
        recap: "",
        description: "",
        category: "",
        quantity: "",
    });
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        fetchCategoryList();
    }, [fetchCategoryList]);


    const onChangeHandler = (event) => {
        const name = event.target.name;
        const value = event.target.value;
        setData(data => ({ ...data, [name]: value }))
    };

    const onEditorChangeHandler = (name, value) => {
        setData(data => ({ ...data, [name]: value }));
    };


    const onSubmitHandler = async (event) => {
        event.preventDefault();
        setLoading(true);
        const formData = new FormData();
        formData.append("title", data.title);
        formData.append("nameProduct", data.nameProduct);
        formData.append("description", data.description);
        formData.append("recap", data.recap);
        formData.append("price", Number(data.price));
        formData.append("quantity", Number(data.quantity));
        formData.append("category", data.category);
        Array.from(images).forEach(image => formData.append("images", image));

        try {
            console.log("data: ", formData)
            const response = await axios.post(`http://localhost:9004/v1/api/product/add`, formData);
            if (response.data.status) {
                setData({
                    title: "",
                    nameProduct: "",
                    price: "",
                    recap: "",
                    description: "",
                    category: "",
                    quantity: "",
                });
                setImage([]);
                toast.success("Thêm sản phẩm thành công");
            } else {
                toast.error(response.data.message);
            }
        } catch (error) {
            console.error("Error adding product:", error);
            toast.error("Đã có lỗi xảy ra!");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="add d-flex align-items-center justify-content-center add-tab" style={{ minHeight: '100vh' }}>
            <div className=" addprd card p-5 shadow-lg border-0" style={{ width: '90vw', borderRadius: '15px', height: '100%' }}>
                <form onSubmit={onSubmitHandler}>
                    <div className='add-body-product'>
                        <div className='tab-left col-8'>

                            <Tabs defaultActiveKey="general" id="product-tabs" >
                                <Tab eventKey="general" title="Thông Tin Sản Phẩm">
                                    <div className="form-group text-center" style={{ display: "flex", gap: "10px", alignItems: "center" }}                                    >
                                        <p className="font-weight-bold mb-1">Thêm ảnh sản phẩm</p>
                                        <label htmlFor="images" style={{ cursor: 'pointer' }}>
                                            <div className="upload-preview-container">
                                                {images.length > 0 ? (
                                                    images.map((img, index) => (
                                                        <img
                                                            key={index}
                                                            src={URL.createObjectURL(img)}
                                                            alt={`Upload Preview ${index + 1}`}
                                                            className=" shadow-sm"

                                                        />
                                                    ))
                                                ) : (
                                                    <img
                                                        src={assets.download_img}
                                                        alt="Upload Preview"
                                                        className=" shadow-sm"

                                                    />
                                                )}
                                            </div>
                                        </label>
                                        <input
                                            onChange={(e) => setImage([...e.target.files])}
                                            type="file"
                                            id="images"
                                            className="d-none"
                                            multiple
                                            required
                                        />

                                    </div>
                                    <div className='form-row'>
                                        <div className="form-group col-md-6">
                                            <label htmlFor="nameProduct" className="mb-2">Tên Sản Phẩm (*)</label>
                                            <input
                                                onChange={onChangeHandler}
                                                value={data.nameProduct}
                                                type="text"
                                                name="nameProduct"
                                                id="nameProduct"
                                                className="form-control rounded-pill"
                                                placeholder="Nhập tên sản phẩm"
                                                required
                                            />
                                        </div>
                                        <div className="form-group col-md-6">
                                            <label htmlFor="quantity" className="mb-2">Số lượng (*)</label>
                                            <input
                                                onChange={onChangeHandler}
                                                value={data.quantity}
                                                type="number"
                                                name="quantity"
                                                id="quantity"
                                                className="form-control rounded-pill"
                                                placeholder="20"
                                                required
                                            />
                                        </div>
                                    </div>
                                    <div className="form-row">
                                        <div className="form-group col-md-6">
                                            <label htmlFor="category" className="mb-2">Danh mục (*)</label>
                                            <select
                                                onChange={onChangeHandler}
                                                value={data.category}
                                                name="category"
                                                id="category"
                                                className="form-control rounded-pill"
                                                required
                                            >

                                                <option value="" disabled selected>lựa chọn phân loại</option>

                                                {categoryList.map((cat) => (
                                                    <option key={cat._id} value={cat.category}>
                                                        {cat.category}
                                                    </option>
                                                ))}
                                            </select>
                                        </div>

                                        <div className="form-group col-md-6">
                                            <label htmlFor="price" className="mb-2">Giá (VNđ) (*)</label>
                                            <input
                                                onChange={onChangeHandler}
                                                value={data.price}
                                                type="number"
                                                name="price"
                                                id="price"
                                                className="form-control rounded-pill"
                                                placeholder="20"
                                                required
                                            />
                                        </div>
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="recap" className="mb-2">Mô tả sản phẩm (*)</label>
                                        <TiptapEditor
                                            value={data.recap}
                                            onChange={(value) => onEditorChangeHandler('recap', value)}
                                        />
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="description" className="mb-2">Mô tả(*)</label>
                                        <TiptapEditor
                                            value={data.description}
                                            onChange={(value) => onEditorChangeHandler('description', value)}
                                        />
                                    </div>


                                </Tab>


                            </Tabs>

                        </div>
                        <div className='tab-right col-2'>
                            <div className='tab-right-content'>

                                <div className="text-center mt-4">
                                    <button type="submit" className="btn btn-primary rounded-pill px-4 py-2" disabled={loading}>
                                        {loading ? "Đang tải..." : "Thêm Sản Phẩm"}
                                    </button>
                                </div>
                                <img src={assets.add_product} alt="add products" />
                            </div>
                        </div>

                    </div>
                </form>
            </div>
        </div>
    );
};

export default AddProduct;