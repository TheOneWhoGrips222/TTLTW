function exportCSV(headers, rows, filename) {
    const BOM = '\uFEFF';
    const lines = [headers.join(',')];
    rows.forEach(row => {
        lines.push(row.map(cell => {
            const s = String(cell == null ? '' : cell);
            return s.includes(',') || s.includes('"') || s.includes('\n')
                ? '"' + s.replace(/"/g, '""') + '"'
                : s;
        }).join(','));
    });
    const blob = new Blob([BOM + lines.join('\n')], { type: 'text/csv;charset=utf-8;' });
    _download(blob, filename + '.csv');
}

function exportExcel(headers, rows, filename, sheetName) {
    if (typeof XLSX === 'undefined') {
        alert('Đang tải thư viện Excel, vui lòng thử lại sau vài giây...');
        return;
    }
    const data = [headers, ...rows];
    const ws   = XLSX.utils.aoa_to_sheet(data);
    const wb   = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, sheetName || 'Sheet1');

    // Căn chỉnh độ rộng cột tự động
    const colWidths = headers.map((h, i) => ({
        wch: Math.max(h.length, ...rows.map(r => String(r[i] || '').length)) + 2
    }));
    ws['!cols'] = colWidths;

    XLSX.writeFile(wb, filename + '.xlsx');
}

/**
 * Nạp font Unicode hỗ trợ tiếng Việt (đã nhúng sẵn trong pdf-vn-font.js) vào 1
 * instance jsPDF cụ thể. Bắt buộc phải làm bước này vì font 'helvetica' mặc
 * định của jsPDF chỉ hỗ trợ WinAnsi, không vẽ được chữ tiếng Việt có dấu.
 * Trả về true nếu nạp được, false nếu thiếu file font (sẽ fallback về helvetica).
 */
function _ensureVNFont(doc) {
    if (typeof window.PDF_VN_FONT_REGULAR === 'undefined' || typeof window.PDF_VN_FONT_BOLD === 'undefined') {
        console.warn('Thiếu pdf-vn-font.js — PDF xuất ra có thể bị lỗi font tiếng Việt.');
        return false;
    }
    if (!doc.__vnFontLoaded) {
        doc.addFileToVFS('RobotoVN-Regular.ttf', window.PDF_VN_FONT_REGULAR);
        doc.addFont('RobotoVN-Regular.ttf', 'RobotoVN', 'normal');
        doc.addFileToVFS('RobotoVN-Bold.ttf', window.PDF_VN_FONT_BOLD);
        doc.addFont('RobotoVN-Bold.ttf', 'RobotoVN', 'bold');
        doc.__vnFontLoaded = true;
    }
    return true;
}

function exportPDF(headers, rows, filename, title) {
    if (typeof window.jspdf === 'undefined' && typeof jsPDF === 'undefined') {
        alert('Đang tải thư viện PDF, vui lòng thử lại sau vài giây...');
        return;
    }
    const { jsPDF } = window.jspdf || window;
    const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' });

    const hasVNFont = _ensureVNFont(doc);
    const font = hasVNFont ? 'RobotoVN' : 'helvetica';

    if (title) {
        doc.setFontSize(14);
        doc.setFont(font, 'bold');
        doc.text(title, 14, 16);
    }
    doc.setFontSize(9);
    doc.setFont(font, 'normal');
    doc.text('Xuất lúc: ' + new Date().toLocaleString('vi-VN'), 14, title ? 22 : 14);

    doc.autoTable({
        head:       [headers],
        body:       rows,
        startY:     title ? 27 : 20,
        styles:     { font: font, fontStyle: 'normal', fontSize: 9, cellPadding: 3 },
        headStyles: { font: font, fontStyle: 'bold', fillColor: [79, 70, 229], textColor: 255 },
        alternateRowStyles: { fillColor: [248, 249, 250] },
        margin: { left: 14, right: 14 }
    });

    doc.save(filename + '.pdf');
}

/**
 * Xuất PDF chi tiết của 1 kỳ (ngày/tuần/tháng/năm/tùy chỉnh) được chọn trên
 * biểu đồ doanh thu ở Dashboard — gồm phần tóm tắt, bảng sản phẩm đã bán và
 * bảng đơn hàng trong kỳ đó.
 *
 * opts = {
 *   title, sub,                       // tiêu đề + dòng phụ đề (vd: "Ngày 23/05/2026")
 *   revenueText, orderCountText, productsSoldText,
 *   products: [{productName, totalSold, totalRevenue}],
 *   orders:   [{orderId, customerName, createdAt, paymentMethod, paymentStatus, totalAmount}],
 *   filename
 * }
 */
function exportPeriodDetailPDF(opts) {
    if (typeof window.jspdf === 'undefined' && typeof jsPDF === 'undefined') {
        alert('Đang tải thư viện PDF, vui lòng thử lại sau vài giây...');
        return;
    }
    const { jsPDF } = window.jspdf || window;
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });

    const hasVNFont = _ensureVNFont(doc);
    const font = hasVNFont ? 'RobotoVN' : 'helvetica';

    doc.setFontSize(15);
    doc.setFont(font, 'bold');
    doc.text(opts.title || 'Báo cáo doanh thu', 14, 17);

    doc.setFontSize(10);
    doc.setFont(font, 'normal');
    if (opts.sub) doc.text(opts.sub, 14, 24);
    doc.text('Xuất lúc: ' + new Date().toLocaleString('vi-VN'), 14, opts.sub ? 30 : 24);

    let y = opts.sub ? 39 : 33;
    doc.setFontSize(10.5);
    doc.text('Doanh thu: ' + (opts.revenueText || '0 đ'), 14, y);
    doc.text('Số đơn: ' + (opts.orderCountText ?? '0'), 90, y);
    doc.text('SP bán được: ' + (opts.productsSoldText ?? '0'), 140, y);

    y += 8;
    doc.setFont(font, 'bold');
    doc.setFontSize(11.5);
    doc.text('Sản phẩm đã bán', 14, y);
    y += 4;

    const products = opts.products || [];
    doc.autoTable({
        head: [['Tên sản phẩm', 'Số lượng', 'Doanh thu']],
        body: products.length
            ? products.map(p => [p.productName || '', String(p.totalSold ?? 0), fmtVND(p.totalRevenue || 0)])
            : [['Không có sản phẩm nào được bán trong kỳ này.', '', '']],
        startY: y,
        styles:     { font: font, fontStyle: 'normal', fontSize: 9, cellPadding: 3 },
        headStyles: { font: font, fontStyle: 'bold', fillColor: [79, 70, 229], textColor: 255 },
        alternateRowStyles: { fillColor: [248, 249, 250] },
        margin: { left: 14, right: 14 }
    });

    y = doc.lastAutoTable.finalY + 10;
    doc.setFont(font, 'bold');
    doc.setFontSize(11.5);
    doc.text('Đơn hàng trong kỳ', 14, y);
    y += 4;

    const orders = opts.orders || [];
    doc.autoTable({
        head: [['Mã đơn', 'Khách hàng', 'Thời gian', 'Thanh toán', 'Tổng tiền']],
        body: orders.length
            ? orders.map(o => [
                '#' + o.orderId,
                o.customerName || '',
                o.createdAt || '',
                (o.paymentMethod || '') + (o.paymentStatus ? ' · ' + o.paymentStatus : ''),
                fmtVND(o.totalAmount || 0)
            ])
            : [['Không có đơn hàng nào trong kỳ này.', '', '', '', '']],
        startY: y,
        styles:     { font: font, fontStyle: 'normal', fontSize: 9, cellPadding: 3 },
        headStyles: { font: font, fontStyle: 'bold', fillColor: [79, 70, 229], textColor: 255 },
        alternateRowStyles: { fillColor: [248, 249, 250] },
        margin: { left: 14, right: 14 }
    });

    doc.save((opts.filename || 'bao-cao-ky') + '.pdf');
}

function _download(blob, name) {
    const url = URL.createObjectURL(blob);
    const a   = document.createElement('a');
    a.href    = url;
    a.download = name;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { URL.revokeObjectURL(url); a.remove(); }, 500);
}

function fmtVND(v) {
    return new Intl.NumberFormat('vi-VN').format(v) + ' đ';
}