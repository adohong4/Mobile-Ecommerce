
import React, { useState, useContext } from 'react';
import '../styles/styles.css';
import { assets } from '../../assets/assets';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Tab, Tabs } from 'react-bootstrap';
import { ProductContext } from '../../context/ProductContextProvider';
import TiptapEditor from '../../components/TiptapEditor';
const AddProduct = () => {
    const { url } = useContext(ProductContext);
    const [images, setImage] = useState([]);
    const [data, setData] = useState({
        title: "",
        nameProduct: "",
        price: "",
        recap: "",
        description: "",
        category: "Màn hình LED",
        quantity: "",
        mainBoard: "",
        chip: "",
        cpu: "",
        gpu: "",
        ram: "",
        memory: "",
        version: "",
        ports: "",
        displaySize: "",
        pixelDensity: "",
        display: "",
        refreshRate: "",
    });
    const [loading, setLoading] = useState(false);

    const onChangeHandler = (event) => {
        const name = event.target.name;
        const value = event.target.value;
        setData(data => ({ ...data, [name]: value }))
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
        formData.append("mainBoard", data.mainBoard);
        formData.append("chip", data.chip);
        formData.append("cpu", data.cpu);
        formData.append("gpu", data.gpu);
        formData.append("ram", data.ram);
        formData.append("memory", data.memory);
        formData.append("version", data.version);
        formData.append("ports", data.ports);
        formData.append("displaySize", data.displaySize);
        formData.append("pixelDensity", data.pixelDensity);
        formData.append("display", data.display);
        formData.append("refreshRate", data.refreshRate);

        try {
            console.log("data: ", formData)
            const response = await axios.post(`${url}/v1/api/product/add`, formData);
            if (response.data.status) {
                setData({
                    title: "",
                    nameProduct: "",
                    price: "",
                    recap: "",
                    description: "",
                    category: "Màn hình LED",
                    quantity: "",
                    mainBoard: "",
                    chip: "",
                    cpu: "",
                    gpu: "",
                    ram: "",
                    memory: "",
                    version: "",
                    ports: "",
                    displaySize: "",
                    pixelDensity: "",
                    display: "",
                    refreshRate: "",
                });
                setImage(false);
                toast.success("Thêm sản phẩm thành công");
            } else {
                toast.error(response.data.message);
            }
        } catch (error) {
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
                                            >
                                                <option value="Màn hình LED">Màn hình LED</option>
                                                <option value="MH tương tác">MH tương tác</option>
                                                <option value="MH quảng cáo LCD">MH quảng cáo LCD</option>
                                                <option value="Quảng cáo 3D (OOH)">Quảng cáo 3D (OOH)</option>
                                                <option value="KTV 5D">KTV 5D</option>
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
                                            onChange={(value) => onChangeHandler('recap', value)}
                                        />
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="description" className="mb-2">Mô tả(*)</label>
                                        <TiptapEditor
                                            value={data.description}
                                            onChange={(value) => onChangeHandler('recap', value)}
                                        />
                                    </div>


                                </Tab>


                                {/* Tab 2 */}

                            </Tabs>

                        </div>
                        <div className='tab-right col-2'>
                            <div className='tab-right-content'>
                               
                                <div className="text-center mt-4">
                                    <button type="submit" className="btn btn-primary rounded-pill px-4 py-2" disabled={loading}>
                                        {loading ? "Đang tải..." : "Thêm Sản Phẩm"}
                                    </button>
                                </div>
                                <div className="text-center mt-4">
                                    <button
                                        type="submit"
                                        className="btn btn-primary rounded-pill px-4 py-2"
                                        disabled={loading}
                                        style={{ background: "#1AA7DD" }}  
                                    >
                                        {loading ? "Đang tải..." : "Làm mới"}
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
