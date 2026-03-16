
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Combo Bếp Luxury - TTB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/ctCombo.css">
    <link rel="stylesheet" href="assets/css/Header.css">
    <link rel="stylesheet" href="assets/css/index.css">
    <link rel="stylesheet" href="assets/css/indexfont.css.css">

</head>
<jsp:include page="/common/header.jsp" />
<body class="bg-gray-50">

<main class="container mx-auto px-4 py-10 max-w-7xl" style="font-family: 'Inter', sans-serif;">
    <nav class="flex items-center space-x-2 text-gray-400 mb-8 text-sm tracking-wide">
        <a href="Home" class="hover:text-blue-600 transition">Trang chủ</a>
        <span>/</span>
        <a href="listcombo" class="hover:text-blue-600 transition">Combo</a>
        <span>/</span>
        <span class="text-gray-900 font-bold" style="font-family: 'Manrope', sans-serif;">${c.name}</span>
    </nav>

    <div class="grid grid-cols-1 lg:grid-cols-12 gap-16 bg-white p-4 md:p-12 rounded-[2.5rem] shadow-2xl border border-gray-50">

        <div class="lg:col-span-7 space-y-6 gallery-container">
            <div class="main-img-box relative group overflow-hidden rounded-3xl shadow-inner bg-gray-50 border border-gray-100">
                <img src="${c.products[0].image}" alt="Luxury"
                     class="main-image w-full h-[550px] object-contain transition duration-700 group-hover:scale-105 p-6">

                <div class="absolute top-6 left-6 bg-red-600 text-white px-5 py-2 rounded-full font-black shadow-lg text-lg"
                     style="font-family: 'Manrope', sans-serif;">
                    -${c.getPercent(c.baseprice,c.discountprice)}%
                </div>
            </div>

            <div class="flex flex-wrap gap-4">
                <c:forEach items="${c.products}" var="p" varStatus="loop">
                    <div class="thumb-item cursor-pointer p-1 border-2 ${loop.first ? 'border-blue-600 active shadow-md' : 'border-transparent'} rounded-2xl transition-all hover:border-blue-300">
                        <img src="${p.image}" class="w-20 h-20 object-cover rounded-xl">
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="lg:col-span-5 flex flex-col product-info">
            <h3 class="text-5xl font-extrabold text-gray-900 leading-tight mb-4 tracking-tighter"
               >
                ${c.name}
            </h3>



            <div class="bg-blue-50/50 p-6 md:p-8 rounded-[2rem] mb-8 border border-blue-100 shadow-sm overflow-hidden">
                <div class="flex flex-wrap items-baseline gap-x-4 gap-y-2">
        <span class="text-3xl md:text-5xl font-black  tracking-tighter shrink-0" style = "color: #e74c3c;"
              >
            ${c.getPriceFormat(c.discountprice)}
        </span>

                    <span class="text-lg md:text-xl text-gray-400 line-through decoration-gray-400 decoration-1 italic"
                          style="font-family: 'Inter', sans-serif;">
                        ${c.getPriceFormat(c.baseprice)}
                    </span>
                </div>

                <div class="mt-4 flex items-center text-green-700 bg-white border border-green-100 px-4 py-2 rounded-xl w-fit text-sm font-bold shadow-sm">
                    <i class="fa-solid fa-gift mr-2 text-green-500"></i> Quà tặng: ${c.gift}
                </div>
            </div>
            <p style = "margin-bottom: 5px;">Số lượng: ${c.stock_quantity}</p>
            <div class="space-y-4 flex-grow">
                <h3 class="text-[10px] font-bold text-gray-400 uppercase tracking-[0.3em] mb-4"
                    style="font-family: 'Manrope', sans-serif;">
                    Thiết bị đi kèm combo
                </h3>
                <div class="grid grid-cols-1 gap-3">
                    <c:forEach var="i" items="${c.products}">
                        <a href="product-detail?id=${i.product_id}" class="block">
                            <div class="group flex items-center p-4 bg-white border border-gray-100 rounded-2xl hover:border-blue-200 hover:bg-blue-50/30 transition-all cursor-pointer shadow-sm">
                                <div class="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center mr-4 group-hover:scale-110 transition duration-300">
                                    <i class="fa-solid fa-check text-blue-600"></i>
                                </div>
                                <span class="font-bold text-gray-700 text-sm">${i.product_name}</span>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="mt-12 space-y-4">
                <button class="w-full bg-gray-900 text-white py-6 rounded-2xl font-black text-xl hover:bg-blue-700 transition-all duration-500 shadow-2xl shadow-blue-100 uppercase tracking-widest transform active:scale-[0.98]"
                        style="font-family: 'Manrope', sans-serif;">
                    SỞ HỮU NGAY COMBO
                </button>
                <div class="flex justify-center items-center gap-6 text-[10px] text-gray-400 font-bold uppercase tracking-widest">
                    <span><i class="fa-solid fa-truck-fast mr-1 text-blue-500"></i> Miễn phí vận chuyển</span>

                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/common/footer.jsp" />
<script src="assets/js/ctCombo.js"></script>
</body>
</html>
