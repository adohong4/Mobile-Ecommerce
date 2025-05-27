import React, { useContext, useState, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/styles.css";
import { toast } from "react-toastify";
import { Table, Input, Select } from "antd";
import { debounce } from "lodash";
import { VoucherContext } from "../../context/VoucherContextProvider";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash, faBook } from "@fortawesome/free-solid-svg-icons";
import { stats } from "../../data/Enviroment";
import { formatCurrency, formatHourDayTime } from "../../lib/utils";

const VoucherList = () => {
    const { VoucherList, removeVoucher } = useContext(VoucherContext);
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
            const filteredList = VoucherList.filter((voucher) =>
                removeAccents(voucher.code.toLowerCase()).includes(normalizedSearchTerm)
            );
            return filteredList;
        }, 300),
        [VoucherList]
    );

    const filtered = VoucherList.filter((voucher) => {
        return (
            voucher.code.toLowerCase().includes(searchTerm.toLowerCase()) &&
            (selectedType ? voucher.discountType === selectedType : true)
        );
    }).sort((a, b) => a.code.localeCompare(b.code));

    const handleVoucherClick = (voucherId) => {
        navigate(`/voucher/${voucherId}`);
    };

    const columns = [
        {
            title: "Mã Voucher",
            dataIndex: "_id",
            key: "_id",
            render: (text) => (text.length > 15 ? text.slice(0, 15) + "..." : text),
            sorter: (a, b) => a._id.localeCompare(b._id),
        },
        {
            title: "Tên Voucher",
            dataIndex: "code",
            key: "code",
            render: (text) => (text.length > 15 ? text.slice(0, 15) + "..." : text),
            sorter: (a, b) => a.code.localeCompare(b.code),
        },
        {
            title: "Giảm giá",
            dataIndex: "discountValue",
            key: "discountValueWithUnit",
            render: (value, record) => {
                if (record.discountType === "PERCENTAGE") {
                    return `${value}%`;
                } else {
                    return formatCurrency(value);
                }
            },
            sorter: (a, b) => a.discountValue - b.discountValue,
        },
        {
            title: "Đơn tối thiểu",
            dataIndex: "minOrderValue",
            key: "minOrderValue",
            render: (value) => formatCurrency(value),
            sorter: (a, b) => a.minOrderValue - b.minOrderValue,
        },
        {
            title: "Ngày bắt đầu",
            dataIndex: "startDate",
            key: "startDate",
            render: (date) => formatHourDayTime(date),
            sorter: (a, b) => new Date(a.startDate) - new Date(b.startDate),
        },
        {
            title: "Ngày kết thúc",
            dataIndex: "endDate",
            key: "endDate",
            render: (date) => formatHourDayTime(date),
            sorter: (a, b) => new Date(a.endDate) - new Date(b.endDate),
        },
        {
            title: "Trạng thái",
            key: "active",
            render: (text, record) => (
                <p style={{ color: record.active ? "green" : "red" }}>
                    {record.active ? "Hoạt động" : "Không hoạt động"}
                </p>
            ),
            sorter: (a, b) => Number(a.active) - Number(b.active),
        },
        {
            title: "Hành động",
            key: "action",
            align: "center",
            render: (text, record) => (
                <div className="button-product">
                    <button
                        onClick={() => handleVoucherClick(record._id)}
                        className="btn-info"
                    >
                        <FontAwesomeIcon icon={faBook} />
                    </button>
                    <button
                        onClick={() => removeVoucher(record._id)}
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
            <div><h2>Phiếu giảm giá</h2></div>
            <div className="top-list-tiltle">
                <div className="col-lg-4 tittle-right">
                    <Input
                        placeholder="Tìm kiếm voucher..."
                        style={{ width: 200, marginBottom: 16 }}
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <div className="col-lg-8 list-left">
                    <div className="search-right">
                        <Select
                            placeholder="Loại voucher"
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
                            <Option value="PERCENTAGE">Phần trăm</Option>
                            <Option value="FIXED">Cố định</Option>
                        </Select>
                    </div>
                </div>
            </div>

            <Table
                columns={columns}
                dataSource={filtered.map((voucher, index) => ({
                    ...voucher,
                    key: voucher._id || index,
                }))}
                rowKey="key"
                pagination={false}
            />
        </div>
    );
};

export default VoucherList;