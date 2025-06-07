import React, { useContext, useState, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/styles.css";
import { toast } from "react-toastify";
import { Table, Input, Select } from "antd";
import { debounce } from "lodash";
import { ProductContext } from "../../context/ProductContextProvider";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash, faBook } from "@fortawesome/free-solid-svg-icons";
import { stats } from "../../data/Enviroment";
import { formatCurrency } from "../../lib/utils";

const ListProduct = () => {
    const { productList, removeProduct } = useContext(ProductContext);
    const [searchTerm, setSearchTerm] = useState("");
    const [selectedType, setSelectedType] = useState("");
    const navigate = useNavigate();

    const { Option } = Select;

    const removeAccents = (str) => {
        return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    };

    const handleSearch = useCallback(
        debounce((value) => {
            const normalizedSearchTerm = removeAccents(value.toLowerCase());
            const filteredList = productList.filter((product) =>
                removeAccents(product.title.toLowerCase()).includes(normalizedSearchTerm)
            );
            return filteredList;
        }, 300),
        [productList]
    );

    const filtered = productList
        .filter((product) => {
            return (
                product.title.toLowerCase().includes(searchTerm.toLowerCase()) &&
                (selectedType ? product.category === selectedType : true)
            );
        })
        .sort((a, b) => a.title.localeCompare(b.title)); // Sắp xếp mặc định theo title

    const handleProductClick = (productId) => {
        navigate(`/product/${productId}`);
    };

    const columns = [
        {
            title: "Hình ảnh",
            key: "image",
            render: (text, record) => (
                <img
                    src={`http://localhost:9004/images/${record.images[0]}`}
                    alt=""
                    style={{ width: "50px", height: "50px" }}
                />
            ),
        },
        {
            title: "Mã sản phẩm",
            dataIndex: "_id",
            key: "_id",
            render: (text) => (text.length > 15 ? text.slice(0, 15) + "..." : text),
            sorter: (a, b) => a._id.localeCompare(b._id),
        },
        {
            title: "Tên sản phẩm",
            dataIndex: "title",
            key: "title",
            render: (text) => (text.length > 15 ? text.slice(0, 15) + "..." : text),
            sorter: (a, b) => a.title.localeCompare(b.title),
        },
        {
            title: "Danh mục",
            dataIndex: "category",
            key: "category",
            sorter: (a, b) => a.category.localeCompare(b.category),
        },
        {
            title: "Trạng thái",
            key: "quantity",
            render: (text, record) => (
                <p style={{ color: record.quantity <= 0 ? "red" : "green" }}>
                    {record.quantity <= 0 ? "Hết hàng" : "Còn hàng"}
                </p>
            ),
        },
        {
            title: "Giá",
            dataIndex: "price",
            key: "price",
            render: (price) => formatCurrency(price),
            sorter: (a, b) => a.price - b.price,
        },
        // {
        //     title: "Số lượng",
        //     dataIndex: "quantity",
        //     key: "quantityCount",
        //     sorter: (a, b) => a.quantity - b.quantity,
        // },
        // {
        //     title: "Tồn kho",
        //     dataIndex: "quantity",
        //     key: "inventoryCount",
        //     sorter: (a, b) => a.quantity - b.quantity,
        // },
        {
            title: "Hành động",
            key: "action",
            align: "center",
            render: (text, record) => (
                <div className="button-product">
                    <button onClick={() => handleProductClick(record._id)} className="btn-info">
                        <FontAwesomeIcon icon={faBook} />
                    </button>
                    <button
                        onClick={() => removeProduct(record._id)}
                        className="cursor1"
                    >
                        <FontAwesomeIcon icon={faTrash} />
                    </button>
                </div>
            ),
        },
    ];

    return (
        <div className="listproduct add flex-col">
            <div className="dashboard-product">
                <div className="das-body">
                    {stats.map((stat, index) => (
                        <div key={index} className="box">
                            <FontAwesomeIcon icon={stat.icon} className="stat-icon" />
                            <div className="stat-box">
                                <p className="label">{stat.label}</p>
                                <p className="value">{stat.animatedValue}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            <div className="top-list-tiltle">
                <div className="col-lg-4 tittle-right">
                    <Input
                        placeholder="Tìm kiếm sản phẩm..."
                        style={{ width: 200, marginBottom: 16 }}
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <div className="col-lg-8 list-left">
                    <div className="search-right">
                        <Select
                            placeholder="Danh mục sản phẩm"
                            style={{
                                width: 200,
                                marginRight: 8,
                                borderRadius: "7px",
                                border: "1px solid rgb(134, 134, 134, 0.6)",
                            }}
                            value={selectedType}
                            onChange={(value) => setSelectedType(value)}
                            allowClear
                        >
                            <Option value="Màn hình LED">Màn hình LED</Option>
                            <Option value="MH tương tác">MH tương tác</Option>
                            <Option value="MH quảng cáo LCD">MH quảng cáo LCD</Option>
                            <Option value="Quảng cáo 3D (OOH)">Quảng cáo 3D (OOH)</Option>
                            <Option value="KTV 5D">KTV 5D</Option>
                        </Select>
                    </div>
                </div>
            </div>

            <Table
                columns={columns}
                dataSource={filtered.map((product, index) => ({ ...product, key: product._id || index }))}
                rowKey="key"
                pagination={false} // Không cần phân trang
            />
        </div>
    );
};

export default ListProduct;