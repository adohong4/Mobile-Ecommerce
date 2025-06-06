import React, { useEffect, useContext, useState } from 'react';
import { toast } from 'react-toastify';
import ReactPaginate from 'react-paginate';
import { OrderContext } from '../../context/OrderContextProvider'; // Sử dụng OrderContext
import { formatHourDayTime, formatCurrency } from '../../lib/utils';

const OrderTable = () => {
    const { orderList, fetchOrderList } = useContext(OrderContext); // Lấy orderList và fetchOrderList từ context
    const [currentPage, setCurrentPage] = useState(0); // Bắt đầu từ trang 0
    const itemsPerPage = 6; // Số mục mỗi trang

    // Tính toán dữ liệu hiển thị cho trang hiện tại
    const startIndex = currentPage * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const currentItems = orderList.slice(startIndex, endIndex);
    const totalPages = Math.ceil(orderList.length / itemsPerPage); // Tổng số trang

    const handlePageClick = (event) => {
        setCurrentPage(event.selected); // Cập nhật trang hiện tại
    };

    useEffect(() => {
        fetchOrderList(); // Gọi fetchOrderList để lấy toàn bộ danh sách
    }, [fetchOrderList]);

    return (
        <div className="orderpayment-list-container">
            <ul className="transaction-list">
                {currentItems.map((item) => (
                    <li key={item._id} className="transaction-item">
                        <div className="transaction-details">
                            <p className="transaction-id">{item._id}</p>
                            <p className="transaction-date">{formatHourDayTime(item.createdAt)}</p>
                        </div>
                        <div className="transaction-amount">
                            <p>+ {formatCurrency(item.amount)}</p>
                            <p className="transaction-info">{item.paymentMethod}</p>
                        </div>
                    </li>
                ))}
            </ul>

            {orderList.length > 0 && (
                <ReactPaginate
                    breakLabel="..."
                    nextLabel=">"
                    onPageChange={handlePageClick}
                    previousLabel="<"
                    pageCount={totalPages} // Tổng số trang tính từ client
                    pageRangeDisplayed={1} // Hiển thị tối đa 4 số liên tiếp
                    marginPagesDisplayed={1} // Hiển thị 1 số đầu và cuối
                    renderOnZeroPageCount={null}
                    pageClassName="page-item"
                    pageLinkClassName="page-link"
                    previousClassName="page-item"
                    previousLinkClassName="page-link"
                    nextClassName="page-item"
                    nextLinkClassName="page-link"
                    breakClassName="page-item"
                    breakLinkClassName="page-link"
                    containerClassName="pagination"
                    activeClassName="active"
                />
            )}
        </div>
    );
};

export default OrderTable;