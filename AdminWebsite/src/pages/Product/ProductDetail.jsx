import React, { useEffect, useContext, useState, useCallback } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { formatHourDayTime } from "../../lib/utils";
import { ProductContext } from "../../context/ProductContextProvider";
import "../styles/styles.css";

const ProductDetails = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const { fetchProductId, productId, updateProductId } = useContext(ProductContext);
    const [updatedProduct, setUpdatedProduct] = useState({});
    const [imageFiles, setImageFiles] = useState([]); // Lưu file hình ảnh để gửi lên server
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (id) {
            setLoading(true);
            fetchProductId(id).finally(() => setLoading(false));
        }
    }, [id, fetchProductId]);

    useEffect(() => {
        if (productId) {
            setUpdatedProduct(productId);
        }
    }, [productId]);

    const handleChange = useCallback((e) => {
        const { name, value } = e.target;
        setUpdatedProduct((prev) => ({ ...prev, [name]: value }));
    }, []);

    const handleImageChange = useCallback(
        (index, event) => {
            if (event.target.files[0]) {
                const file = event.target.files[0];
                const newImageFiles = [...imageFiles];
                newImageFiles[index] = file; // Lưu file để gửi lên server
                setImageFiles(newImageFiles);

                // Cập nhật preview hình ảnh
                const newImages = [...(updatedProduct.images || [])];
                newImages[index] = URL.createObjectURL(file); // Tạo URL tạm thời cho preview
                setUpdatedProduct((prev) => ({ ...prev, images: newImages }));
            }
        },
        [imageFiles, updatedProduct.images]
    );

    const handleSave = useCallback(async () => {
        try {
            setLoading(true);
            const formData = new FormData();

            // Thêm các trường dữ liệu vào FormData
            Object.keys(updatedProduct).forEach((key) => {
                if (key !== "images" && updatedProduct[key] !== undefined) {
                    formData.append(key, updatedProduct[key]);
                }
            });

            // Thêm hình ảnh vào FormData
            imageFiles.forEach((file, index) => {
                if (file) {
                    formData.append(`images[${index}]`, file);
                }
            });

            await updateProductId(id, formData);
            toast.success("Cập nhật sản phẩm thành công!");
        } catch (error) {
            toast.error("Lỗi khi cập nhật sản phẩm: " + error.message);
        } finally {
            setLoading(false);
        }
    }, [id, updatedProduct, imageFiles, updateProductId]);

    if (loading) return <p>Đang tải dữ liệu...</p>;
    if (!productId) return <p>Không tìm thấy sản phẩm</p>;

    return (
        <div className="product-details-container">
            <div className="product-details-grid">
                <div className="product-images-section">
                    {[...Array(3)].map((_, index) => (
                        <div key={index} className="image-wrapper">
                            <label className="image-upload-label">
                                <img
                                    src={
                                        updatedProduct.images?.[index]
                                            ? updatedProduct.images[index].startsWith("blob:")
                                                ? updatedProduct.images[index] // Preview từ file upload
                                                : `http://localhost:9004/images/${updatedProduct.images[index]}`
                                            : "http://localhost:9004/images/default.jpg"
                                    }
                                    alt={`Sản phẩm ${index + 1}`}
                                    className="product-image"
                                />
                                <input
                                    type="file"
                                    accept="image/*"
                                    onChange={(e) => handleImageChange(index, e)}
                                    className="upload-input"
                                />
                            </label>
                        </div>
                    ))}
                </div>

                <div className="product-info-section">
                    <h2>{updatedProduct.title || "Sản phẩm"}</h2>
                    <div className="top-info">
                        <div className="form-field col-12">
                            <label>Tên Sản Phẩm:</label>
                            <input
                                type="text"
                                name="title"
                                value={updatedProduct.title || ""}
                                onChange={handleChange}
                            />
                        </div>

                        <div className="form-row">
                            {[
                                ["price", "Giá"],
                                ["quantity", "Số Lượng"],
                            ].map(([key, label]) => (
                                <div key={key} className="form-field col-6">
                                    <label>{label}:</label>
                                    <input
                                        type="text"
                                        name={key}
                                        value={updatedProduct[key] || ""}
                                        onChange={handleChange}
                                    />
                                </div>
                            ))}
                        </div>
                    </div>

                    <div style={{ padding: "0 10px" }}>
                        <label>Mô tả ngắn:</label>
                        <textarea
                            name="recap"
                            value={updatedProduct.recap || ""}
                            onChange={handleChange}
                        />
                    </div>
                    <div style={{ padding: "0 10px" }}>
                        <label>Mô tả chi tiết:</label>
                        <textarea
                            name="description"
                            value={updatedProduct.description || ""}
                            onChange={handleChange}
                        />
                    </div>
                    <div className="product-specs">
                        <h2>Thông Số Kỹ Thuật</h2>
                        <div className="specs-list">
                            {[
                                "mainBoard",
                                "chip",
                                "cpu",
                                "gpu",
                                "ram",
                                "memory",
                                "version",
                                "ports",
                                "displaySize",
                                "pixelDensity",
                                "display",
                                "refreshRate",
                            ].map((field) => (
                                <div className="specs-field" key={field}>
                                    <label>{field}:</label>
                                    <input
                                        type="text"
                                        name={field}
                                        value={updatedProduct[field] || ""}
                                        onChange={handleChange}
                                    />
                                </div>
                            ))}
                        </div>
                    </div>
                    {productId.creator && productId.creator.length > 0 && (
                        <div className="history-section">
                            <h2>Lịch sử liên hệ</h2>
                            <table className="history-table">
                                <thead>
                                    <tr>
                                        <th>Nhân viên</th>
                                        <th>Mô tả</th>
                                        <th>Thời gian</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {productId.creator.map((entry) => (
                                        <tr key={entry._id}>
                                            <td>{entry.createdName}</td>
                                            <td>{entry.description}</td>
                                            <td>{formatHourDayTime(entry.createdAt)}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}

                    <div className="save-section">
                        <button
                            className="save-btn"
                            onClick={handleSave}
                            disabled={loading}
                        >
                            {loading ? "Đang lưu..." : "Lưu Thay Đổi"}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ProductDetails;