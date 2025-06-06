import React, { useState, useContext } from "react";
import { NavLink } from "react-router-dom";
import "./Styles/Styles.css";
import { assets } from "../assets/assets";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faSignOutAlt, faChevronDown, faPlusCircle, faListUl, faUserTie, faTruck,
  faUser, faBoxOpen, faHeadset, faChartBar, faInbox, faBarcode, faChartColumn, faDisplay, faTicket, faBox, faTags, faImage, faChartPie, faChartLine
} from "@fortawesome/free-solid-svg-icons";

const Sidebar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isOpenAccount, setIsOpenAccount] = useState(false);
  const [isOpenOrder, setIsOpenOrder] = useState(false);
  const [isOpenContact, setIsOpenContact] = useState(false);
  // State để kiểm soát menu nào đang mở
  const [openMenus, setOpenMenus] = useState({
    sanPham: false,
    category: false,
    advertise: false,
    nhapHang: false,
    chienDich: false,
    nhaCungcap: false,
    nhanVien: false,
    voucher: false,
    statistic: false
  });

  // Hàm toggle menu
  const toggleMenu = (menu) => {
    setOpenMenus((prev) => ({
      ...prev,
      [menu]: !prev[menu], // Đảo trạng thái của menu được click
    }));
  };

  return (
    <div className="section-sidebar">
      <div className="sidebar">
        <div className="logo-sidebar">
          <img className="logo" src={assets.logo_footer} alt="Logo" />
        </div>
        <div className="sidebar-dropdown">
          {/* Show all menus for non-Shipper roles */}

          <div className="sidebar-options">
            <NavLink to="/dashboard" className="sidebar-option">
              <FontAwesomeIcon icon={faChartPie} />
              <p>Tổng quan</p>
            </NavLink>
          </div>

          <div className="sidebar-dropdown">
            <div
              className="sidebar-option sidebar-main"
              onClick={() => toggleMenu("sanPham")}
            >
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faBox} />
                <p>Sản phẩm</p>
              </div>
              <FontAwesomeIcon
                icon={faChevronDown}
                className={`sidebar-icon ${openMenus.sanPham ? "rotate" : ""}`}
              />
            </div>
            {openMenus.sanPham && (
              <ul className="sidebar-submenu">
                <li><NavLink to="/add" className="submenu-item">Thêm sản phẩm</NavLink></li>
                <li><NavLink to="/product" className="submenu-item">Danh sách sản phẩm</NavLink></li>
                <li><NavLink to="/product/trash" className="submenu-item">Thùng rác</NavLink></li>
              </ul>
            )}
          </div>

          <div className="sidebar-dropdown">
            <div
              className="sidebar-option sidebar-main"
              onClick={() => toggleMenu("category")}
            >
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faTags} />
                <NavLink to="/category" className="submenu-item" style={{ color: "white", fontWeight: 400 }}>Danh mục</NavLink>
              </div>
            </div>
          </div>

          <div className="sidebar-dropdown">
            <div
              className="sidebar-option sidebar-main"
              onClick={() => toggleMenu("advertise")}
            >
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faImage} />
                <NavLink to="/advertise" className="submenu-item" style={{ color: "white", fontWeight: 400 }}>Media</NavLink>
              </div>
            </div>
          </div>


          {/* Hóa đơn - Always shown for all roles */}
          <div className="sidebar-dropdown">
            <div className="sidebar-option sidebar-main" onClick={() => setIsOpenOrder(!isOpenOrder)}>
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faBoxOpen} />
                <p>Hóa đơn</p>
              </div>
              <FontAwesomeIcon icon={faChevronDown} className={`sidebar-icon ${isOpenOrder ? "rotate" : ""}`} />
            </div>
            {isOpenOrder && (
              <ul className="sidebar-submenu">
                <li><NavLink to="/orders" className="submenu-item">Danh sách Hóa đơn</NavLink></li>
                <li><NavLink to="/orders/trash" className="submenu-item">Thùng rác</NavLink></li>
              </ul>
            )}
          </div>

          {/* Show remaining menus only for non-Shipper roles */}
          <div className="sidebar-dropdown">
            <div
              className="sidebar-option sidebar-main"
              onClick={() => toggleMenu("chienDich")}
            >
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faBarcode} />
                <p>Chiến dịch</p>
              </div>
              <FontAwesomeIcon
                icon={faChevronDown}
                className={`sidebar-icon ${openMenus.chienDich ? "rotate" : ""}`}
              />
            </div>
            {openMenus.chienDich && (
              <ul className="sidebar-submenu">
                <li>
                  <NavLink to="/add-campaign" className="submenu-item">
                    Thêm chiến dịch
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/list-campaign" className="submenu-item">
                    Danh sách chiến dịch
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/trash-campaign" className="submenu-item">
                    Thùng rác
                  </NavLink>
                </li>
              </ul>
            )}
          </div>

          <div className="sidebar-dropdown">
            <div
              className="sidebar-option sidebar-main"
              onClick={() => toggleMenu("voucher")}
            >
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faTicket} />
                <p>Phiếu giảm giá</p>
              </div>
              <FontAwesomeIcon
                icon={faChevronDown}
                className={`sidebar-icon ${openMenus.voucher ? "rotate" : ""}`}
              />
            </div>
            {openMenus.voucher && (
              <ul className="sidebar-submenu">
                <li>
                  <NavLink to="/add-voucher" className="submenu-item">
                    Thêm voucher
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/voucher" className="submenu-item">
                    Danh sách voucher
                  </NavLink>
                </li>
                {/* <li>
                  <NavLink to="/trash-campaign" className="submenu-item">
                    Thùng rác
                  </NavLink>
                </li> */}
              </ul>
            )}
          </div>
          <div className="sidebar-dropdown">
            <div
              className="sidebar-option sidebar-main"
              onClick={() => toggleMenu("advertise")}
            >
              <div className="dad-menu sidebar-title">
                <FontAwesomeIcon icon={faImage} />
                <NavLink to="/mess" className="submenu-item" style={{ color: "white", fontWeight: 400 }}>CSKH</NavLink>
              </div>
            </div>
          </div>
        </div>

        <div className="log-out-btn">
          <NavLink to="http://localhost:5173/" className="sidebar-option-logout">
            <p>Đăng xuất</p>
            <FontAwesomeIcon icon={faSignOutAlt} />
          </NavLink>
        </div>
      </div>
    </div>
  );
};

export default Sidebar;
