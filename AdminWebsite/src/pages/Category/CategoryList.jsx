import React, { useEffect, useContext, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Table, Button, Input, Popconfirm, Modal, Descriptions, Space, Tooltip } from 'antd';
import { BookFilled, EditFilled, DeleteOutlined, PlusOutlined } from '@ant-design/icons';
import { CategoryContext } from '../../context/CategoryContextProvider';
import '../styles/styles.css';

const CategoryList = () => {
    const { categoryList, fetchCategoryList, softDeleteCategory, deleteCategory } = useContext(CategoryContext);
    const [searchTerm, setSearchTerm] = useState('');
    const [viewingCategory, setViewingCategory] = useState(null);
    const [isViewModalOpen, setIsViewModalOpen] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        fetchCategoryList();
    }, [fetchCategoryList]);

    const handleSoftDelete = async (categoryId) => {
        try {
            await softDeleteCategory(categoryId);
        } catch (error) {
            toast.error('Lỗi khi xóa mềm danh mục');
        }
    };

    const handleDelete = async (categoryId) => {
        try {
            await deleteCategory(categoryId);
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
            <div style={{ display: 'flex', marginBottom: 16 }}>
                <Input
                    placeholder="Tìm kiếm danh mục"
                    style={{ width: 200, marginRight: 8, backgroundColor: '#fff' }}
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />
                <Button type="primary" icon={<PlusOutlined />} onClick={handleAddCategory}>
                    Thêm danh mục mới
                </Button>
            </div>
            <Table
                columns={columns}
                dataSource={filteredCategories.map((category) => ({ ...category, key: category._id }))}
                rowKey="key"
                pagination={{ pageSize: 7 }}
            />
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