import React, { useEffect, useContext, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Table, Button, Input, Popconfirm, Modal, Descriptions, Space, Tooltip } from 'antd';
import { BookFilled, EditFilled, DeleteOutlined, PlusOutlined } from '@ant-design/icons';
import { CategoryContext } from '../../context/CategoryContextProvider';
import '../styles/styles.css';

const CategoryList = () => {
    const { categoryList, fetchCategoryList, softDeleteCategory, deleteCategory, addCategory } = useContext(CategoryContext);
    const [searchTerm, setSearchTerm] = useState('');
    const [viewingCategory, setViewingCategory] = useState(null);
    const [isViewModalOpen, setIsViewModalOpen] = useState(false);
    const [newCategory, setNewCategory] = useState({
        category: '',
        categoryIds: '',
        file: null,
        preview: '',
    });


    const navigate = useNavigate();

    useEffect(() => {
        fetchCategoryList();
    }, [fetchCategoryList]);
    // Xử lý chọn ảnh từ thiết bị
    const handleImageChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            setNewCategory({
                ...newCategory,
                file,
                preview: URL.createObjectURL(file),
            });
        }
    };

    const handleSoftDelete = async (categoryId) => {
        try {
            await softDeleteCategory(categoryId);
            fetchCategoryList();
        } catch (error) {
            toast.error('Lỗi khi xóa mềm danh mục');
        }
    };

    const handleDelete = async (categoryId) => {
        try {
            await deleteCategory(categoryId);
            fetchCategoryList();
        } catch (error) {
            toast.error('Lỗi khi xóa danh mục');
        }
    };

    const handleAddCategory = () => {
        navigate('/add-category');
    };

    const showViewModal = (category) => {
        setViewingCategory(category);
        setIsViewModalOpen(true);
    };

    const handleQuickAddCategory = async () => {
        const { category, categoryIds, file } = newCategory;

        if (!category || !categoryIds) {
            toast.warning('Tên và mã danh mục là bắt buộc');
            return;
        }

        const formData = new FormData();
        formData.append('category', category);
        formData.append('categoryIds', categoryIds);
        formData.append('categoryPic', file); // backend cần hỗ trợ upload file qua FormData
        formData.append('active', true);

        try {
            await addCategory(formData); // server cần hỗ trợ content-type multipart/form-data
            toast.success('Thêm danh mục thành công');
            setNewCategory({ category: '', categoryIds: '', file: null, preview: '' });
            fetchCategoryList();
        } catch (error) {
            toast.error('Thêm danh mục thất bại');
        }
    };


    const filteredCategories = categoryList.filter((category) =>
        category.category?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const columns = [
        {
            title: 'Tên danh mục',
            dataIndex: 'category',
            key: 'category',
            sorter: (a, b) => a.category.localeCompare(b.category),
        },
        {
            title: 'Mã danh mục',
            dataIndex: 'categoryIds',
            key: 'categoryIds',
            sorter: (a, b) => a.categoryIds.localeCompare(b.categoryIds),
        },
        {
            title: 'Hình ảnh',
            dataIndex: 'categoryPic',
            key: 'categoryPic',
            render: (categoryPic) => (
                <img
                    src={categoryPic}
                    alt="Category"
                    style={{ width: 50, height: 50, objectFit: 'cover' }}
                />
            ),
        },
        {
            title: 'Trạng thái',
            dataIndex: 'active',
            key: 'active',
            render: (active) => (
                <span
                    style={{
                        color: active ? '#006600' : '#FF0000',
                        padding: '2px 8px',
                        borderRadius: '10px',
                        display: 'inline-block',
                    }}
                >
                    {active ? 'Hoạt động' : 'Đã xóa mềm'}
                </span>
            ),
            sorter: (a, b) => Number(a.active) - Number(b.active),
        },
        {
            title: 'Ngày tạo',
            dataIndex: 'createdAt',
            key: 'createdAt',
            render: (createdAt) => new Date(createdAt).toLocaleString(),
            sorter: (a, b) => new Date(a.createdAt) - new Date(b.createdAt),
        },
        {
            title: 'Hành động',
            key: 'action',
            align: 'center',
            render: (_, record) => (
                <Space size="middle">
                    <Tooltip title="Xem chi tiết">
                        <Button
                            shape="circle"
                            icon={<BookFilled style={{ color: 'orange' }} />}
                            onClick={() => showViewModal(record)}
                        />
                    </Tooltip>
                    <Tooltip title="Cập nhật thông tin">
                        <Button
                            shape="circle"
                            icon={<EditFilled />}
                            onClick={() => navigate(`/edit-category/${record._id}`)}
                        />
                    </Tooltip>
                    {record.active ? (
                        <Popconfirm
                            title="Xóa mềm danh mục này?"
                            onConfirm={() => handleSoftDelete(record._id)}
                            okText="Xóa"
                            cancelText="Hủy"
                        >
                            <Tooltip title="Xóa mềm">
                                <Button shape="circle" icon={<DeleteOutlined />} danger />
                            </Tooltip>
                        </Popconfirm>
                    ) : (
                        <Popconfirm
                            title="Xóa vĩnh viễn danh mục này?"
                            onConfirm={() => handleDelete(record._id)}
                            okText="Xóa"
                            cancelText="Hủy"
                        >
                            <Tooltip title="Xóa vĩnh viễn">
                                <Button shape="circle" icon={<DeleteOutlined />} danger />
                            </Tooltip>
                        </Popconfirm>
                    )}
                </Space>
            ),
        },
    ];

    return (
        <div style={{ padding: 20 }}>
            <div style={{ background: '#f9f9f9', padding: 24, borderRadius: 12, marginBottom: 24 }}>
                <h2 style={{ marginBottom: 20 }}>Thêm danh mục sản phẩm</h2>

                <div className="add-category-container">
                    {/* Cột trái: Form nhập liệu */}
                    <div className="form-left col-4">


                        <Input
                            placeholder="Tìm kiếm danh mục"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            allowClear
                            style={{ marginTop: 12 }}
                        />
                        <Button
                            type="primary"
                            onClick={handleQuickAddCategory}
                            style={{ width: '100%', marginTop: 12 }}
                        >
                            Thêm nhanh
                        </Button>

                    </div>

                    {/* Cột phải: Ảnh + Tìm kiếm + Thêm */}
                    <div className="form-right col-8">
                        <Space direction="vertical" size="middle" style={{ width: '100%', display: 'flex' }}>
                            <div className='form-right-container'>
                                <div className='col-8'>
                                    <Input
                                        placeholder="Tên danh mục"
                                        value={newCategory.category}
                                        onChange={(e) => setNewCategory({ ...newCategory, category: e.target.value })}
                                    />
                                    <Input
                                        placeholder="Mã danh mục"
                                        value={newCategory.categoryIds}
                                        onChange={(e) => setNewCategory({ ...newCategory, categoryIds: e.target.value })}
                                    />
                                    <input
                                        type="file"
                                        accept="image/*"
                                        onChange={handleImageChange}
                                        className="custom-file-input"
                                    />
                                </div>
                                <div className='col-4'>
                                    {newCategory.preview && (
                                        <img
                                            src={newCategory.preview}
                                            alt="Preview"
                                            className="preview-image"
                                        />

                                    )}
                                </div>
                            </div>
                        </Space>
                    </div>
                </div>
            </div>



            {/* Bảng danh mục */}
            <Table
                columns={columns}
                dataSource={filteredCategories.map((category) => ({ ...category, key: category._id }))}
                rowKey="key"
                pagination={{ pageSize: 7 }}
            />

            {/* Modal xem chi tiết */}
            <Modal
                open={isViewModalOpen}
                onCancel={() => setIsViewModalOpen(false)}
                footer={null}
                title="Thông tin danh mục"
            >
                {viewingCategory && (
                    <Descriptions column={1} bordered>
                        <Descriptions.Item label="Tên danh mục">{viewingCategory.category}</Descriptions.Item>
                        <Descriptions.Item label="Mã danh mục">{viewingCategory.categoryIds}</Descriptions.Item>
                        <Descriptions.Item label="Hình ảnh">
                            <img
                                src={viewingCategory.categoryPic}
                                alt="Category"
                                style={{ width: 100, height: 100, objectFit: 'cover' }}
                            />
                        </Descriptions.Item>
                        <Descriptions.Item label="Trạng thái">
                            {viewingCategory.active ? 'Hoạt động' : 'Đã xóa mềm'}
                        </Descriptions.Item>
                        <Descriptions.Item label="Ngày tạo">
                            {new Date(viewingCategory.createdAt).toLocaleString()}
                        </Descriptions.Item>
                        <Descriptions.Item label="Ngày cập nhật">
                            {new Date(viewingCategory.updatedAt).toLocaleString()}
                        </Descriptions.Item>
                    </Descriptions>
                )}
            </Modal>
        </div>
    );
};

export default CategoryList;
