<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${combo != null ? 'Cập nhật Combo' : 'Thêm Combo mới'} | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_style.css">

    <style>
        .product-scroll-list { max-height: 350px; overflow-y: auto; border: 1px solid #e2e8f0; border-radius: 6px; padding: 5px; }
        .product-item-row { display: flex; align-items: center; padding: 8px; border-bottom: 1px solid #f1f5f9; cursor: pointer; }
        .product-item-row:hover { background-color: #f8fafc; }
        .p-thumb { width: 40px; height: 40px; object-fit: cover; margin-right: 10px; border-radius: 4px; border: 1px solid #ddd; }
        .form-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
    </style>
</head>
<body>

<jsp:include page="common/sidebar.jsp"></jsp:include>

<div class="admin-layout">
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/combo-list" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </header>

        <div class="admin-content">
            <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

            <form action="${pageContext.request.contextPath}/admin/combos" method="post" class="admin-form-layout" id="comboForm">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="id" value="${combo != null ? combo.id : 0}">

                <div class="col-main">
                    <div class="admin-card">
                        <h3>Thông tin Combo</h3>
                        <div class="form-group">
                            <label>Tên Combo (*)</label>
                            <input type="text" class="form-control" name="name" value="${combo != null ? combo.name : ''}" required>
                        </div>

                        <div class="form-row-2">
                            <div class="form-group">
                                <label>Tag (Nhãn)</label>
                                <input type="text" class="form-control" name="tag" value="${combo != null ? combo.tag : ''}" placeholder="VD: HOT, SALE...">
                            </div>
                            <div class="form-group">
                                <label>Quà tặng kèm (Text)</label>
                                <input type="text" class="form-control" name="gift" value="${combo != null ? combo.gift : ''}" placeholder="VD: Tặng chảo...">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mô tả / Nội dung</label>
                            <textarea class="form-control" name="content" rows="4">${combo != null ? combo.content : ''}</textarea>
                        </div>
                    </div>

                    <div class="admin-card" style="margin-top: 20px;">
                        <h3>Chọn sản phẩm trong Combo</h3>
                        <input type="text" id="searchProduct" class="form-control" placeholder="Tìm kiếm sản phẩm..." onkeyup="filterProducts()" style="margin-bottom: 10px;">

                        <div class="product-scroll-list" id="productList">
                            <c:forEach items="${listProducts}" var="p">
                                <label class="product-item-row">
                                    <input type="checkbox" name="product_ids" value="${p.product_id}" style="margin-right: 10px;"
                                           <c:if test="${selectedProductIds != null && selectedProductIds.contains(p.product_id)}">checked</c:if>
                                    >
                                    <img src="${p.image}" class="p-thumb" onerror="this.src='https://via.placeholder.com/40'">
                                    <div>
                                        <div style="font-weight: 600; font-size: 0.9rem;">${p.product_name}</div>
                                        <div style="font-size: 0.8rem; color: #666;">
                                            Giá: <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ | Mã: ${p.product_id}
                                        </div>
                                    </div>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="col-sidebar">
                    <div class="admin-card">
                        <h3>Hành động</h3>
                        <div class="form-group">
                            <label style="display: flex; align-items: center; cursor: pointer;">
                                <input type="checkbox" name="is_active" value="1" style="width: 20px; height: 20px; margin-right: 10px;"
                                ${combo != null && combo.is_active == 1 ? 'checked' : ''}
                                ${combo == null ? 'checked' : ''}> <span>Kích hoạt (Hiển thị)</span>
                            </label>
                        </div>
                        <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-save"></i> Lưu dữ liệu
                        </button>
                    </div>

                    <div class="admin-card">
                        <h3>Thiết lập giá & Kho</h3>
                        <div class="form-group">
                            <label>Giá gốc (đ) (*)</label>
                            <input type="number" class="form-control" name="baseprice" value="${combo != null ? combo.baseprice : 0}" required min="0">
                        </div>
                        <div class="form-group">
                            <label>Giá khuyến mãi (đ) (*)</label>
                            <input type="number" class="form-control" name="discountprice" value="${combo != null ? combo.discountprice : 0}" required min="0">
                        </div>
                        <div class="form-group">
                            <label>Số lượng tồn kho (*)</label>
                            <input type="number" class="form-control" name="stock_quantity" value="${combo != null ? combo.stock_quantity : 0}" required min="0">
                        </div>
                    </div>

                    <div class="admin-card">
                        <h3>Ảnh đại diện Combo</h3>
                        <input type="text" class="form-control" name="image" id="imgInput" value="${combo != null ? combo.image : ''}"
                               onchange="document.getElementById('preview').src = this.value" placeholder="URL ảnh...">
                        <div style="margin-top: 10px; text-align: center; border: 1px dashed #ccc; padding: 10px;">
                            <img id="preview" src="${combo != null ? combo.image : ''}" style="max-width: 100%; max-height: 200px;" onerror="this.src='https://via.placeholder.com/150?text=No+Image'">
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // Hàm lọc sản phẩm trong danh sách checkbox
    function filterProducts() {
        var input, filter, container, labels, txtValue;
        input = document.getElementById("searchProduct");
        filter = input.value.toUpperCase();
        container = document.getElementById("productList");
        labels = container.getElementsByTagName("label");

        for (var i = 0; i < labels.length; i++) {
            txtValue = labels[i].innerText || labels[i].textContent;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                labels[i].style.display = "flex";
            } else {
                labels[i].style.display = "none";
            }
        }
    }
</script>

</body>
</html>